import torch
from torch.autograd import Variable

import numpy as np
import matplotlib.pyplot as plt
from argparse import ArgumentParser
import cv2


def parse_args():
    #
    # Setting parameters
    #
    parser = ArgumentParser(description='Inference of AGPCNet')

    #
    # Checkpoint parameters
    #
    parser.add_argument('--pkl-path', type=str, default=r'./results/mdfa_mIoU-0.4843_fmeasure-0.6525.pkl',
                        help='checkpoint path')#指定模型的检查点路径

    #
    # Test image parameters
    #
    parser.add_argument('--image-path', type=str, default=r'./data/2.bmp', help='image path')#测试图像的路径
    parser.add_argument('--base-size', type=int, default=256, help='base size of images')#指定图像的基准大小，默认256

    args = parser.parse_args()
    return args



#preprocess_image(img) 函数用于对输入图像进行预处理：
#将图像转换为 numpy 数组，并转换为 BGR 格式。
#对每个通道进行均值归一化和标准差归一化。
#将图像转换为 PyTorch 张量，并调整维度为 (1, C, H, W)
def preprocess_image(img):
    means=[0.485, 0.456, 0.406]
    stds=[0.229, 0.224, 0.225]

    preprocessed_img = img.copy()[: , :, ::-1]
    for i in range(3):
        preprocessed_img[:, :, i] = preprocessed_img[:, :, i] - means[i]
        preprocessed_img[:, :, i] = preprocessed_img[:, :, i] / stds[i]
    preprocessed_img = \
        np.ascontiguousarray(np.transpose(preprocessed_img, (2, 0, 1)))
    preprocessed_img = torch.from_numpy(preprocessed_img)
    preprocessed_img.unsqueeze_(0)
    input = Variable(preprocessed_img, requires_grad = True)
    return input


if __name__ == '__main__':
    args = parse_args()

    # load network
    print('...load checkpoint: %s' % args.pkl_path)
    net = torch.load(args.pkl_path, map_location=torch.device('cpu'))
    net.eval()

    # load image
    print('...loading test image: %s' % args.image_path)
    img = cv2.imread(args.image_path, 1)
    img = np.float32(cv2.resize(img, (args.base_size, args.base_size))) / 255
    input = preprocess_image(img)#预处理

    # inference in cpu
    print('...inference in progress')
    with torch.no_grad():
        output = net(input)

    output = output.cpu().detach().numpy().reshape(args.base_size, args.base_size)
    output = output > 0

    # show results
    plt.figure()
    plt.subplot(121), plt.imshow(img, cmap='gray'), plt.title('Original Image')
    plt.subplot(122), plt.imshow(output, cmap='gray'), plt.title('Inference Result')
    plt.show()