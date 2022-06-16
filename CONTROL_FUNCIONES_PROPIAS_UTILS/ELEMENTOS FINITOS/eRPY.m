function R=eRPY(phi,theta,psi)
disp('Recuerde para euler RPY:')
disp("psi: rotacion respecto al eje X del sistema de referencia fijo. Rx(psi)")
disp("theta: rotacion respecto al eje Y del sistema de referencia fijo. Ry(theta)")
disp('phi: rotacion respecto al eje Z del sistema de referencia fijo. Rz(phi)')

R=[cos(phi)*cos(theta),cos(phi)*sin(theta)*sin(psi)-sin(phi)*cos(psi),cos(phi)*sin(theta)*cos(psi)+sin(phi)*sin(psi);
    sin(phi)*cos(theta),sin(phi)*sin(theta)*sin(psi)+cos(phi)*cos(psi),sin(phi)*sin(theta)*cos(psi)-cos(phi)*sin(psi);
    -sin(theta),cos(theta)*sin(psi),cos(theta)*cos(psi)];