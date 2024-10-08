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
function [accuracyMean,accuracyStd,F_LCAMean,FHMean,TIEmean] = FS_Kflod_TopDownKNNClassifierDAG1(data, numFolds, DAG, feature, numberSel,indices)
KNN_K=1;
[M,N]=size(data);
accuracy_k = zeros(1,numFolds);

for k = 1:numFolds
    testID = (indices == k);%//获得test集元素在数据集中对应的单元编号
    trainID = ~testID;%//train集元素的编号为非test元素的编号
    test_Data = data(testID,1:N-1);
    test_Label = data(testID,N);
    train_Data = data(trainID,:);   
    %% Creat sub table
    [trainDataMod, trainLabelMod] = creatSubTablezhDAG(train_Data, DAG);    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Train classifiers of all internal nodes
     trainLabel = trainLabelMod;
     trainData = trainDataMod;
     selFeature = feature(1:numberSel);
     [modelKNN] = ClassificationKNN.fit(trainData(:,selFeature),trainLabel,'NumNeighbors',KNN_K);   
    %%           Prediction       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [predict_label] = predict(modelKNN,test_Data);
    %%          Envaluation       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   [PH(k), RH(k), FH(k)] = EvaHier_HierarchicalPrecisionAndRecallDAG(test_label,predict_label',DAG);
   [P_LCA(k),R_LCA(k),F_LCA(k)] = EvaHier_HierarchicalLCAPrecisionAndRecallDAG(test_label,predict_label',DAG);
   TIE(k) = EvaHier_InducedErrorDAG(test_label,predict_label',DAG);
   accuracy_k(k)=EvaHier_DAGHierarchicalAccuracy(test_label,predict_label', DAG);%王煜
end

   accuracyMean = 1;%mean(accuracy_k);
   accuracyStd = 1;%std(accuracy_k);
    F_LCAMean=mean(F_LCA);
    FHMean=mean(FH);
    TIEmean=mean(TIE);

end