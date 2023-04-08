function pf_predicted = footPlacementPredicted(X, t, pf_desired)
% pf_pre has the dimension of 12*k in which k is the prediction horizon

global tStart robotParams gaitParams MPCParams 

%% Extract variables from input
p_dot = X(10:12);
pf_desired = reshape(pf_desired, [12, MPCParams.horizon]);
% pf = reshape(pf, [12, 1]);

%% Controller parameters
k = MPCParams.horizon;   

%% Gait parameters
T_gait = gaitParams.T_gait;
timestepLength = gaitParams.timestepLength;

%% COM Position or turning in place
if gaitParams.gait == 0 || gaitParams.gait == 1
    pf_predicted = pf_desired;
end

%% Trotting in place
if gaitParams.gait == 2
    pf_predicted = pf_desired;
end

%% Trotting
if gaitParams.gait == 3
    % Define current time step
    [i, i_global] = timeStep(t, tStart, timestepLength, T_gait);
    
    if i_global == 0
        % Initilization
        pf_predicted = zeros(12, k);
    end
    
    if i == 0
        for j = 1:k/2         % Phase 1
            pf_predicted(:, j) = pf_desired(:, j);
        end
        for j = k/2:k         % Phase 2
            pf_predicted(:, j) = pf_desired(:, j) + 0.5*[T_gait*p_dot; T_gait*p_dot; T_gait*p_dot; T_gait*p_dot];
        end
        
    elseif i>0 && i<k/2
        for j = 1:k/2-i       % Phase 1
            pf_predicted(:, j) = pf_desired(:, i+j);
        end
        for j = k/2-i+1:k-i   % Phase 2
            pf_predicted(:, j) = pf_desired(:, i+j) + 0.5*[T_gait*p_dot; T_gait*p_dot; T_gait*p_dot; T_gait*p_dot];
        end
        for j = k-i+1:k       % Phase 1
            pf_predicted(:, j) = pf_desired(:, i) + 0.5*[T_gait*p_dot; T_gait*p_dot; T_gait*p_dot; T_gait*p_dot];
        end
        
    elseif i == k/2
        for j = 1:k/2         % Phase 2
            pf_predicted(:, j) = pf_desired(:, k/2+j);
        end
        for j = k/2+1:k       % Phase 1
            pf_predicted(:, j) = pf_desired(:, j-k/2) + 0.5*[T_gait*p_dot; T_gait*p_dot; T_gait*p_dot; T_gait*p_dot];
        end
        
    elseif i>k/2 && i<k
        for j = 1:k-i         % Phase 2
            pf_predicted(:, j) = pf_desired(:, i+j);
        end
        for j = k-i+1:1.5*k-i % Phase 1
            pf_predicted(:, j) = pf_desired(:, i+j-k) + 0.5*[T_gait*p_dot; T_gait*p_dot; T_gait*p_dot; T_gait*p_dot];
        end
        for j = 1.5*k-i+1:k   % Phase 2
            pf_predicted(:, j) = pf_desired(:, i+j-k) + 0.5*[T_gait*p_dot; T_gait*p_dot; T_gait*p_dot; T_gait*p_dot];
        end
    end
end

end



