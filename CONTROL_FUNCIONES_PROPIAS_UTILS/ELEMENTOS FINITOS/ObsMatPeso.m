function [Ke]=ObsMatPeso(A,C,pol)
n=length(C);
O=zeros(n,n);
for p=1:n
   O(p,:)=C*A^(p-1);
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
Q=inv(M*O);
pol=fliplr(pol);
x=length(Q);
Kl=zeros(x,1);
for i=1:n
    Kl(i,1)=pol(i)-as(i);
end
Ke=Q*Kl;