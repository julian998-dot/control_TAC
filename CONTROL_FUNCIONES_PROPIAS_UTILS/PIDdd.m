function [numz,denz,tms]=PIDdd(num,den,ed,tsd)


syms z kp ki kd
ft=tf(num,den);
wnd=4/(ed*tsd);

pd=[1 2*ed*wnd wnd^2];
pd=conv(pd,[1 5*ed*wnd]);
kd=double(solve(den(2)+num*kd==pd(2)));
kp=double(solve(den(3)+num*kp==pd(3)));
ki=double(solve(num*ki==pd(4)));
cs=tf([kd kp ki],[1 0])

tmsup=((wnd*6)/(2*pi))^-1;
tminf=((wnd*25)/(2*pi))^-1;
tm=tsd/10;

wd=wnd*sqrt(1-ed^2);
T=5;
ws=(2*pi)/T;
while (ws/wd)<10
    T=T-0.001;
    ws=(2*pi)/T;
end


fz1=c2d(ft,tm,'zoh')
[numz,denz]=c2dm(num,den,tm,'zoh');
%[0.0008619 0.0008363]

p1=-2*exp(-ed*wnd*tm)*cos(wnd*tm*sqrt(1-ed^2));
p2=exp(-2*ed*wnd*tm);
pd=conv([1 p1 p2],[1 -0.05]);
pd=conv(pd,[1 -0.05]);
pd=pd';

syms z r0 r1 r2 so z

AS=(1+denz(2)*z+denz(3)*z^2)*(1-z)*(1+so*z);
BR=(numz(2)*z+numz(3)*z^2)*(r0+r1*z+r2*z^2);

ASBR=AS+BR;
ASBR=vpa(collect(ASBR,z));
ASBR=vpa(coeffs(ASBR,z));
ASBR=ASBR';

[so,r0,r1,r2]=solve(ASBR==pd,[so,r0,r1,r2]);
disp('COEFICIENTES DE DISEÑO DISCRETO PID:')
so=double(so)
r0=double(r0)
r1=double(r1)
r2=double(r2)
tmsz=T/5;
disp('LA FUNCION EN Z DEL PID ES:')
cz=c2d(cs,tmsz,'tustin')
tms=tmsz;
[numSZ,denSZ]=tfdata(cz,'v');
numz=numSZ;
denz=denSZ;