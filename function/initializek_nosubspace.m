%Initialize k to be the inverse of the square root of the average loss per sample
function [k] = initializek_nosubspace(X,Y,W)
    [n,d]=size(X);
    L=0;
    for i=1:n
       L = L + norm(Y(i,:)-X(i,:)*W)^2;
    end 
    k=1/sqrt(L/n);
end 