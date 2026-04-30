import csv
import os

def collect_csv_files_from_input(paths_input):
    paths = [p.strip('"') for p in paths_input.strip().split()]
    found_files = []
    for p in paths:
        if os.path.isfile(p) and p.lower().endswith('.csv'):
            found_files.append(os.path.abspath(p))
        elif os.path.isdir(p):
            for root, dirs, files in os.walk(p):
                for file in files:
                    if file.lower().endswith('.csv'):
                        found_files.append(os.path.abspath(os.path.join(root, file)))
    return found_files

def get_field_choices(csv_path):
    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        header = next(reader)
    return [h.strip() for h in header]

def extract_fields(row, field_list):
    vals = []
    # 所有key都strip，防止表头有多余空格
    row_stripped = {k.strip(): v for k, v in row.items()}
    for f in field_list:
        ff = f.strip()
        if ff in row_stripped and row_stripped[ff].strip() != "":
            try:
                vals.append(float(row_stripped[ff]))
            except Exception:
                vals.append(0.0)
        else:
            # print(f"[警告] 字段 {ff} 缺失于当前行，自动填充0")
            vals.append(0.0)
    return vals

def auto_choice(fields, tip, attr_name, need_dim, allow_empty=True):
    while True:
        print(f"\n当前输入的是【{attr_name}】（{tip}）")
        print(f"可选字段: {fields}")
        text = input(
            f"请输入{attr_name}字段名前缀（如“POSITION”/“NORMAL”/“TEXCOORD”），或具体字段（逗号分隔，回车跳过可选）："
        ).strip()
        if not text and allow_empty:
            return []
        if not text and not allow_empty:
            print(f"{attr_name}字段不能为空，请重新输入！")
            continue

        # 若是前缀，如POSITION
        if (text not in fields) and any(f.startswith(text + ".") for f in fields):
            prefix = text
            prefix_fields = [f for f in fields if f.startswith(prefix + ".")]
            if prefix_fields:
                print(f"自动匹配到【{attr_name}】字段有 {len(prefix_fields)} 个通道：{prefix_fields}")
                return prefix_fields
            else:
                print(f"未找到前缀为 {prefix} 的字段，请检查输入。")
                continue

        # 否则认为是具体字段名列表
        splits = [t.strip() for t in text.split(",") if t.strip()]
        result = []
        for s in splits:
            if s in fields:
                result.append(s)
        if not result and not allow_empty:
            print(f"{attr_name}字段不能为空，请重新输入！")
            continue
        print(f"已选择【{attr_name}】字段: {result}")
        return result

def write_obj(vertices, faces, normals=None, uvs=None, filepath="out.obj"):
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write("# OBJ file from CSV\n")
        for v in vertices:
            # 只输出前三维（OBJ只认xyz），多余维（如w）忽略
            f.write("v %.6f %.6f %.6f\n" % (v[0], v[1], v[2]))
        if uvs:
            for uv in uvs:
                f.write("vt %.6f %.6f\n" % (uv[0], uv[1]))
        if normals:
            for n in normals:
                f.write("vn %.6f %.6f %.6f\n" % (n[0], n[1], n[2]))
        for i, face in enumerate(faces):
            idx = [face[0]+1, face[1]+1, face[2]+1]
            if normals and uvs:
                f.write(f"f {idx[0]}/{idx[0]}/{idx[0]} {idx[1]}/{idx[1]}/{idx[1]} {idx[2]}/{idx[2]}/{idx[2]}\n")
            elif normals:
                f.write(f"f {idx[0]}//{idx[0]} {idx[1]}//{idx[1]} {idx[2]}//{idx[2]}\n")
            elif uvs:
                f.write(f"f {idx[0]}/{idx[0]} {idx[1]}/{idx[1]} {idx[2]}/{idx[2]}\n")
            else:
                f.write(f"f {idx[0]} {idx[1]} {idx[2]}\n")
        print(f"已导出OBJ: {filepath}")

def batch_process(csv_files, field_map, out_dir=None):
    for csv_path in csv_files:
        print(f"\n处理文件: {csv_path}")
        vertices, normals, uvs = [], [], []
        with open(csv_path, 'r', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                pos = extract_fields(row, field_map['position'])
                if len(pos) >= 3:
                    vertices.append(pos[:3])
                if field_map['normal']:
                    nor = extract_fields(row, field_map['normal'])
                    if len(nor) >= 3:
                        normals.append(nor[:3])
                if field_map['uv']:
                    uv = extract_fields(row, field_map['uv'])
                    if len(uv) >= 2:
                        uvs.append(uv[:2])
        print(f"[调试] 读取顶点数: {len(vertices)}，法线数: {len(normals)}，UV数: {len(uvs)}")
        faces = []
        for i in range(0, len(vertices) - 2, 3):
            faces.append((i, i+1, i+2))
        if len(vertices) < 3:
            print("[警告] 顶点数不足3个，不生成面！请检查字段映射与CSV内容。")
            continue
        base_name = os.path.splitext(os.path.basename(csv_path))[0]
        # 输出路径安排
        if out_dir:
            os.makedirs(out_dir, exist_ok=True)
            out_path = os.path.join(out_dir, base_name + ".obj")
        else:
            out_path = os.path.join(os.path.dirname(csv_path), base_name + ".obj")
        write_obj(vertices, faces, normals if normals else None, uvs if uvs else None, filepath=out_path)

def main():
    print("CSV批量转OBJ工具（自动查找字段通道数，无须手输xyz等）")
    print("="*46)
    while True:
        paths_input = input("请输入/拖拽csv文件或文件夹路径（支持多个空格隔开）：").strip()
        if not paths_input:
            print("未输入路径，请重试")
            continue
        csv_files = collect_csv_files_from_input(paths_input)
        if not csv_files:
            print("未找到任何csv文件！请重试。")
            continue
        print(f"共找到 {len(csv_files)} 个csv文件")
        break

    out_dir = input("请输入导出OBJ的文件夹（直接回车则每个CSV在其本地文件夹创建OBJ）：").strip().strip('"')
    if out_dir == '':
        out_dir = None

    field_names = get_field_choices(csv_files[0])
    field_map = {}

    # position，必须
    while True:
        pos_fields = auto_choice(field_names, "常为POSITION，自动匹配所有通道", "顶点坐标（position）", 3, allow_empty=False)
        if len(pos_fields) >= 3:
            field_map['position'] = pos_fields
            break
        else:
            print("顶点坐标至少要有3个通道，重新输入！")
    # normal，可选
    normal_fields = auto_choice(field_names, "法线如NORMAL，自动匹配所有通道", "法线（normal）", 3, allow_empty=True)
    field_map['normal'] = normal_fields
    # uv，可选
    uv_fields = auto_choice(field_names, "UV如TEXCOORD，自动匹配所有通道", "UV", 2, allow_empty=True)
    field_map['uv'] = uv_fields

    print("\n字段映射如下：")
    for k, v in field_map.items():
        print(f"  {k}: {v if v else '未指定'}")
    print("\n开始批量导出...")

    batch_process(csv_files, field_map, out_dir)
    input("\n全部导出完成！按回车退出...")

if __name__ == "__main__":
    main()