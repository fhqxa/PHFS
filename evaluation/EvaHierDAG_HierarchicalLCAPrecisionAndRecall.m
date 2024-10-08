%% Author: Hong Zhao
%% Date: 2016-5-16
%% Example 1:
% DAG=[0,0;1,1;1,1;2,2;2,2;2,2];
% label_test = [4];
% label_predict = [3];
% [PH1, RH1, FH1] = EvaHier_HierarchicalPrecisionAndRecall(label_test,label_predict,DAG); 
%% Example 2:
% clear;clc;
% DAG=[0,0;1,1;1,1;2,2;2,2;2,2];
% label_test = [4 4];
% label_predict = [4 4];
% [PH2, RH2, FH2] = EvaHier_HierarchicalPrecisionAndRecall(label_test,label_predict,DAG);
%% Example 3:
% clear;clc;
% DAG=[0,0;1,1;1,1;2,2;2,2;3,2;6,3;6,3];
% label_test = [4];
% label_predict = [8];
% [PH2, RH2, FH2] = EvaHier_HierarchicalPrecisionAndRecall(label_test,label_predict,DAG);
function [P_LCA, R_LCA, F_LCA] = EvaHierDAG_HierarchicalLCAPrecisionAndRecall( label_test,label_predict,DAG )
%% 考虑预测类别所在树中的结构进行评判。
%% 正确率 PH。
    sumPH = 0;
    sumRH = 0;
    sumFH = 0;
    lengthTest = length(label_test);
    for i = 1:lengthTest
        yTest = DAG_Ancestor(DAG,label_test(i),1);%最后一个参数1是代表包括自己，如果是0则不包括自己 
        yPredict = DAG_Ancestor(DAG,label_predict(i),1);
        temp = yTest(ismember(yTest,yPredict) == 1);
        P_LCA = length(temp) / length(yPredict);
        R_LCA = length(temp) / length(yTest);
        F_LCA = 2 * P_LCA * R_LCA / (P_LCA + R_LCA);
        sumPH = sumPH + P_LCA;
        sumRH = sumRH + R_LCA;
        sumFH = sumFH + F_LCA;
    end
    P_LCA = sumPH / lengthTest;
    R_LCA = sumRH / lengthTest;
    F_LCA = sumFH / lengthTest;

end

