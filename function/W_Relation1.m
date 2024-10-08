%% Compute W_Ri, it presents the relationship weight matrix of the node i
%W_Ri=(W_Pi+sum(W_Ci))/(Ci_num+1)
%%  W_R{noLeafNode(j)}=W_Relation(tree,noLeafNode(j),W,noLeafNode,d ,s);
function [W_R]=W_Relation1(tree,i,W,all_Internal,d,K) 
%如果i的父节点是0，也就是i是根节点，更新它时，只计算它的子结点。
if tree_Parent(tree,i)==0
   ChildrenNode=Child_internalnode(tree,i,all_Internal);%返回结点i对应的非叶子结点的子结点
   W_ChildrenSum=zeros(d,K);
   for t=1:length(ChildrenNode)
      W_ChildrenSum=W_ChildrenSum+W{ChildrenNode(t)};    
   end
   W_R=W_ChildrenSum/length(ChildrenNode);
else
 %否则，计算它的父结点和子结点
   ParentNode=tree_Parent(tree,i);%返回结点i对应的父结点
   W_Parent=W{ParentNode};%非叶子结点i的父结点的权重
   ChildrenNode=Child_internalnode(tree,i,all_Internal);%返回结点i对应的非叶子结点的子结点
   if isempty(ChildrenNode)%判断没有子结点时，只和父结点有关
      W_R=W_Parent;
   else%判断有子结点的时，父结点和子结点都有关系
      W_ChildrenSum=zeros(d,K);
      for t=1:length(ChildrenNode)
         W_ChildrenSum=W_ChildrenSum+W{ChildrenNode(t)};    
      end
      W_R=(W_Parent+W_ChildrenSum)/(length(ChildrenNode)+1);
   end
end

