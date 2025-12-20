# -*- coding: utf-8 -*-
import os
import sys

# ============================================================
# 【关键修复】 强制开启 OpenEXR 支持
# 必须在 import cv2 之前设置，否则处理 .exr 文件会报错
# ============================================================
os.environ["OPENCV_IO_ENABLE_OPENEXR"] = "1"

import subprocess
import struct
import math
import pathlib
import traceback

# ============================================================
# 核心逻辑
# ============================================================
def main_wraper():
    try:
        real_main()
    except Exception:
        print("\n" + "!"*60)
        print("程序发生严重错误 (Fatal Error):")
        traceback.print_exc()
        print("!"*60)
        # 这里的 input 也是为了防止双击运行时直接消失
        input("按回车键退出...")

def real_main():
    # 1. 依赖检查
    check_dependencies()
    
    import numpy as np
    import cv2

    print("\n" + "="*50)
    print("  HDR/EXR 转 DDS Cubemap (Radiance)")
    print("  修复: 已开启 OpenEXR 解码支持")
    print("="*50)

    # 2. 获取输入文件
    files = []
    if len(sys.argv) > 1:
        files = sys.argv[1:]
    else:
        print("请把 .hdr/.exr 文件直接拖入窗口，按回车...")
        user_input = input(">>> ").strip()
        if user_input:
            files = [user_input.replace('"', '')]

    if not files: return

    for f in files:
        process_file(f, np, cv2)

    print("\n[全部完成]")

def check_dependencies():
    required = {'numpy': 'numpy', 'cv2': 'opencv-python'}
    for import_name, pkg_name in required.items():
        try:
            import importlib
            importlib.import_module(import_name)
        except ImportError:
            print(f"正在安装: {pkg_name} ...")
            try:
                # 强制用当前 python 解释器安装
                subprocess.check_call([sys.executable, "-m", "pip", "install", pkg_name])
            except Exception:
                print(f"安装 {pkg_name} 失败。请手动运行 pip install {pkg_name}")
                raise

# ============================================================
# 转换逻辑
# ============================================================
CUBEMAP_SIZE = 512
GENERATE_MIPS = True

DDS_MAGIC = b'DDS '
DDSD_CAPS = 0x1 | 0x2 | 0x4 | 0x1000 | 0x20000
DDSCAPS_COMPLEX = 0x8 | 0x1000 | 0x400000
DDSCAPS2_CUBEMAP_ALLFACES = 0xFC00 

def get_face_transform(face_idx, u, v, np):
    if face_idx == 0: return np.stack((np.ones_like(u), -v, -u), axis=-1)   # +X
    if face_idx == 1: return np.stack((-np.ones_like(u), -v, u), axis=-1)   # -X
    if face_idx == 2: return np.stack((u, np.ones_like(v), v), axis=-1)     # +Y
    if face_idx == 3: return np.stack((u, -np.ones_like(v), -v), axis=-1)   # -Y
    if face_idx == 4: return np.stack((u, -v, np.ones_like(u)), axis=-1)    # +Z
    if face_idx == 5: return np.stack((-u, -v, -np.ones_like(u)), axis=-1)  # -Z

def process_file(filepath, np, cv2):
    path = pathlib.Path(filepath)
    if not path.exists():
        print(f"[跳过] 文件不存在: {path}")
        return
        
    print(f"\n>>> 正在读取: {path.name}")

    try:
        # 读取 HDR/EXR (flags=-1 等同于 IMREAD_UNCHANGED)
        img = cv2.imread(str(path), -1)
        
        # 如果读取失败，尝试 Numpy workaround (解决中文路径问题)
        if img is None:
            img_array = np.fromfile(str(path), dtype=np.uint8)
            img = cv2.imdecode(img_array, -1)
            
        if img is None:
            print("[错误] 无法解码文件，文件可能已损坏。")
            return

        # 通道处理
        if img.ndim == 2:
            img = np.stack([img]*3, axis=-1)
        
        # OpenCV 默认读 EXR 为 BGR，必须转 RGB
        if img.shape[2] >= 3:
            img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
            if img.shape[2] > 3: img = img[..., :3] # 扔掉 alpha

        img = img.astype(np.float32)
        h, w = img.shape[:2]

    except Exception as e:
        print(f"[读取异常] {e}")
        return

    # --- 采样 ---
    print(f"    正在计算球面投影 (Size={CUBEMAP_SIZE})...")
    
    lin = np.linspace(-1, 1, CUBEMAP_SIZE, dtype=np.float32)
    u, v = np.meshgrid(lin, lin)
    faces_mips = []

    # 预计算像素映射以加速 (Linear Sampling)
    # 这里为了代码简洁，使用最近邻+resize线性插值
    for i in range(6):
        vec = get_face_transform(i, u, v, np)
        norm = np.linalg.norm(vec, axis=-1, keepdims=True)
        vec = vec / norm
        
        phi = np.arctan2(vec[..., 2], vec[..., 0])
        theta = np.arcsin(np.clip(vec[..., 1], -1.0, 1.0))
        
        uv_u = (phi / (2.0 * np.pi)) + 0.5
        uv_v = 0.5 - (theta / np.pi)
        
        px_x = np.clip(uv_u * (w - 1), 0, w - 1).astype(int)
        px_y = np.clip(uv_v * (h - 1), 0, h - 1).astype(int)
        
        face = img[px_y, px_x] 

        # Mipmap 生成
        mips = [face]
        if GENERATE_MIPS:
            curr = face
            ch, cw = CUBEMAP_SIZE, CUBEMAP_SIZE
            while ch > 1 or cw > 1:
                ch, cw = max(1, ch//2), max(1, cw//2)
                curr = cv2.resize(curr, (cw, ch), interpolation=cv2.INTER_LINEAR)
                mips.append(curr)
        faces_mips.append(mips)

    # --- 写入 DDS ---
    out_name = f"cubemap_{path.stem}_radiance.dds"
    out_path = path.parent / out_name
    print(f"    正在写入 DDS: {out_name}")

    mip_levels = len(faces_mips[0])
    
    header = bytearray(124)
    struct.pack_into('<I', header, 0, 0x7C)
    struct.pack_into('<I', header, 4, DDSD_CAPS)
    struct.pack_into('<I', header, 8, CUBEMAP_SIZE)
    struct.pack_into('<I', header, 12, CUBEMAP_SIZE)
    struct.pack_into('<I', header, 28, mip_levels)
    struct.pack_into('<I', header, 76, 32)
    struct.pack_into('<I', header, 80, 0x4)
    struct.pack_into('<4s', header, 84, b'DX10')
    struct.pack_into('<I', header, 108, DDSCAPS_COMPLEX)
    struct.pack_into('<I', header, 112, DDSCAPS2_CUBEMAP_ALLFACES)

    # DXGI_FORMAT_R16G16B16A16_FLOAT = 10
    dx10 = struct.pack('<I I I I I', 10, 3, 4, 1, 0)

    with open(out_path, 'wb') as f:
        f.write(DDS_MAGIC + header + dx10)
        for face_idx in range(6):
            for mip in faces_mips[face_idx]:
                mh, mw, mc = mip.shape
                # 补全 Alpha=1.0
                alpha = np.ones((mh, mw, 1), dtype=np.float32)
                rgba = np.concatenate([mip, alpha], axis=-1)
                f.write(rgba.astype(np.float16).tobytes())

    print("    [√] 成功！")

if __name__ == "__main__":
    main_wraper()
