function pf_pre = footPlacementPredicted(X, pf, t)
% pf_pre has the dimension of 12*k in which k is the prediction horizon

global tStart gaitParams 

%%
T_gait = gaitParams.T_gait;
timestepLength = gaitParams.timestepLength;

%% Define current time step
[i, ~] = timeStep(t, tStart, timestepLength, T_gait);



end