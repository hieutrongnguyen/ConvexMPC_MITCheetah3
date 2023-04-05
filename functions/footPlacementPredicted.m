function pf_pre = footPlacementPredicted(X, pf, t)
% pf_pre has the dimension of 12*k in which k is the prediction horizon

global tStart gaitParams 

%% Extract variables from input
p_dot = X(10:12);

%% Gait Parameters
T_gait = gaitParams.T_gait;
timestepLength = gaitParams.timestepLength;
numStep = gaitParams.numStep;

%% Define current time step
% [i, ~] = timeStep(t, tStart, timestepLength, T_gait);
% 
% pf_pre = zeros(12, k);
% if i == 0
%     for j = 1:k
%         pf_pre(:, j) = pf + [T_gait*p_dot; T_gait*p_dot; T_gait*p_dot; T_gait*p_dot];
%     end
% else
%     for j = 1:k
%         if i + j <= numStep
%             pf_pre(:, j) = pf(:, j);
%         else
%             pf_pre(:, j) = pf + [T_gait*p_dot; T_gait*p_dot; T_gait*p_dot; T_gait*p_dot];
%         end
%     end
% end

pf_pre = pf;

end