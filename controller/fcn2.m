function y = fcn2(u)

global MPCParams
k=10;
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
for j = 2:k
    L = blkdiag(L, L_temp);
end

y = u(1) + u(2);

end