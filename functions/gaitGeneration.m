function gait = gaitGeneration(X, t)
% {FR, FL, RR, RL} - {1, 2, 3, 4}
% pf has the dimension of 12*1

global tStart gaitParams robotParams pf_desired 

%% Extract variables from input
p = X(4:6);
p_dot = X(10:12);

%% Robot parameters
w_body = robotParams.w_body;
l_body = robotParams.l_body;

%% Gait parameters
numStep = gaitParams.numStep;
T_stance = gaitParams.T_stance;
T_gait = gaitParams.T_gait;
timestepLength = gaitParams.timestepLength;

%% Main function
% Define current local time step
[i, ~] = timeStep(t, tStart, timestepLength, T_gait);

if gaitParams.gait == 0
    isContact = [1; 1; 1; 1];
    pf = [[ l_body/2; -w_body/2; 0]; ...
          [ l_body/2;  w_body/2; 0]; ...
          [-l_body/2; -w_body/2; 0]; ...
          [-l_body/2;  w_body/2; 0]];
elseif gaitParams.gait == 1
    if (i >= 1) && (i <= numStep/2)
        phase = 1;                                   % Foot 1 and 4 are in contact
        isContact = [1; 0; 0; 1];
    else
        phase = 2;                                   % Foot 2 and 3 are in contact
        isContact = [0; 1; 1; 0];
    end
    
    % Compute desired foot placemants
    if i_global == 0
        % Initilization
        pf_desired = [[ l_body/2; -w_body/2; 0]; ...
                      [ l_body/2;  w_body/2; 0]; ...
                      [-l_body/2; -w_body/2; 0]; ...
                      [-l_body/2;  w_body/2; 0]];
    else
        % Trotting Gait
        if mod(i - 1, numStep/2) == 0 && phase == 1
            % Foot 1 and 4 are in contact, compute desired foot placement for
            % foot 2 and 3
            pf_desired(1:3, i) = pf_desired(1:3, i-1);
            pf_desired(4:6, i) = p + p_dot*T_stance/2 + R*[ l_body/2;  w_body/2; ];
            pf_desired(7:9, i) = p + p_dot*T_stance/2 + R*[-l_body/2; -w_body/2; ];
            pf_desired(10:12, i) = pf_desired(10:12, i-1);
            for j = i:i - numStep/2 + 1
                pf_desired(:, j) = pf_desired(:, i);
            end
        elseif mod(i - 1, numStep/2) == 0 && phase == 2
            % Foot 2 and 3 are in contact, compute desired foot placement for
            % foot 1 and 4
            pf_desired(1:3, i) = p + p_dot*T_stance/2 + R*[ l_body/2; -w_body/2; ];
            pf_desired(4:6, i) = pf_desired(4:6, i);
            pf_desired(7:9, i) = pf_desired(7:9, i);
            pf_desired(10:12, i) = p + p_dot*T_stance/2 + R*[-l_body/2;  w_body/2; ];
            for j = i:i - numStep/2 + 1
                pf_desired(:, j) = pf_desired(:, i);
            end
        end
    end
    pf = pf_desired(:, i);
    
%       pf = [[ l_body/2; -w_body/2; 0]; ...
%           [ l_body/2;  w_body/2; 0]; ...
%           [-l_body/2; -w_body/2; 0]; ...
%           [-l_body/2;  w_body/2; 0]];
end

gait = [pf; isContact];    

end