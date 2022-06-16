% clear all
clc
format shortEng

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% PONER EL NUMERADOR Y DENOMINADOR DE LA PLANTA Y CORRER EL PROGRAMA %%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lam1=3;
% %Numerador de la planta
% a=10.12;
% %Denominador de la planta
% b=[1 23.4 46}.5];

a=[-27.78];
b=[1 10.94 27.78];

% a=0.0237;
% b=[1 28.99 90.44];

[r,p,k]=residue(a,b);

%Se declara como sistema continuo
sys=tf(a,b);

%Parametros de diseño
tsd=input('Tiempo de establecimiento deseado (segundos): ');
ed=input('Zita deseado: ');
wnd=4/(ed*tsd);
tm=input('Tiempo de muestreo deseado (segundos): ');
wd=wnd*sqrt(1-ed^2);
ws=2*pi/tm;
condicion=ws>8*wd

%Ubicacion del polo deseado
zmag=exp(-tm*ed*wnd);
zang=tm*wd;
zfase=rad2deg(zang);
%polo deseado en coordenadas cartesianas
[re,im]=pol2cart(zang,zmag);
P=re+j*im

%Discretizacion del sistema
sysd=c2d(sys,tm,'zoh');
[sysdn,sysdd]=c2dm(a,b,tm,'zoh');
%Visualizacion de zeros y polos
Planta_Discreta=zpk(sysd)

% polos y zeros del sistema
R=pole(sysd);
Z=zero(sysd);
[cR,fR1]=size(R);
[cZ,fZ1]=size(Z);

syms z

[pzc,pzf]=size(sysdn);
plantaz=0;
for c = 1:pzf
    plantaz=plantaz+(z^(c-1)*sysdn(pzf-c+1));
end
plantaz2=1;
for c = 1:cR
    plantaz2=plantaz2*(z-R(c));
end
plantaz=plantaz/plantaz2;


for c = 1:cR
    thetaPlanta(c)=rad2deg(angle(P-R(c)));
end
for c = 1:cZ
    phiPlanta(c)=rad2deg(angle(P-Z(c)));
end
thintegrador=rad2deg(angle(P-1));
thetaPlanta
phiPlanta

th=0;
for c = 1:cZ
    th=th+phiPlanta(c);
end
for c = 1:cR
    th=th-thetaPlanta(c);
end

%angulo actual
thactual=th
%angulo a compensar
thcompensar=180+th

polos=input('Cuantos polos quiere eliminar?: ');
if polos > 1
    for c = 1:polos
        np=['Numero del polo #',c+48,' que quiere eliminar: '];
        PoloEliminar(c)=input(np);
    end
else
    PoloEliminar=input('Numero del polo que quiere eliminar: ');
end

thetaPlanta(:,[PoloEliminar])=[];
[cR2,fR2]=size(thetaPlanta);

thb=180;
for c = 1:cZ
    thb=thb+phiPlanta(c);
end
if cR2 == 1
    if thetaPlanta > 0
        for c = 1:cR2
            thb=thb-thetaPlanta(c);
        end
    end
else
    for c = 1:cR2
        thb=thb-thetaPlanta(c);
    end
end

integrador=input('Cuantos integradores desea poner al controlador: ');

clc
thb;
thbeta=thb-thintegrador^integrador

%calculamos el angulo de beta
beta=-(im/tand(thbeta))+re

controlz=1;
if polos == 1
    controlz=(z-R(PoloEliminar(1)));
elseif polos > 1
    for c = 1:polos
        controlz=controlz*(z-R(PoloEliminar(c)));
    end
end

LGRn=collect(controlz,z);
LGRn=coeffs(LGRn,z);
LGRn=double(fliplr(LGRn));

LGRd=((z-beta)*(z-1)^integrador);

controlz=controlz/LGRd;
% vpa(controlz,4)

LGRd=collect(LGRd,z);
LGRd=coeffs(LGRd,z);
LGRd=double(fliplr(LGRd));

k=1/abs(plantaz*controlz);
z=P;
K=eval(k)

Controlador=vpa(controlz*K,4)

Numerador_Controlador=LGRn
Denominador_Controlador=LGRd