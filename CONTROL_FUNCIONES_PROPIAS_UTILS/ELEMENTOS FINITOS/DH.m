function A=DH(theta,d,a,alfa)
disp('Recuerde para convenciones Denavit-Hartenberg')
disp('theta: rotacion respecto a Z (eje de movimiento)')
disp('d: distancia a lo alrgo del eje Z para alinear las X')
disp('a: Distancia a lo largo de X para hacer coincidir los origenes')
disp('alfa: angulo respecto a X para hacer coincidir completamente los sistemas de coordenadas')
A=[cos(theta),-sin(theta)*cos(alfa),sin(theta)*sin(alfa),a*cos(theta);
    sin(theta),cos(theta)*cos(alfa),-cos(theta)*sin(alfa),a*sin(theta);
    0,sin(alfa),cos(alfa),d;
     0,0,0,1];