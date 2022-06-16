%close all; clear all; clc;
syms s;
%Datos a ingresar 
numerador_Planta = [-0.6667];
denominador_Planta = [1 0.13333 0.86667];

Tipo_Entrada = 2; % 1 Escalon; 2 Rampa; 3 Parabola
Ts=57;             
zd =0.8;
Tsd=Ts*0.90;
PTsd=0;
Mpd=0;

%tiempo muerto
% Parametro1= 0 No tiene tiempo muerto;Parametro1= 1 si tiene tiempo muerto
 Parametro_tm=0;
 tm=1;

%________________________Funcion Transferecia_____________________________%
  
  disp('Funcion de Transferencia');
  Funcion_Planta = tf(numerador_Planta,denominador_Planta);
  Funcion_Planta
  %step(Funcion_Planta)
  numerador=numerador_Planta;
  denominador=denominador_Planta;
  

    
% %____________________Identificacion de la planta___________________%

%Determina el orden y el tamaño de numerador y denominador del polinomio

Tam_Numerador = length(numerador); 
Orden_Numerador=Tam_Numerador-1;

Tam_Denominador = length(denominador); 
Orden_Denominador = Tam_Denominador -1;

%____________Dectectar el tipo del numerador y el denominador_______________

Tipo_Numerador = 0;
n=Tam_Numerador;
while (numerador(n) == 0)
     Tipo_Numerador = Tipo_Numerador+ 1;
     n=n-1;
end

Tipo_Denominador = 0;
d=Tam_Denominador;
while (denominador(d) == 0)
     Tipo_Denominador = Tipo_Denominador+ 1;
     d=d-1;
end


%___________________Hallar el tipo de control___________________________
K_I = Tipo_Entrada - Tipo_Denominador + Tipo_Numerador;
 if(K_I<0)
     K_I=0;
 end
 if(Tipo_Numerador==0)
     K_D = Orden_Denominador-1;
 else 
     K_D = Orden_Denominador- Tipo_Numerador-1;
 end 

if(K_D<0)
     K_D=0;
 end

if(K_I==0)
   fprintf('Control: P D^%d \n',K_D)
end 
if(K_D==0)
   fprintf('Control: P I^%d \n',K_I)
end 
if(K_D>0 && K_I>0)
  fprintf('Control: P I^%d D^%d \n',K_I,K_D)
end 
%_________________________Hallar funcion de control_____________________
%clear variables 
syms KP;                           
VariablesI=sym('KI',[1 K_I]);
VariablesD=sym('KD',[1 K_D]);

Tam_Fun_Control= K_I + K_D+1;
Orden_Fun_Control = K_I + K_D ;

%numerador de la funcion de control
Num_Fun_Control(1:Tam_Fun_Control)=sym(zeros);
V_Fun_Control=0;

p=1;
for i=0:1:K_D-1
    Num_Fun_Control(p)=VariablesD(K_D-i);
    V_Fun_Control=V_Fun_Control+VariablesD(K_D-i)*s^(Tam_Fun_Control-p);
    p=p+1;
end
Num_Fun_Control(p)=KP;
V_Fun_Control=V_Fun_Control+KP*s^(Tam_Fun_Control-p);
for i=1:1:K_I
    p=p+1;
    Num_Fun_Control(p)=VariablesI(i);
    V_Fun_Control=V_Fun_Control+VariablesI(i)*s^(Tam_Fun_Control-p);
end

%denominador de la funcion de control
Den_Fun_Control(1:K_I+1)=sym(zeros);
Den_Fun_Control(1)=1;
V_Fun_Control=V_Fun_Control/(s^K_I);

fprintf('\nFuncion de control: \n')
pretty(V_Fun_Control)

%______________________Hallar el polinomio caracteristico________________

if(Tipo_Numerador>=1) %si el tipo del numerador es mayor a 1
    Cancelar=Tipo_Numerador;
    %numerador de la planta cambia 
    Orden_NumeradorD=Orden_Numerador-Cancelar;
    Tam_NumeradorD=Tam_Numerador-Cancelar;
    numeradorD(1:Tam_NumeradorD)=sym(zeros);
    for i=1:1:Tam_Numerador-Cancelar
        numeradorD(i)=numerador(i);
    end
    %el denominador de la planta queda igual
    
    %el numerador de la Fun_ConTrol queda igual
    
    %el denominador de la Fun_Conrol cambia
    Den_Fun_ControlD(1:K_I-Cancelar+1)=sym(zeros);
    Den_Fun_ControlD(1)=1;
  
    %el orden de la multiplicacion p*c
    Orden_Num_por_Control = Orden_Fun_Control + Orden_NumeradorD;
    Orden_Den_por_Control = K_I-Cancelar+ Orden_Denominador; 
    
else                %si el tipo del numerador es igual 0
    numeradorD=numerador;
    Tam_NumeradorD=Tam_Numerador;
    Den_Fun_ControlD=Den_Fun_Control;
    Orden_Num_por_Control = Orden_Fun_Control + Orden_Numerador;
    Orden_Den_por_Control = Orden_Denominador + K_I;
end

%Asignacion de las multiplicacion del num de la planta por el num de
%la funcion control
Poli_Num_por_Control(1:Orden_Num_por_Control+1) = sym(zeros);

k=0;
for i=1:1:Tam_NumeradorD
    for j=1:1:Tam_Fun_Control
        Poli_Num_por_Control(j+k) = Poli_Num_por_Control(j+k)+ Num_Fun_Control(j)*numeradorD(i);
    end
    k=k+1;
end

%Asignacion de las multiplicacion del den de la planta por el den de
%la funcion control
Poli_Den_por_Control(1:Orden_Den_por_Control+1) = sym(zeros);

for i=1:1:Tam_Denominador
    Poli_Den_por_Control(i)=denominador(i);
end

% 1 + PC
if(Orden_Den_por_Control>Orden_Num_por_Control)
    Orden_Poli_Car=Orden_Den_por_Control;
else
    Orden_Poli_Car=Orden_Num_por_Control;
end 
  Tam_Poli_Car=Orden_Poli_Car+1;

Poli_CarD(1:Tam_Poli_Car) = sym(zeros);
CV=Tam_Poli_Car-Orden_Den_por_Control;
p=Orden_Den_por_Control+1;
for i=Tam_Poli_Car:-1:CV
    Poli_CarD(i)= Poli_Den_por_Control(p);
    p=p-1;
end
 
Poli_CarN(1:Tam_Poli_Car) = sym(zeros);
CV=Tam_Poli_Car-Orden_Num_por_Control;
p=Orden_Num_por_Control+1;
for i=Tam_Poli_Car:-1:CV
    Poli_CarN(i)= Poli_Num_por_Control(p);
    p=p-1;
end
Poli_Car=Poli_CarD+Poli_CarN;

%visualizacion
fprintf('\nPolinomio Caracteristico: \n')
V_Poli_Car=0;
k=Orden_Poli_Car;
for i=1:1:Tam_Poli_Car
   V_Poli_Car= V_Poli_Car+Poli_Car(i)*(s^(k));
   k=k-1;
end
disp(V_Poli_Car);

%________________________Parametros de la planta__________________________
switch Orden_Denominador
          case 1
              wn=0;
              z=0;
          case 2 
            denominadorM=denominador/denominador(1);
            wn=sqrt(denominadorM(3));
            zita=(denominadorM(3)/(2*wn));
end   
 
 if(Ts==0) %Hallar el Ts
        switch Orden_Denominador
          case 1
            denominadorM=denominador/denominador(2);
             Ts=5*denominadorM(1);
          case 2 
            if(zita>1)
               Ts=(4/(wn*(zita-sqrt(zita^2-1))));
            else
              Ts=(4/(zita*wn));
            end 
          otherwise
          fprintf('\n no se pudo hallar los parametros de la planta debido a que orden de la misma es superior a 2')
        end   
end 

%________________________Parametros del control __________________________
if(Tsd~=0) 
         Tsd=Tsd;
end
if(PTsd~=0)
         Tsd=(PTsd/100)*Ts;
end
if(Mpd~=0)
         zd=sqrt(((log(Mpd/100))^2)/(3.141592^2+((log(Mpd/100))^2)));
end
if(zd>1)
               wnd=(4/(Tsd*(zd-sqrt(zd^2-1))));
 else
               wnd=(4/(zd*Tsd));
end 
if(Orden_Poli_Car==1)
    taod=Tsd/5;
end
%____________________ Polinomio deseado___________________________
if(Orden_Poli_Car==1) % orden 1
     Poli_Des1=taod*s+1;
     Poli_Des2=vpa(Poli_Des1/taod);
     Poli_Des3=vpa(sym2poly(Poli_Des2));
else
    Poli_Des1=(s^2+2*zd*wnd*s+wnd^2)*(s+10*wnd*zd)^(Orden_Poli_Car-2);
    Poli_Des2=vpa(expand(Poli_Des1));
    Poli_Des3=vpa(sym2poly(Poli_Des2));
end 

Poli_Des(1:Tam_Poli_Car)=sym(zeros); %Tam_poli_Car=Tam_poli_des
for i=1:1:Tam_Poli_Car
     Poli_Des(i)=Poli_Des3(i);
end

%visualizacion
fprintf('\nPolinomio Deseado: \n')
pretty (vpa(Poli_Des2,8))

%______________hallar el valor de las constantes ___________________
Control (1:Tam_Fun_Control)=sym(zeros);

%Sistema de solucion de ecuaciones
if(Poli_Car(1)==1)
   for i=1: 1: Tam_Fun_Control
     Control(i)= solve(Poli_Car(i+1) == Poli_Des(i+1));
   end
else
    for i=1: 1: Tam_Fun_Control
     Control(i)= solve(Poli_Car(i) == Poli_Des(i));
   end
end
Control = vpa(Control,9);

%visualizacion
fprintf('\nValores de las constantes de control: \n')
disp(Num_Fun_Control);
disp(Control)


