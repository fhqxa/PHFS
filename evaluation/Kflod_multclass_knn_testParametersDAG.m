% 10-fold cross for mult-class. 
% Done
% knn分类器
%% Parameters:

%% Exapmle:

       
function [accuracyMean, accuracyStd,TIE] = Kflod_multclass_knn_testParametersDAG(varargin)
    if(length(varargin)==5)
        data = varargin{1};
        numFolds = varargin{2};
        indices = varargin{3};
        knn_k = varargin{4};
        DAG = varargin{5};
    else
        if(length(varargin)==6)
            data = [varargin{1},varargin{2}];
            numFolds = varargin{3};  
            indices = varargin{4};
            knn_k = varargin{5};
            DAG = varargin{6};
        end
    end
[M,N]=size(data);
    for k = 1:numFolds
        test = (indices == k);%//获得test集元素在数据集中对应的单元编号
        train = ~test;%//train集元素的编号为非test元素的编号
%         if train == 0
%             train = ~test;
%         else
        train_data = data(train,1:N-1);%//从数据集中划分出train样本的数据
        train_label = data(train,N);
        test_data = data(test,1:N-1);%//test样本集
        test_label = data(test,N); 
        %shijie
        mdl = ClassificationKNN.fit(train_data,train_label,'NumNeighbors',knn_k);   
        predict_label = predict(mdl, test_data);
        TIE(k) = EvaHier_TreeInducedErrorDAG(test_label,predict_label,DAG);
        find_length = length(find(predict_label == test_label));
        accuracy_k(k) = find_length/length(test_label)*100;
%       fprintf(['Accurate = ',num2str(accuracy_k(k)),'%% (', num2str(find_length),'/',num2str(length(test_label)),')\n']);
    end
    accuracyMean = mean(accuracy_k);
    accuracyStd = std(accuracy_k);    
    TIE = mean(TIE);
 end
