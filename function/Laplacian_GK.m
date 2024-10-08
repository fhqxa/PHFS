function L = Laplacian_GK(X, para)
% each column is a data

if isfield(para, 'o')
    o = para.o;
else
    o = 20;
end;
if isfield(para, 'sigma')
    sigma = para.sigma;
else
    sigma = 1;
end;

    [nFea, nSmp] = size(X);
    D = pdist2(X', X', 'Euclidean' ); %instance之间的相似度（看维度）
    [dumb,idx] = sort(D, 2); % sort each row
    W = spalloc(nSmp,nSmp,20*nSmp);%稀疏
    for i = 1 : nSmp
        W(i,idx(i,2:o+1)) = 1;         
    end
    W = (W+W')/2;
    
    D = diag(sum(W,2)); %对角阵
    L = D - W;
    
    
    
    