function X_desired = genTrajectory(commandStates)
%% Extract variables from input
pz_desired = commandStates(1); 
px_dot_desired = commandStates(2); 
py_dot_desired = commandStates(3); 
yaw_dot_desired = commandStates(4);

%% Parameters
k = 10;   % prediction horizon

%%
% X = [RPY; p; omega; p_dot]
X_desired = zeros(13, k);

X_desired(6, :) = pz_desired*ones(1, k);  % z desired

...
for i = 1:k-1
    X_desired(4, k+1) = X_desired(4, k) + px_dot_desired*delta_t_MPC;
    X_desired(5, k+1) = X_desired(5, k) + py_dot_desired*delta_t_MPC;
end
...

end