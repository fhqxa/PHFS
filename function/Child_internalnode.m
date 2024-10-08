%% 求中间结点i的子结点（此处，只统计属于非叶子结点的子结点）
% author:tuo qianjuan
% date:2017.7.2
function [ChildrenInternal]=Child_internalnode(tree,i,all_Internal)
All_Leaf=find(tree(:,1)==i);%寻找结点i的所有子结点，这些子结点中包括中间结点和叶子结点，我们只需要挑出中间结点
ChildrenInternal=[];
for j=1:length(All_Leaf)
if length(find(All_Leaf(j)==all_Internal))~=0
    ChildrenInternal=[ChildrenInternal,All_Leaf(j)];
end
end
end