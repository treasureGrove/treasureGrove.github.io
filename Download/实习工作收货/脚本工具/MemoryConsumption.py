import os
from PIL import Image

def estimate_texture_memory(file_path, bytes_per_pixel=4):
    try:
        with Image.open(file_path) as img:
            width, height = img.size
            return width * height * bytes_per_pixel
    except Exception as e:
        print(f"无法解析 {file_path}: {e}")
        return 0

def scan_folder_for_textures(folder, exts=None):
    if exts is None:
        exts = ['.png', '.jpg', '.jpeg', '.tga', '.bmp', '.tiff', '.gif']
    total_memory = 0
    details = []
    for root, _, files in os.walk(folder):
        for file in files:
            ext = os.path.splitext(file)[-1].lower()
            if ext in exts:
                path = os.path.join(root, file)
                mem = estimate_texture_memory(path)
                total_memory += mem
                details.append((file, mem))
    return total_memory, details

def readable_size(size):
    for u in ['B', 'KB', 'MB', 'GB']:
        if size < 1024:
            return f"{size:.2f} {u}"
        size /= 1024
    return f"{size:.2f} TB"

if __name__ == "__main__":
    folder = r"\\booming.com\shared\public\Baolin.Yin\fp_wpn\cod weapon\wpn_mcrp300\blender\textures"
    total_memory, _ = scan_folder_for_textures(folder)
    print(f"总运行时贴图内存消耗: {readable_size(total_memory)}")
