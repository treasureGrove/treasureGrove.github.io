import os
from PIL import Image

def get_img_files(folder):
    return [f for f in os.listdir(folder) if f.lower().endswith(('.jpg', '.png', '.jpeg', '.bmp', '.tif', '.tiff'))]

input_folder = input("请拖入需要转换的图片文件夹，然后回车：").strip('"')
output_folder = os.path.join(input_folder, "tga_output")
os.makedirs(output_folder, exist_ok=True)

img_files = get_img_files(input_folder)
for fname in img_files:
    in_path = os.path.join(input_folder, fname)
    out_name = os.path.splitext(fname)[0] + ".tga"
    out_path = os.path.join(output_folder, out_name)
    try:
        img = Image.open(in_path)
        img.save(out_path, format="TGA")
        print(f"{fname} => {out_name}")
    except Exception as e:
        print(f"{fname} 转换失败: {e}")

print("全部图片转换完成！")