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
function [accuracyMean,accuracyStd,F_LCAMean,FHMean,TIEmean] = FS_Kflod_TopDownKNNClassifierDAG(data, numFolds, DAG, feature, numberSel,indices)
[M,N]=size(data);
accuracy_k = zeros(1,numFolds);
% indices = crossvalind('Kfold',data(1:M,N),numFolds);%//进行随机分包 for k=1:10//交叉验证k=10，10个包轮流作为测试集
%     save indices10001 indices;
%        load indices1000;
KNN_K=1;
for k = 1:numFolds
    testID = (indices == k);%//获得test集元素在数据集中对应的单元编号
    trainID = ~testID;%//train集元素的编号为非test元素的编号
    test_data = data(testID,1:N-1);
    test_label = data(testID,N);
    train_data = data(trainID,:);
    
    %% Creat sub table
    [trainDataMod, trainLabelMod] = creatSubTablezhDAG(train_data, DAG);
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Train classifiers of all internal nodes
    indexRoot = DAG_Root(DAG);
    internalNodes = DAG_InternalNode(DAG, indexRoot);
    noLeafNode =[internalNodes;indexRoot];
    noi_nl = [];
    for noi = 1:length(noLeafNode)
        if isempty(trainLabelMod{noLeafNode(noi)})
            noi_nl = [noi_nl, noi];
        else 
            continue
        end
    end 
    noLeafNode(noi_nl) = [];
    
    numNodes = length(noLeafNode);%ZH: The total of all nodes.
    for i = 1:numNodes
%         if (~ismember(i, DAG_LeafNode(DAG, DAG_Root(DAG)))) && (~isempty(trainLabelMod{i})) && (~isempty(feature{i}))
        if (~isempty(feature{noLeafNode(i)}))
            trainLabel = trainLabelMod{noLeafNode(i)};
            trainData = trainDataMod{noLeafNode(i)};
%           trainLabel = sparse(trainLabelMod{i});
%           trainData = sparse(trainDataMod{i});
            selFeature = feature{noLeafNode(i)}(1:numberSel);
            [modelKNN{noLeafNode(i)}] = ClassificationKNN.fit(trainData(:,selFeature),trainLabel,'NumNeighbors',KNN_K);   
%             [model{i}]  = train(double(trainLabel), sparse(trainData(:,selFeature(1:numberSel))), '-c 2 -s 0 -B 1 -q');
        else          
             noLeafNode(i)
        end
    end
    
    %%           Prediction       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [predict_label] = FS_TopDownKNNPredictionDAG(test_data, modelKNN, DAG,feature,numberSel) ;

    %%          Envaluation       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   [PH(k), RH(k), FH(k)] = EvaHier_HierarchicalPrecisionAndRecallDAG(test_label,predict_label',DAG);
   [P_LCA(k),R_LCA(k),F_LCA(k)] = EvaHier_HierarchicalLCAPrecisionAndRecallDAG(test_label,predict_label',DAG);
   TIE(k) = EvaHier_InducedErrorDAG(test_label,predict_label',DAG);
   %accuracy_k(k) ; %%%EvaHier_DAGHierarchicalAccuracy(test_label,predict_label', DAG);%王煜
    
end
 accuracyMean = 1;%mean(accuracy_k);
 accuracyStd = 1;%std(accuracy_k);
F_LCAMean=mean(F_LCA);
FHMean=mean(FH);
TIEmean=mean(TIE);
end