%% Date: 2018-2-8
% 修改说明：
% 1. 针对所有数据集只选10%20%30%40%50%的特征
% 2. 分类器用SVM参数c=1线性
% 3. 图像的数据集选20%特征；蛋白质数据集选10%特征
function [accuracyMean, accuracyStd, F_LCAMean, FHMean, TIEmean, TestTime] = HierKNNPredictionBatchDAG(data_array, DAG, feature)
[m, numFeature] = size(data_array);
numFeature = numFeature - 1; %%可以删掉，
numFolds  = 10;
k = 1;
%baseline = 0;
% Test all features (baseline)
% Test 50% 40%	30%	20%	10% features.
% numsel_rate = [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4];
numsel_rate = [0.1,0.2,0.3];
nrlen = length(numsel_rate);
for j = 1:nrlen
    numSeleted = round(numFeature * numsel_rate(j));
    accuracyMean(1, k) = numSeleted;
    accuracyStd(1, k) = numSeleted;
    F_LCAMean(1, k) = numSeleted;
    FHMean(1, k) = numSeleted;
    TIEmean(1, k) = numSeleted;
    TestTime(1, k) = numSeleted;
    %rand('seed', 1);
    indices = crossvalind('Kfold', m, numFolds);
    tic;
    [accuracyMean(2, k), accuracyStd(2, k), F_LCAMean(2, k), FHMean(2, k), TIEmean(2, k)] =  FS_Kflod_TopDownKNNClassifierDAG(data_array, numFolds, DAG, feature, numSeleted, indices);
    TestTime(2, k) = toc;
    k = k+1;
end
%  if (baseline == 1)
%     accuracyMean(1, k) = numFeature;
%     accuracyStd(1, k) = numFeature;
%     F_LCAMean(1, k) = numFeature;
%     FHMean(1, k) = numFeature;
%     TIEmean(1, k) = numFeature;
%     TestTime(1, k) = numFeature;
%     rand('seed', 1);
%     indices = crossvalind('Kfold', m, numFolds);
%     tic;
%     [accuracyMean(2, k), accuracyStd(2, k), F_LCAMean(2, k), FHMean(2, k), TIEmean(2, k)] = FS_Kflod_TopDownSVMClassifier(data_array, numFolds, DAG, feature, numFeature, indices);
%     TestTime(2, k) = toc;
%  end
end
