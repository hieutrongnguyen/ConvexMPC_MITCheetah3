function Rx = rotx(phi)

Rx = [1,        0,         0; ...
      0, cos(phi), -sin(phi); ...
      0, sin(phi),  cos(phi)];
  
end