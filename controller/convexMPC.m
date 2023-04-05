function F = convexMPC(X, pf, t, X_desired)
% X = [RPY; p; omega; p_dot; g] has the dimension of 13*1
% X_desired is the output of the function genTrajectory, has the dimesion
% of 13*k in which k is the prediction horizon
% pf is the output of the function Foot placement, has the dimension of
% 12*1

global robotParams MPCParams 

%% Extract variables from input
p = X(4:6);
pf = reshape(pf, [3, 4]);
X_desired = reshape(X_desired, [13, 10]);
psi_avg = mean(X_desired(3, :));   % Average value of psi during the reference trajectory

%% Robot parameters
m = robotParams.m;
Ib = robotParams.Ib; 
     
%% Controller parameters
k = MPCParams.horizon;     % prediction horizon
dt_MPC = MPCParams.dt_MPC;

%% Compute Ac and A_hat
Rz = [ cos(psi_avg), sin(psi_avg), 0; ...
      -sin(psi_avg), cos(psi_avg), 0; ...
                  0,            0, 1];
          
Ac = [zeros(3, 3), zeros(3, 3),          Rz, zeros(3, 3), zeros(3, 1); ...
      zeros(3, 3), zeros(3, 3), zeros(3, 3),      eye(3), zeros(3, 1); ...
      zeros(3, 3), zeros(3, 3), zeros(3, 3), zeros(3, 3), zeros(3, 1); ...
      zeros(3, 3), zeros(3, 3), zeros(3, 3), zeros(3, 3), [0; 0; 1]; ...
      zeros(1, 13)];       % 13*13

A_hat = eye(13) + Ac*dt_MPC;

%% Compute Bc and B_hat
B_hat = cell(k, 1);
I = Rz*Ib*Rz';
I = eye(3); m = 1;
pf = ones(12, 1); p = 2*ones(3, 1);
Bc = [        zeros(3, 3),         zeros(3, 3),         zeros(3, 3),           zeros(3, 3); ...
              zeros(3, 3),         zeros(3, 3),         zeros(3, 3),           zeros(3, 3); ...
      I\skew(pf(1:3) - p), I\skew(pf(4:6) - p), I\skew(pf(7:9) - p), I\skew(pf(10:12) - p); ...
             (1/m)*eye(3),        (1/m)*eye(3),        (1/m)*eye(3),          (1/m)*eye(3); ...
              zeros(1, 3),         zeros(1, 3),         zeros(1, 3),           zeros(1, 3)];   % 13*12
B_hat{1} = Bc*dt_MPC;

for j = 1:k-1
    pf_pre = footPlacementPredicted(X, pf, t);                                           
    p_des = X_desired(4:6, j+1);
    Bc = [                  zeros(3, 3),                 zeros(3, 3),                 zeros(3, 3),                   zeros(3, 3); ...
                            zeros(3, 3),                 zeros(3, 3),                 zeros(3, 3),                   zeros(3, 3); ...
            I\skew(pf_pre(1:3) - p_des), I\skew(pf_pre(4:6) - p_des), I\skew(pf_pre(7:9) - p_des), I\skew(pf_pre(10:12) - p_des); ...
                           (1/m)*eye(3),                (1/m)*eye(3),                (1/m)*eye(3),                  (1/m)*eye(3); ...
                            zeros(1, 3),                 zeros(1, 3),                 zeros(1, 3),                   zeros(1, 3)];
    B_hat{j+1} = Bc*dt_MPC;
end

%% Compute Aqp
Aqp = repmat({zeros(13, 13)}, k, 1);
Aqp{1} = A_hat;
for j = 2:k
    Aqp{j} = Aqp{j-1}*A_hat;
end
Aqp = cell2mat(Aqp);

%% Compute Bqp
Bqp = repmat({zeros(13, 12)}, k, k);
for j = 1:k
    Bqp{j, j} = B_hat{j};
    for h = 1:k-1
        Bqp{j, h} = A_hat^(j-h)*B_hat{h};
    end
end

for j = 1:k-1
    for h = j+1:k
        Bqp{j, h} = zeros(13, 12);
    end
end

Bqp = cell2mat(Bqp);

%% QP Formulation
x0 = X; 
y = X_desired;

alpha = MPCParams.alpha;
RPY_weight = MPCParams.RPY_weight*ones(1, 3);
p_weight = [0, 0, MPCParams.pz_weight];
omega_weight = [0, 0, MPCParams.yaw_dot_weight];
p_dot_weight = MPCParams.p_dot_weight*ones(1, 3);

f_min = MPCParams.f_min;
f_max = MPCParams.f_max;
mu = MPCParams.mu;

L_temp = diag([RPY_weight p_weight omega_weight p_dot_weight 0]);

% L = blkdiag(L_temp, L_temp, L_temp, L_temp, L_temp, L_temp, L_temp, L_temp, L_temp, L_temp);
for j = 2:k
    L = blkdiag(L, L_temp);
end

K = alpha*eye(12*k);
[C, c_ieq] = ieqConstraint(f_min, f_max, mu);
D = eqConstraint(t);
d_eq = zeros(6*k, 1);

H = 2*(Bqp'*L*Bqp + K);
g = 2*Bqp'*L*(Aqp*x0 - y);

U = quadprog(H, g, C, c_ieq, D, d_eq);
F = U(1:12);

end
