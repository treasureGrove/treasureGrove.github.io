import os
from PIL import Image
from upscayl_core import Upscayl

def get_img_files(folder):
    return [f for f in os.listdir(folder) if f.lower().endswith(('.jpg', '.png', '.jpeg', '.bmp', '.png'))]

input_folder = input("请拖入需要放大的图片文件夹，然后回车：").strip('"')
output_folder = os.path.join(input_folder, "upscaled")
os.makedirs(output_folder, exist_ok=True)

upscaler = Upscayl(model_name="Real-ESRGAN", scale=1)  # scale=1表示不放大

img_files = get_img_files(input_folder)
for fname in img_files:
    in_path = os.path.join(input_folder, fname)
    out_path = os.path.join(output_folder, fname)
    try:
        upscaler.upscale(in_path, out_path)
        print(f"{fname} 已放大并保存到 {out_path}")
    except Exception as e:
        print(f"{fname} 处理失败: {e}")

print("全部图片处理完成！")