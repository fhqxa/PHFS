%% 10-fold Hierarchical SVM
%% Written by Hong Zhao
% 2017-4-11
% Modified by Hong Zhao on May 16th, 2017.
%% Last modified by Hong Zhao with hierarchical SVM on 2018-2-8.
%% Input
% data: the dataset with feature and label;
% numFolds: 10-fold or 5-fold;
% tree: the hierarchical structure of classes;
% flag: the classficiation with different features is used when flag=1;
% feature: the feature subset for each node;
% numberSel: the number of selected feature;
% indices: it depends on numFolds.
%% Output               

function [accuracyMean,accuracyStd,F_LCAMean,FHMean,TIEmean] = FS_Kflod_TopDownKNNClassifierDAG2(data, numFolds, DAG, feature, numberSel,noLeafNode)
KNN_K=1;
%accuracy_k = zeros(1,numFolds);
[X, Y] = creatSubTablezhDAG(data, DAG);
for i = 1:length(noLeafNode) 
    x=X{noLeafNode(i)};
    feature_slct = feature{noLeafNode(i)};
    feature_slct = feature_slct(1:numberSel);
    x = x(:,feature_slct); 
    [~,N]=size([x,Y{noLeafNode(i)}]);
%if (~isempty(x))
    indices = crossvalind('Kfold', length(Y{noLeafNode(i)}), numFolds);
    for k = 1:numFolds
    testID = (indices == k);%//获得test集元素在数据集中对应的单元编号
    trainID = ~testID;%//train集元素的编号为非test元素的编号
    train_Data = x(trainID,:);
    train_Label = data(trainID,N);
    test_Data = x(testID,:);
    test_Label= data(testID,N);
    if isempty(test_Data)
        testID=trainID;%//train集元素的编号为非test元素的编号
        train_Data = x(trainID,:);
        train_Label = data(trainID,N);
        test_Data = x(testID,:);
        test_Label= data(testID,N);
    elseif isempty(train_Data)
       trainID=testID;%//train集元素的编号为非test元素的编号
       train_Data = x(trainID,:);
       train_Label = data(trainID,N);
       test_Data = x(testID,:);
       test_Label= data(testID,N);
    end
    [modelKNN] = ClassificationKNN.fit(train_Data,train_Label,'NumNeighbors',KNN_K);  
    %%           Prediction       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [predict_label] = predict(modelKNN,test_Data);  
    %%          Envaluation       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   [PH(k), RH(k), FH(k)] = EvaHier_HierarchicalPrecisionAndRecallDAG(test_Label,predict_label',DAG);
   [P_LCA(k),R_LCA(k),F_LCA(k)] = EvaHier_HierarchicalLCAPrecisionAndRecallDAG(test_Label,predict_label',DAG);
   TIE(k) = EvaHier_InducedErrorDAG(test_Label,predict_label',DAG);
   %accuracy_k(k) = EvaHier_DAGHierarchicalAccuracy(test_Label,predict_label',DAG);%王煜   
end %num
% accuracyMean = mean(accuracy_k);
% accuracyStd = std(accuracy_k);
F_LCAMean=mean(F_LCA);
FHMean=mean(FH);
TIEmean=mean(TIE);
else
    continue
end
end  % nonleaf
end