clear;clc;close all;
%% Load dataset
%  load ('VOCTrain');
load('SUNTrain.mat');
%  load ('LandscapeTrain.mat');
% load('AWAphogTrain.mat');%100
% load('ilsvrc65Train.mat')
%load('Car196Train.mat')
% load('Cifar100Train.mat')
% load('DDTrain.mat')
% load('F194Train.mat')
%load('VOCResnet50Train.mat')
%% initialization
Level_num  = max(tree(:,2));
[~, numSelected] = size(data_array);
numSelected = numSelected -1;
%% Creat sub table
[X, Y] = creatSubTablezh(data_array, tree);
Level_num  = max(tree(:,2));
internalNodes = tree_InternalNodes(tree);
indexRoot = tree_Root(tree);% The root of the tree
noLeafNode =[internalNodes;indexRoot];

%% Feature selection
tic;
flag=0;
alpha= ;alphaw= ;alphah= ;K=  ; 
beta= ; mu= ; 
maxIter=10;
[feature] = self_supervisedecomposition0(X,Y,alpha,beta,alphaw,alphah,mu,maxIter,K,tree,flag);
time=toc;

%% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('News20Test.mat');begin1= 2621;step1 = 2621;end1 = 13107;% Corresponding the 10%, 20% and 30% of feature
% [Accuracy, F_LCA,FH,TIE] = KNN_predeict_1(data_array, tree,feature,noLeafNode,begin1,step1,end1)   
% [Accuracy, F_LCA,FH,TIE] = SVM_predeict_1(data_array, tree,feature,noLeafNode,begin1,step1,end1) 