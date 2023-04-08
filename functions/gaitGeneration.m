function gait = gaitGeneration(X, t, pf_p, X_desired)
% {FR, FL, RR, RL} - {1, 2, 3, 4}
% X is the current MPC state as defined in the paper 
% pf_p is the foot placement in the previous sampling time, having the dimension of 12*1
% X_desired has the dimension of 12*horizon

global tStart robotParams MPCParams gaitParams 
persistent pf_desired

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
if gaitParams.gait == 0 || gaitParams.gait == 1
    isContact = [1; 1; 1; 1];
    pf = [[ l_body/2; -w_body/2; 0]; ...
          [ l_body/2;  w_body/2; 0]; ...
          [-l_body/2; -w_body/2; 0]; ...
          [-l_body/2;  w_body/2; 0]];
    pf_desired = zeros(12, k);
    for j = 1:k
        pf_desired(:, j) = pf;
    end
end

%% Trotting in place
if gaitParams.gait == 2
    % Trotting Gait
    if (i >= 1) && (i <= numStep/2)
        isContact = [1; 0; 0; 1];     % Phase 1: Foot 1 and 4 are in contact
    else
        isContact = [0; 1; 1; 0];     % Phase 2: Foot 2 and 3 are in contact
    end
    
    pf = [[ l_body/2; -w_body/2; 0]; ...
        [ l_body/2;  w_body/2; 0]; ...
        [-l_body/2; -w_body/2; 0]; ...
        [-l_body/2;  w_body/2; 0]];
    pf_desired = zeros(12, k);
    for j = 1:k
        pf_desired(:, j) = pf;
    end
end

%% Trotting
if gaitParams.gait == 3
    % Trotting Gait
    if (i >= 1) && (i <= numStep/2)
        isContact = [1; 0; 0; 1];     % Phase 1: Foot 1 and 4 are in contact
    else
        isContact = [0; 1; 1; 0];     % Phase 2: Foot 2 and 3 are in contact
    end
    
    % Compute desired foot placemants
    R = rotz(psi_avg);
%     R = rotz(psi)*roty(theta)*rotx(phi);

    %% Compute desired foot placemants
    if i_global == 0
        pf_desired = zeros(12, k);
    else
        % Trotting Gait
        if i == 0
            % Phase 1: Foot 1 and 4 are in contact, compute
            % desired foot placement for foot 2 and 3
            pf_desired(1:3, i+1)   = pf_p(1:3);
            pf_desired(4:6, i+1)   = p + p_dot*T_stance/2 + R*[ l_body/2;  w_body/2; -pz_desired];
            pf_desired(7:9, i+1)   = p + p_dot*T_stance/2 + R*[-l_body/2; -w_body/2; -pz_desired];
            pf_desired(10:12, i+1) = pf_p(10:12);
            for j = i+2 : i + numStep/2
                pf_desired(:, j) = pf_desired(:, i+1);
            end
        elseif i == numStep/2
            % Phase 2: Foot 2 and 3 are in contact, compute
            % desired foot placement for foot 1 and 4
            pf_desired(1:3, i+1) = p + p_dot*T_stance/2 + R*[ l_body/2; -w_body/2; -pz_desired];
            pf_desired(4:6, i+1) = pf_desired(4:6, i);
            pf_desired(7:9, i+1) = pf_desired(7:9, i);
            pf_desired(10:12, i+1) = p + p_dot*T_stance/2 + R*[-l_body/2;  w_body/2; -pz_desired];
            for j = i+2 : i + numStep/2
                pf_desired(:, j) = pf_desired(:, i+1);
            end
        end
    end
    pf = pf_desired(:, i+1);
end

pf_des = reshape(pf_desired, [12*k, 1]);

%% Define output
gait = [pf; isContact; pf_des];

end