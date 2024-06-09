# 将txt文件中的标号对应图片移到相应文件中
import os
import shutil


def read_txt(file_path):
    """
    读取 txt 文件，返回一个列表，其中每个元素是 txt 文件中的一行。
    """
    with open(file_path, 'r') as file:
        lines = file.readlines()
    return [line.strip() for line in lines]


def copy_selected_images(image_list, source_dir, target_dir, file_extension='.png'):
    """
    复制选中的图片到目标文件夹。

    参数：
    image_list: 包含图片文件名或路径的列表。
    source_dir: 图片的源文件夹。
    target_dir: 图片的目标文件夹。
    """
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    for image_name in image_list:
        # 添加图片后缀名
        image_name_with_extension = image_name + file_extension
        source_path = os.path.join(source_dir, image_name_with_extension)
        target_path = os.path.join(target_dir, image_name_with_extension)

        # 确保源图片存在
        if os.path.exists(source_path):
            shutil.copy2(source_path, target_path)
            print(f"复制 {source_path} 到 {target_path}")
        else:
            print(f"图片 {source_path} 不存在")


# 设置文件路径
txt_file_path = 'data/SIRST2/trainval.txt'
source_directory = 'data/SIRST2/images'
target_directory = 'data/SIRST/trainval/images'

# 读取 txt 文件并获取图片列表
images_to_select = read_txt(txt_file_path)

# 复制选中的图片到目标文件夹
copy_selected_images(images_to_select, source_directory, target_directory)