function [k]=retroIgualacion(A,B,pol)
n=length(B);
syms k1 k2 k3 k4 k5 k6 k7 k8 k9 k10 k11 k12 k13 k14 k15 k16 k17 k18 k19 k20 s;
kq=[k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,k17,k18,k19,20];
for i=1:n
   K(i)=kq(i);
end
Aast=A-B*K;
SIA=s*eye(n)-Aast;
caract=(det(SIA));
caract=collect(caract,s);
caract=fliplr(coeffs(caract,s));
if(caract(1)==pol(1))
    for j=1:n+1
    eqns(j)= caract(j)==pol(j);
    end
end
k=solve(eqns,K);
