function[Acc,Bcc,Ccc]=Canonics(A,B,C,D)
[num,den]=ss2tf(A,B,C,D);
n=length(den)-1;
Bcc=zeros(n,1);
Ccc=zeros(1,n);
Acc=diag(ones(1,n-1),1);
Acc=Acc(1:n-1,1:n);
Bcc(n)=1;
num=fliplr(num);
den=fliplr(den);
for i=1:n
    Ccc(i)=num(i)-den(i)*num(n);
end
for j=1:n
   vect(j)=-den(j);
end
Acc=cat(1,Acc,vect);