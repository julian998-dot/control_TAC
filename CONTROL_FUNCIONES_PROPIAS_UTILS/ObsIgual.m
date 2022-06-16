function [Ke]=ObsIgual(A,C,zeta,ts)
tso=ts/5;
wn=4/(zeta*tso);
n=length(C);
pol=[1 2*zeta*wn wn^2];
if n>2
    while(1)
        pol=conv(pol,[1 5*zeta*wn]);
        if length(pol)==(n+1)
            break
        end
    end
end
syms k1 k2 k3 k4 k5 k6 k7 k8 k9 k10 k11 k12 k13 k14 k15 k16 k17 k18 k19 k20 s;
kq=[k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,k17,k18,k19,20];
for i=1:n
   K(i,1)=kq(i);
end
Aast=A-K*C;
SIA=s*eye(n)-Aast;
caract=(det(SIA));
caract=collect(caract,s);
caract=fliplr(coeffs(caract,s));
if(caract(1)==pol(1))
    for j=1:n+1
    eqns(j)= caract(j)==pol(j);
    end
end
Ke=solve(eqns,K);


