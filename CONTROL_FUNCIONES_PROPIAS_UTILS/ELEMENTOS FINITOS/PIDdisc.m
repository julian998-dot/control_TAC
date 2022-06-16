function [PID]=PIDdisc(num,den,zeta,Ts,TmP,TmC)
if length(den)==3%si planta de orden 2
    wn=4/(zeta*Ts);
    wd=wn*sqrt(1-zeta^2);
    ws=(2*pi)/TmC;
    m=exp(-(2*pi*zeta*wd)/(sqrt(1-zeta^2)*ws));
    phi=2*pi*(wd/ws);
    Pol_des=[1 -2*m*cos(phi) m^2];
    Pol_des=conv(Pol_des,[1 -0.05]);
    Pol_des=conv(Pol_des,[1 -0.05])
    %%Discretiza planta
    planta=tf(num,den);
    plantaD=c2d(planta,TmP,'zoh')
    numD=plantaD.Numerator{1,1};
    denD=plantaD.Denominator{1,1};
    %%%%%%%%%%%%%%%%%
    syms q0 q1 q2 s0 z
    A=numD(1)*z^2+numD(2)*z+numD(3);
    B=denD(1)*z^2+denD(2)*z+denD(3);
    C=q0*z^2+q1*z+q2;
    D=z^2+z*(1+s0)+s0;
    denO=B*D+A*C;
    denO=fliplr(coeffs(denO,z))
    [q0,q1,q2,s0]=solve(denO==Pol_des,[q0,q1,q2,s0]);
    q0=double(eval(q0))
    q1=double(eval(q1))
    q2=double(eval(q2))
    s0=double(eval(s0))
    PIDD=tf([q0,q1,q2],[1,(s0+1),s0],TmC)
else
   disp('Planta de orden mayor a 2')
end