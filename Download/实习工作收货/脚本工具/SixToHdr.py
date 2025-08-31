import os
import glob
import numpy as np
import torch
import clip
import imageio.v3 as iio
from PIL import Image

cube_dir = r"C:\Users\baolin.yin\Desktop\tex\hdr"
cube_pattern = os.path.join(cube_dir, "[1-6].png")
output_name = "output_equirectangular.png"
output_w, output_h = 2048, 1024

def read_img(path):
    img = Image.open(path)
    arr = np.array(img)
    arr = arr if arr.ndim == 3 else np.stack([arr]*3, axis=-1)
    if arr.shape[2] > 3:
        arr = arr[..., :3]
    arr = arr.astype(np.float32)
    arr /= 65535.0 if arr.dtype == np.uint16 else 255.0
    return arr

def img_for_clip(path):
    arr = read_img(path)
    arr = np.clip(arr / np.percentile(arr, 99), 0, 1)
    arr = (arr * 255).astype('uint8')
    return Image.fromarray(arr)

def detect_cube_faces(files):
    device = "cuda" if torch.cuda.is_available() else "cpu"
    model, preprocess = clip.load("ViT-B/32", device=device)
    prompts = [
        "sky or ceiling or clouds view",   # +Y
        "ground or floor or earth view",   # -Y
        "look forward outdoor",            # +Z
        "look back indoor",                # -Z
        "look right",                      # +X
        "look left"                        # -X
    ]
    text = clip.tokenize(prompts).to(device)
    imgs = [img_for_clip(path) for path in files]
    scores = np.zeros((6,6))
    with torch.no_grad():
        for i, img in enumerate(imgs):
            img_tensor = preprocess(img).unsqueeze(0).to(device)
            feat = model.encode_image(img_tensor)
            logit = (feat @ model.encode_text(text).T).cpu().numpy()
            scores[i,:] = logit
    assigned = [-1]*6
    used = set()
    for face in range(6):
        idx = np.argmax(scores[:, face])
        while idx in used:
            scores[idx, face] = -1e10
            idx = np.argmax(scores[:, face])
        assigned[face] = idx
        used.add(idx)
    mapping = {
        '+Y': assigned[0], '-Y': assigned[1],
        '+Z': assigned[2], '-Z': assigned[3],
        '+X': assigned[4], '-X': assigned[5],
    }
    face_names = ['+X', '-X', '+Y', '-Y', '+Z', '-Z']
    face_filenames = [files[mapping[x]] for x in face_names]
    print("[INFO] Cube分面识别如下：")
    for tag in face_names:
        print(f" {tag}: {files[mapping[tag]]}")
    return face_filenames

def direction_to_cube_face(px, py, pz):
    absX, absY, absZ = abs(px), abs(py), abs(pz)
    isXPositive, isYPositive, isZPositive = px > 0, py > 0, pz > 0
    ma = max(absX, absY, absZ)
    if ma == absX:
        if isXPositive:
            face_idx = 0; sc = -pz/absX; tc = -py/absX   # +X
        else:
            face_idx = 1; sc = pz/absX;  tc = -py/absX   # -X
    elif ma == absY:
        if isYPositive:
            face_idx = 2; sc = px/absY;  tc = pz/absY    # +Y
        else:
            face_idx = 3; sc = px/absY;  tc = -pz/absY   # -Y
    else:
        if isZPositive:
            face_idx = 4; sc = px/absZ;  tc = -py/absZ   # +Z
        else:
            face_idx = 5; sc = -px/absZ; tc = -py/absZ   # -Z
    return face_idx, sc, tc

def texel_coord(size, sc, tc):
    u = (sc + 1) * 0.5 * (size - 1)
    v = (tc + 1) * 0.5 * (size - 1)
    return int(np.clip(u, 0, size-1)), int(np.clip(v, 0, size-1))

def convert_cube_to_equirectangular(face_filenames, output_name, w, h):
    cube_faces = [read_img(fname) for fname in face_filenames]
    face_size = cube_faces[0].shape[0]
    out = np.zeros((h, w, 3), dtype=np.float32)
    for y in range(h):
        phi = np.pi * (y + 0.5) / h  # [0,pi]
        for x in range(w):
            theta = 2 * np.pi * (x + 0.5) / w - np.pi
            dx = np.sin(phi) * np.cos(theta)
            dy = np.cos(phi)
            dz = -np.sin(phi) * np.sin(theta)
            idx, sc, tc = direction_to_cube_face(dx, dy, dz)
            ix, iy = texel_coord(face_size, sc, tc)
            out[y, x, :] = cube_faces[idx][iy, ix, :3]
    save = np.clip(out, 0, 1)
    save = (save * 255).astype(np.uint8)
    iio.imwrite(output_name, save)
    print(f"[INFO] 已保存 {output_name}（8位PNG）。如需16位HDR请用TIFF/EXR保存")
    return out

def main():
    files = sorted(glob.glob(cube_pattern))
    assert len(files) == 6, "未找到6张Cube贴图"
    face_filenames = detect_cube_faces(files)
    convert_cube_to_equirectangular(face_filenames, output_name, output_w, output_h)

if __name__ == "__main__":
    main()
