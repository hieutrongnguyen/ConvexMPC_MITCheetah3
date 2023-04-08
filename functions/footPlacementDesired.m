function [pf_desired, i] = footPlacementDesired(X)

global tStart gaitParams MPCParams 

%% Extract variables from input
p = X(4:6);
p_dot = X(10:12);
% pf = reshape(pf, [12, 1]);

%% Controller parameters
k = MPCParams.horizon; 

%% Gait parameters
T_gait = gaitParams.T_gait;
timestepLength = gaitParams.timestepLength;
numStep = gaitParams.numStep;

%% Define current time step
[i, ~] = timeStep(t, tStart, timestepLength, T_gait);

%%
pf_desired = zeros(12, k);

if mod(i - 1, numStep/2) == 0 && phase == 1
    % Foot 1 and 4 are in contact, compute desired foot placement for
    % foot 2 and 3
    pf_desired(1:3, i) = pf_desired(1:3, i-1);
    pf_desired(4:6, i) = p + p_dot*T_stance/2 + Rz*[ l_body/2;  w_body/2; -pz_desired];
    pf_desired(7:9, i) = p + p_dot*T_stance/2 + Rz*[-l_body/2; -w_body/2; -pz_desired];
    pf_desired(10:12, i) = pf_desired(10:12, i-1);
    for j = i:i - numStep/2 + 1
        pf_desired(:, j) = pf_desired(:, i);
    end
elseif mod(i - 1, numStep/2) == 0 && phase == 2
    % Foot 2 and 3 are in contact, compute desired foot placement for
    % foot 1 and 4
    pf_desired(1:3, i) = p + p_dot*T_stance/2 + Rz*[ l_body/2; -w_body/2; -pz_desired];
    pf_desired(4:6, i) = pf_desired(4:6, i);
    pf_desired(7:9, i) = pf_desired(7:9, i);
    pf_desired(10:12, i) = p + p_dot*T_stance/2 + Rz*[-l_body/2;  w_body/2; -pz_desired];
    for j = i:i - numStep/2 + 1
        pf_desired(:, j) = pf_desired(:, i);
    end
end


end