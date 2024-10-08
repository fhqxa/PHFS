%% Input:
%       tree - A tree structure among the classes  
%% Output:
% noLeafNode - the all non-leaf nodes, which according to the number of layers, the middle nodes are sorted from small to large.  
%          F - the relation matrix among the subtrees
function [noLeafNode,F]=SubtreeRelationMatrix_F(tree)
indexRoot = tree_Root(tree);% The root of the tree
leafNode = tree_LeafNode(tree);
indexRoot=max(indexRoot);
noLeafNode=[indexRoot];
for k=1:max(tree(:,2))-1
    index = setdiff(find(tree(:,2)==k),leafNode); %delete the leaf node.
    noLeafNode=[noLeafNode;index];
end
F=zeros(length(noLeafNode),length(noLeafNode));
for i=1:length(noLeafNode)
    for j=1:length(noLeafNode)
        %if i is the father node of j, or j is the father node of i
       if  noLeafNode(i)==tree(noLeafNode(j),1)||noLeafNode(j)==tree(noLeafNode(i),1)
           F(i,j)=1;
       else
           F(i,j)=0;
       end
    end
end

