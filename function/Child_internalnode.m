%% ���м���i���ӽ�㣨�˴���ֻͳ�����ڷ�Ҷ�ӽ����ӽ�㣩
% author:tuo qianjuan
% date:2017.7.2
function [ChildrenInternal]=Child_internalnode(tree,i,all_Internal)
All_Leaf=find(tree(:,1)==i);%Ѱ�ҽ��i�������ӽ�㣬��Щ�ӽ���а����м����Ҷ�ӽ�㣬����ֻ��Ҫ�����м���
ChildrenInternal=[];
for j=1:length(All_Leaf)
if length(find(All_Leaf(j)==all_Internal))~=0
    ChildrenInternal=[ChildrenInternal,All_Leaf(j)];
end
end
end