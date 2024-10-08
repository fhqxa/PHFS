%% %% 统计两个结点间边的条数。
% Paper: Large Margin Hierarchical Classification, 2004.
% DAG Induced Error
% Idea: For any pair of labels $u, v \in Y$, let $\gamma(u, v)$ denote their distance in the DAG.
% That is, $\gamma(u, v)$ is defined to be the number of edges along the (unique) path from $u$ to $v$ in $T$.
% The distance function $\gamma(\cdot, \cdot)$ is in fact a metric over $Y$ since it is a non-negative function, $\gamma(u, v) = 0$, $\gamma(u, v) = \gamma(v, u)$ and the triangle inequality always holds with equality.
% As stated above, different classification errors incur different levels of penalty, and in our model this penalty is defined by the DAG distance $\gamma(u, v)$.
% We therefore say that the \textit{DAG Induced Error} incurred by predicting the label $v$ when the correct label is $u$ is $\gamma(u, v)$ \cite{Dekel2004Large}.
%% Author: Hong Zhao
%% Date: 2016-5-13
%% Example:
% DAG=[0,0;1,1;1,1;2,2;2,2;2,2];
% label_test = 4;
% label_predict = 6;
% TIE1 = EvaHier_DAGInducedError(label_test,label_predict,DAG); %ans=2
% label_test = 4;
% label_predict = 3;
% TIE2 = EvaHier_DAGInducedError(label_test,label_predict,DAG);%ans=3
%% 
function [ TIE ] = EvaHier_TreeInducedErrorDAG(label_test,label_predict,DAG)
    TIE = 0;
    for i = 1:length(label_test)
        l1 = DAG_Ancestor(DAG,label_test(i),1);
        l2 = DAG_Ancestor(DAG,label_predict(i),1);
        b = l1(ismember(l1,l2)==0);
        c = l2(ismember(l2,l1)==0);
        TIE = TIE + length([c,b]);
    end
end

