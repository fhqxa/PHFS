%update U  原论文
% function [U] = updateU(W)
%     [d,K]=size(W);
%     U=zeros(d);
%     for i=1:d
%         temp=sum(W(i,:).*W(i,:))^(3/4);
%         U(i,i)=1/max(temp,eps);
%     end 
% end 

%%2022.9.2 石杰
function [U] = updateU(W)
    [d,K]=size(W);
    U=zeros(d);
    for i=1:d
        temp=sum(W(i,:).*W(i,:))^(1/2);
        U(i,i)=1/max(temp,eps);
    end 
end 