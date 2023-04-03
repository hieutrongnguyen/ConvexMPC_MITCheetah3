function F = convexMPC(X, X_desired, pf, t)
% X = [RPY; p; omega; p_dot; g] has the dimension of 13*1
% X_desired is the output of the function genTrajectory, has the dimesion
% of 13*k in which k is the prediction horizon
% pf is the output of the function Foot placement, has the dimension of
% 12*1

global robotParams MPCParams 

%% Extract variables from input
p = X(4:6);
psi = X(3);
pf = reshape(pf, [3, 4]);

%% Robot parameters
m = robotParams.m;
Ib = robotParams.Ib;
     
%% Controller parameters
k = MPCParams.horizon;     % prediction horizon
dt_MPC = MPCParams.dt_MPC;
n = 4;                     % number of foots 

%% Compute Ac and A_hat
Rz = [ cos(psi), sin(psi), 0; ...
      -sin(psi), cos(psi), 0; ...
              0,        0, 1];
          
Ac = [zeros(3, 3), zeros(3, 3),          Rz, zeros(3, 3), zeros(3, 1); ...
      zeros(3, 3), zeros(3, 3), zeros(3, 3),      eye(3), zeros(3, 1); ...
      zeros(3, 3), zeros(3, 3), zeros(3, 3), zeros(3, 3), zeros(3, 1); ...
      zeros(3, 3), zeros(3, 3), zeros(3, 3), zeros(3, 3), [0; 0; 1]; ...
      zeros(1, 13)];

A_hat = eye(13) + Ac*dt_MPC;

%% Compute Bc and B_hat
I = Rz*Ib*Rz';
Bc = zeros(13, 3*n);
for i = 1:n
    Bc(7:9, i:i+2) = (I\skew(pf(:, i) - p));     % pf varis with horizion, leading to variation of Bc at each prediction step 
    Bc(10:12, i:i+2) = (1/m)*eye(3);       % --> compute more ...
end
B_hat{1} = Bc*dt_MPC;
B_hat = func

%% Compute Aqp
Aqp = repmat({zeros(13,13)}, k, 1);
Aqp{1} = A_hat;
for i = 2:k
    Aqp{i} = Aqp{i-1}*A_hat;
end
Aqp = cell2mat(Aqp);


%% Compute Bqp
Bqp = repmat({zeros(13, 3*n)}, k, k);
for i = 1:k
    Bqp{i, i} = B_hat{i};
    for j = 1:k-1
        Bqp{i, j} = A_hat^(i-j)*B_hat{j};
    end
end

for i = 1:k-1
    for j = i+1:k
        Bqp{i, j} = zeros(13, 3*n);
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
L = L_temp;
for i = 2:k
    L = blkdiag(L, L_temp);
end

K = alpha*eye(3*n*k);
[C, c_ieq] = ieqConstraint(f_min, f_max, mu);
D = eqConstraint(t);
d_eq = zeros(6*k, 1);

H = 2*(Bqp'*L*Bqp + K);
g = 2*Bqp'*L*(Aqp*x0 - y);

U = quadprog(H, g, C, c_ieq, D, d_eq);
F = U(1:12);

end
