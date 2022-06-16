function[K]=ackerMelo(A,B,pol)
n=length(B);
Ks=[zeros(1,n-1),1];
pol=fliplr(pol);
phiA=pol(1)*eye(n);
for i=1:n
phiA=phiA+pol(i+1)*A^i;
end
S=zeros(n,n);
for j=1:n
   S(:,j)=A^(j-1)*B;
end
K=Ks*inv(S)*phiA;


