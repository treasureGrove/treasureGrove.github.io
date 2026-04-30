import os
import numpy as np
from PIL import Image

def get_img_files(folder):
    return [f for f in os.listdir(folder) if f.lower().endswith(('.jpg', '.png', '.jpeg', '.bmp'))]

def ahash(img_path):
    img = Image.open(img_path).convert('L').resize((8, 8), Image.Resampling.LANCZOS)
    arr = np.array(img)
    avg = arr.mean()
    hash_arr = arr > avg
    return hash_arr.flatten()

def hamming_dist(hash1, hash2):
    return np.count_nonzero(hash1 != hash2)

folder_a = input("请拖入第一个文件夹A（作为参考命名来源），然后回车：").strip('"')
folder_b = input("请拖入第二个文件夹B（需要重命名），然后回车：").strip('"')

a_files = get_img_files(folder_a)
b_files = get_img_files(folder_b)

a_hashes = [ahash(os.path.join(folder_a, f)) for f in a_files]
b_hashes = [ahash(os.path.join(folder_b, f)) for f in b_files]

for i, b_file in enumerate(b_files):
    bhash = b_hashes[i]
    # 找到A中最相似的图片
    min_dist = float('inf')
    min_idx = -1
    for j, ahash_val in enumerate(a_hashes):
        dist = hamming_dist(bhash, ahash_val)
        if dist < min_dist:
            min_dist = dist
            min_idx = j
    target_name, ext = os.path.splitext(a_files[min_idx])
    b_file_ext = os.path.splitext(b_file)[-1]
    new_name = f"{target_name}{b_file_ext}"
    b_path = os.path.join(folder_b, b_file)
    new_path = os.path.join(folder_b, new_name)
    if os.path.exists(new_path):
        print(f"跳过：{new_name} 已存在")
        continue
    os.rename(b_path, new_path)
    print(f"{b_file} => {new_name}")

print("全部命名完成！")