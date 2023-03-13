function dRPY = derivedEulerangles(omega, RPY)

theta = RPY(2);
psi = RPY(3);

T = [cos(psi)/cos(theta), sin(psi)/cos(theta), 0; ...
               -sin(psi),            cos(psi), 0; ...
     cos(psi)*tan(theta), sin(psi)*tan(theta), 1]; 
dRPY = T*omega;

end