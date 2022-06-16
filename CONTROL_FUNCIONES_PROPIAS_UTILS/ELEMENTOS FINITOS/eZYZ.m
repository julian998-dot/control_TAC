function R=eZYZ(phi,theta,psi)
disp('Recuerde para euler ZYZ:')
disp('phi: rotacion respecto al eje Z del sistema de referencia fijo. Rz(phi)')
disp("theta: rotacion respecto al eje Y del sistema actual. Ry'(theta)")
disp("psi: rotacion respecto al eje Z del sistema actual. Rz''(psi)")
R=[cos(phi)*cos(theta)*cos(psi)-sin(phi)*sin(psi),-cos(phi)*cos(theta)*sin(psi)-sin(phi)*cos(psi),cos(phi)*sin(theta);
    sin(phi)*cos(theta)*cos(psi)+cos(phi)*sin(psi),-sin(phi)*cos(theta)*sin(psi)+cos(phi)*cos(psi),sin(phi)*sin(theta);
    -sin(theta)*cos(psi),sin(theta)*sin(psi),cos(theta)];