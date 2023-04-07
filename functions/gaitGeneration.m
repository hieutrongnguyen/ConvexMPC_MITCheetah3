function gait = gaitGeneration(X, t, X_desired)
% {FR, FL, RR, RL} - {1, 2, 3, 4}
% pf has the dimension of 12*1

global tStart robotParams MPCParams gaitParams 

%% Extract variables from input
p = X(4:6);
p_dot = X(10:12);
X_desired = reshape(X_desired, [13, MPCParams.horizon]);
pz_desired = X_desired(12, 1);
psi_avg = mean(X_desired(3, :));   % Average value of psi during the reference trajectory

%% Robot parameters
w_body = robotParams.w_body;
l_body = robotParams.l_body;

%% Controller parameters
k = MPCParams.horizon;   

%% Gait parameters
numStep = gaitParams.numStep;
T_stance = gaitParams.T_stance;
T_gait = gaitParams.T_gait;
timestepLength = gaitParams.timestepLength;

%% Define current local time step
[i, i_global] = timeStep(t, tStart, timestepLength, T_gait);

%% COM position/ Turning control in place (4 foot in contact)
if gaitParams.gait == 0
    isContact = [1; 1; 1; 1];
    pf = [[ l_body/2; -w_body/2; 0]; ...
          [ l_body/2;  w_body/2; 0]; ...
          [-l_body/2; -w_body/2; 0]; ...
          [-l_body/2;  w_body/2; 0]];
end

%% Trotting      
if gaitParams.gait == 1
    % Trotting Gait
    if (i >= 1) && (i <= numStep/2)
        phase = 1;                                   % Foot 1 and 4 are in contact
        isContact = [1; 0; 0; 1];
    else
        phase = 2;                                   % Foot 2 and 3 are in contact
        isContact = [0; 1; 1; 0];
    end
    
    % Compute desired foot placemants
    Rz = [ cos(psi_avg), sin(psi_avg), 0; ...
          -sin(psi_avg), cos(psi_avg), 0; ...
                      0,            0, 1];
    
    %% Compute desired foot placemants
    if i_global == 0
        % Initilization
        pf = [[ l_body/2; -w_body/2; 0]; ...
            [ l_body/2;  w_body/2; 0]; ...
            [-l_body/2; -w_body/2; 0]; ...
            [-l_body/2;  w_body/2; 0]];
    else
        
        % Trotting Gait
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
        pf = pf_desired(:, i);
    end
    
    
%     pf = [[ l_body/2; -w_body/2; 0]; ...
%           [ l_body/2;  w_body/2; 0]; ...
%           [-l_body/2; -w_body/2; 0]; ...
%           [-l_body/2;  w_body/2; 0]];
end

%% Define output
gait = [pf; pf_desired; isContact];

end