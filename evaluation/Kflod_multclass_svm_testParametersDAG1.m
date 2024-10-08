% 10-fold cross for mult-class.
%% Parameters:
%  data - The matrix of input vectors, one per row.
%  numFolds - The number of Fold.
% Returns:
%   The accuracy.
% $Author: HongZhao $          $Date: 2015/12/17 11:29 $    $Revision: 2.0 $
% 2016-7-18
%% Exapmle:
% load data4_vocTest;
% [m,n]=size(data_array);
% X = data_array(:,1:n-1);
% y = data_array(:,n);
% numFolds = 10;
% parameter = 10;
%[predict_label,accuracyMean, accuracyStd] = Kflod_multclass_svm_testParameters(X, y, numFolds,parameter,indices);
%[predict_label,accuracyMean, accuracyStd] = Kflod_multclass_svm_testParameters(data_array, numFolds,parameter,indices)
%% 
function [accuracyMean, accuracyStd, F_LCA ] = Kflod_multclass_svm_testParametersDAG1(data, numFolds, DAG, feature, numberSel,indices)
% if(length(varargin)==5)
%     data = varargin{1};
%     numFolds = varargin{2};
%     parameter = varargin{3};
%     indices = varargin{4};
%     DAG = varargin{5};
% else
%     if(length(varargin)==6)
%         data = [varargin{1},varargin{2}];
%         numFolds = varargin{3};
%         parameter = varargin{4};
%         indices = varargin{5};
%         DAG = varargin{6};
%     end
% end
[M,N]=size(data);
accuracy_k = zeros(1,numFolds);

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
        if (~isempty(feature{noLeafNode(i)}))
            train_data = trainDataMod{noLeafNode(i)};
            train_label = trainLabelMod{noLeafNode(i)};
            selFeature = feature{noLeafNode(i)}(1:numberSel);
            str=['-c ' num2str(parameter) ' -t 0 -q'];
            [modelSVM{noLeafNode(i)}]  = svmtrain(train_label,train_data(:,selFeature), str);
        else          
             noLeafNode(i)
        end
    end
    [predict_label, accuracy, dec_values] = svmpredict(test_label,test_data, model);
     [P_LCA ,R_LCA ,F_LCA ] = EvaHierDAG_HierarchicalLCAPrecisionAndRecall( test_label,predict_label,DAG );
    accuracy_k(k) = accuracy(1);
     F_LCA_k(k)=F_LCA ;
end
accuracyMean = mean(accuracy_k);
accuracyStd = std(accuracy_k);
 F_LCA = mean(F_LCA_k);
end
