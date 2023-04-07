function X_desired = genTrajectory(commandStates, X)
global robotParams MPCParams 

%% Extract variables from input
pz_desired = commandStates(1); 
px_dot_desired = commandStates(2); 
py_dot_desired = commandStates(3); 
yaw_dot_desired = commandStates(4);
yaw = X(3); px = X(4); py = X(5);

%% Parameters
k = MPCParams.horizon;   % prediction horizon
dt_MPC = MPCParams.dt_MPC;
g = robotParams.g;

%% Reference Trajectory Generator
% X = [RPY; p; omega; p_dot]
X_desired = zeros(13, k);

X_desired(3, 1) = yaw + yaw_dot_desired*dt_MPC;            % Current yaw angle
X_desired(4, 1) = px  + px_dot_desired*dt_MPC;              % Current x position
X_desired(5, 1) = py  + py_dot_desired*dt_MPC;              % Current y position  
X_desired(6, :) = pz_desired*ones(1, k);  % Desired z position

for i = 2:k
    X_desired(3, i) = X_desired(3, i-1) + yaw_dot_desired*dt_MPC;
    X_desired(4, i) = X_desired(4, i-1) + px_dot_desired*dt_MPC;
    X_desired(5, i) = X_desired(5, i-1) + py_dot_desired*dt_MPC;
end

X_desired(9, :) = yaw_dot_desired*ones(1, k);
X_desired(10, :) = px_dot_desired*ones(1, k);
X_desired(11, :) = py_dot_desired*ones(1, k);

X_desired(13, :) = g*ones(1, k);

X_desired = reshape(X_desired, [13*k, 1]);

end
