import os
from collections import Counter
from PIL import Image

def get_all_image_files(root_dir, exts=None):
    if exts is None:
        exts = {'.jpg', '.jpeg', '.png', '.bmp', '.tif', '.tiff', '.webp', '.tga'}
    exts = set(e.lower() for e in exts)
    image_files = []
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            ext = os.path.splitext(file)[-1].lower()
            if ext in exts:
                image_files.append(os.path.join(root, file))
    return image_files
def count_image_sizes(image_files):
    size_counter = Counter()
    for img_path in image_files:
        try:
            with Image.open(img_path) as img:
                w, h = img.size
                size_counter[f"{w}x{h}"] += 1
        except Exception as e:
            print(f"Error processing {img_path}: {e}")
    return size_counter

if __name__ == "__main__":
    folder = r"\\booming.com\shared\public\Baolin.Yin\fp_wpn\cod weapon\wpn_mcrp300\blender\textures"  # 你的图片目录
    files = get_all_image_files(folder)
    print(f"Found {len(files)} images.")

    size_counts = count_image_sizes(files)
    print("Resolution\tCount")
    for size, count in size_counts.most_common():
        print(f"{size}\t{count}")
