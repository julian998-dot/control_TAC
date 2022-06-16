function [Ke]=ObsAcker(A,B,C,pol)
n=length(B);
Ks=[zeros(n-1,1);1];
pol=fliplr(pol);
for p=1:n
   O(p,:)=C*A^(p-1);
end
phiA=pol(1)*eye(n);
for i=1:n
phiA=phiA+pol(i+1)*A^i;
end
Ke=phiA*(inv(O))*Ks;