%% Top-down prediction
% Written by Yu Wang 
% Modified by Hong Zhao
% 2017-4-11
%% Inputs:
% input_data: training data without labels
% model: 
% tree: the tree hierarchy
%% Output

function [predict_label] = FS_TopDownKNNPredictionDAG(input_data, model, DAG, feature,numberSel)    
    [m,~]=size(input_data);
    root = DAG_Root(DAG);      
	for j=1:m %The number of samples
%% 先从树根开始
         selFeature = feature{root}(1:numberSel);
         [currentNode] = predict(model{root},input_data(j,selFeature));  
    %% 递归调用中间层直到叶子结点
        while(~isempty(model{currentNode}))
          selFeature = feature{currentNode}(1:numberSel);
          [predict_label] =predict(model{currentNode},input_data(j,selFeature) );%,selFeature
        end
        predict_label(j)=currentNode;        
    end
end
