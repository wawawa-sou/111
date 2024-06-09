# 按照8：2的比例划分数据集并把编号放入txt文档中


import numpy as np
import os

# 生成图像编号
num_images = 427
image_ids = [f"Misc_{i+1}" for i in range(num_images)]

# 打乱图像编号
np.random.seed(0)
np.random.shuffle(image_ids)

# 按照8:2的比例划分数据集
train_size = int(0.8 * len(image_ids))  # 80% 训练集
train_ids = image_ids[:train_size]
test_ids = image_ids[train_size:]

# 创建文件夹以保存txt文件（如果不存在的话）
os.makedirs('output', exist_ok=True)

# 保存训练集图片编号
with open('data/SIRST/trainval.txt', 'w') as f:
    for id in train_ids:
        f.write(f"{id}\n")

# 保存测试集图片编号
with open('data/SIRST/test.txt', 'w') as f:
    for id in test_ids:
        f.write(f"{id}\n")

# 打印信息
print(f'训练集大小: {len(train_ids)}')
print(f'测试集大小: {len(test_ids)}')
print('训练集和测试集图片编号已分别保存到output文件夹中的train_indices.txt和test_indices.txt文件中。')