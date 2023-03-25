function X_desired = genTrajectory(commandStates, X)
global g delta_t_MPC

%% Extract variables from input
pz_desired = commandStates(1); 
px_dot_desired = commandStates(2); 
py_dot_desired = commandStates(3); 
yaw_dot_desired = commandStates(4);
yaw = X(3); px = X(4); py = X(5);

%% Parameters
k = 10;   % prediction horizon

%% Reference Trajectory Generator
% X = [RPY; p; omega; p_dot]
X_desired = zeros(13, k);

X_desired(3, 1) = yaw;             % Current yaw angle
X_desired(4, 1) = px;              % Current x position
X_desired(5, 1) = py;              % Current y position  
X_desired(6, :) = pz_desired*ones(1, k);  % Desired z position

for i = 1:k-1
    X_desired(3, i+1) = X_desired(3, i) + yaw_dot_desired*delta_t_MPC;
    X_desired(4, i+1) = X_desired(4, i) + px_dot_desired*delta_t_MPC;
    X_desired(5, i+1) = X_desired(5, i) + py_dot_desired*delta_t_MPC;
end

X_desired(9, :) = yaw_dot_desired*ones(1, k);
X_desired(10, :) = px_dot_desired*ones(1, k);
X_desired(11, :) = py_dot_desired*ones(1, k);

X_desired(13, :) = g*ones(1, k);
end