function [C, c_bar] = ieqConstraint(f_min, f_max, mu)

global MPCParams
k = MPCParams.horizon;

Ci = [1, 0, -mu; ...
     -1, 0, -mu; ...
     0, 1, -mu; ...
     0, -1, -mu; ...
     0, 0, 1; ...
     0, 0, -1];
c_bari = [0; 0; 0; 0; f_max; -f_min];

C_temp = blkdiag(Ci, Ci, Ci, Ci);    % 4 legs
c_bar_temp = [c_bari; c_bari; c_bari; c_bari];

C = L_temp;
c_bar = c_bar_temp;

for i = 2:k
    C = blkdiag(C, C_temp);
    c_bar = [c_bar; c_bar_temp];
end

end