import torch
import torch.nn as nn
import torch.utils.data as Data

from utils.metrics import SegmentationMetricTPFNFP, ROCMetric
from utils.data import *

from tqdm import tqdm
from sklearn.metrics import auc
from argparse import ArgumentParser


# 解析命令行函数
def parse_args():
    #
    # Setting parameters
    #
    parser = ArgumentParser(description='Evaluation of networks')

    #
    # Dataset parameters
    #
    parser.add_argument('--base-size', type=int, default=256, help='base size of images')
    parser.add_argument('--dataset', type=str, default='mdfa', help='choose datasets')
    parser.add_argument('--sirstaug-dir', type=str, default=r'data\sirst_aug',
                        help='dir of dataset')
    parser.add_argument('--mdfa-dir', type=str, default=r'data\MDFA\data',
                        help='dir of dataset')

    #
    # Evaluation parameters
    #
    parser.add_argument('--batch-size', type=int, default=8, help='batch size for training')
    parser.add_argument('--ngpu', type=int, default=0, help='GPU number')

    #
    # Network parameters
    #
    parser.add_argument('--pkl-path', type=str, default=r'./results/mdfa_mIoU-0.4843_fmeasure-0.6525.pkl',
                        help='checkpoint path')

    args = parser.parse_args()
    return args


if __name__ == '__main__':
    args = parse_args()#解析命令行函数

    # set device
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

    # load checkpoint
    print('...load checkpoint: %s' % args.pkl_path)
    net = torch.load(args.pkl_path, map_location=device)
    net.eval()

    # define dataset
    if args.dataset == 'sirstaug':
        dataset = SirstAugDataset(base_dir=args.sirstaug_dir, mode='test')
    elif args.dataset == 'mdfa':
        dataset = MDFADataset(base_dir=args.mdfa_dir, mode='test', base_size=args.base_size)
    elif args.dataset == 'merged':
        dataset = MergedDataset(mdfa_base_dir=args.mdfa_dir,
                                sirstaug_base_dir=args.sirstaug_dir,
                                mode='test', base_size=args.base_size)
    else:
        raise NotImplementedError
    data_loader = Data.DataLoader(dataset, batch_size=args.batch_size, shuffle=False)

    # 评估指标对象 metrics 和 metric_roc，用于评估模型在测试集上的性能
    # metrics
    metrics = SegmentationMetricTPFNFP(nclass=1)
    metric_roc = ROCMetric(nclass=1, bins=200)

    # evaluation
    # 使用 tqdm 进度条遍历测试数据集，逐批输入数据到模型中进行评估
    tbar = tqdm(data_loader)
    for i, (data, labels) in enumerate(tbar):
        with torch.no_grad():
            data = data.to(device)
            labels = labels.to(device)
            output = net(data)

        metrics.update(labels=labels, preds=output)
        metric_roc.update(labels=labels, preds=output)

    miou, prec, recall, fmeasure = metrics.get()
    tpr, fpr = metric_roc.get()
    auc_value = auc(fpr, tpr)

    # show results
    print('dataset: %s, checkpoint: %s' % (args.dataset, args.pkl_path))
    print('Precision: %.4f | Recall: %.4f | mIoU: %.4f | F-measure: %.4f | AUC: %.4f'
          % (prec, recall, miou, fmeasure, auc_value))



