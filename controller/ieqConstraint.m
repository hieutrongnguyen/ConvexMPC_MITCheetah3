function [C, c_bar] = ieqConstraint(f_min, f_max, mu, t)

global tStart MPCParams gaitParams 

%% Controller parameters
k = MPCParams.horizon;

%% Gait parameters
T_gait = gaitParams.T_gait;
timestepLength = gaitParams.timestepLength;

%% Draft
% mu = 0.1;
% f_min = 0.1;
% f_max= 100;

%% Inequality for each feet in contact
Ci = [1, 0, -mu; ...
     -1, 0, -mu; ...
     0, 1, -mu; ...
     0, -1, -mu; ...
     0, 0, 1; ...
     0, 0, -1];
c_bari = [0; 0; 0; 0; f_max; -f_min];

%% Define inequality in the QP formulation according to gaits
if gaitParams.gait == 0 || gaitParams.gait == 1
    C_temp = blkdiag(Ci, Ci, Ci, Ci);    % 4 legs are in contact
    c_bar_temp = [c_bari; c_bari; c_bari; c_bari];
    
    C = C_temp;
    c_bar = c_bar_temp;
    
    for i = 2:k
        C = blkdiag(C, C_temp);
        c_bar = [c_bar; c_bar_temp];
    end
end
    
if gaitParams.gait == 2 || gaitParams.gait == 3
    % Foot 1 and 4 are in contact, foot 2 and 3 are in swing phase
    C1 = [         Ci, zeros(6, 3), zeros(6, 3), zeros(6, 3); ...
          zeros(6, 3), zeros(6, 3), zeros(6, 3),          Ci];
    % Foot 2 and 3 are in contact, foot 1 and 4 are in swing phase
    C2 = [zeros(6, 3),          Ci, zeros(6, 3), zeros(6, 3); ...
          zeros(6, 3), zeros(6, 3),          Ci, zeros(6, 3)];
    
    % Define current local time step
    [i, ~] = timeStep(t, tStart, timestepLength, T_gait);
        
    % May need to write more systematically
    if i == 0
        C = blkdiag(C1, C1, C1, C1, C1, C2, C2, C2, C2, C2);
    elseif i == 1
        C = blkdiag(C1, C1, C1, C1, C2, C2, C2, C2, C2, C1);
    elseif i == 2
        C = blkdiag(C1, C1, C1, C2, C2, C2, C2, C2, C1, C1);
    elseif i == 3
        C = blkdiag(C1, C1, C2, C2, C2, C2, C2, C1, C1, C1);
    elseif i == 4
        C = blkdiag(C1, C2, C2, C2, C2, C2, C1, C1, C1, C1);
    elseif i == 5
        C = blkdiag(C2, C2, C2, C2, C2, C1, C1, C1, C1, C1);
    elseif i == 6
        C = blkdiag(C2, C2, C2, C2, C1, C1, C1, C1, C1, C2);
    elseif i == 7
        C = blkdiag(C2, C2, C2, C1, C1, C1, C1, C1, C2, C2);
    elseif i == 8
        C = blkdiag(C2, C2, C1, C1, C1, C1, C1, C2, C2, C2);
    else
        C = blkdiag(C2, C1, C1, C1, C1, C1, C2, C2, C2, C2);
    end
    
    c_bar_temp = [c_bari; c_bari];
    
    c_bar = c_bar_temp;
    
    for i = 2:k
        c_bar = [c_bar; c_bar_temp];
    end
end



end