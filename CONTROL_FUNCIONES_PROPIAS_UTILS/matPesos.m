function [K]=matPesos(A,B,pol)
n=length(B);
S=zeros(n,n);
for p=1:n
   S(:,p)=A^(p-1)*B;
end
syms s
as=coeffs((det(s*eye(n)-A)),s);
M=zeros(n,n);
for i=1:n
    for j=1:n
        if j<=(n-i+1)
            M(i,j)=as(i+j);
        end
    end
end
T=S*M;
Ka=zeros(1,length(T));
pol=fliplr(pol);
for i=1:n
    Ka(1,i)= pol(i)-as(i);
end
K=Ka*(inv(T));