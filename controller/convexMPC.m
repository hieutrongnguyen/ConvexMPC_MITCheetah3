function F = convexMPC(X, X_desired)

k = 9;     % prediction horizon
psi = X(3);

%% Compute Ac and A_hat
Rz = [ cos(psi), sin(psi), 0; ...
      -sin(psi), cos(psi), 0; ...
              0,        0, 1];
          
Ac = [zeros(3, 3), zeros(3, 3),          Rz, zeros(3, 3), zeros(3, 1); ...
      zeros(3, 3), zeros(3, 3), zeros(3, 3),      eye(3), zeros(3, 1); ...
      zeros(3, 3), zeros(3, 3), zeros(3, 3), zeros(3, 3), zeros(3, 1); ...
      zeros(3, 3), zeros(3, 3), zeros(3, 3), zeros(3, 3), [0; 0; -1]; ...
      zeros(1, 13)];

A_hat = eye(13) + Ac*delta_t_MPC;

%% Compute Bc and B_hat
Bc = zeros(13, 3*n);
for i = 1:n
    Bc([7:9], [i:i+2]) = (inv(I)*skewsymMat(r(i)));
    Bc([10:12], [i:i+2]) = (1/m)*eye(3);
end

B_hat = Bc*delta_t_MPC;

%% Compute Aqp
Aqp = repmat({zeros(13,13)}, k, 1);
Aqp{1} = A_hat;
for i = 2:horizon
    Aqp{i} = Aqp{i-1}*A_hat;
end
Aqp = cell2mat(Aqp);

%% Compute Bqp
Bqp = repmat({zeros(13, 3*n)}, k, k);
for i = 1:k
    Bqp{i, i} = B_hat;
    for j = 1:k-1
        Bqp{i, j} = A_hat^(i-j)*B_hat;
        
    end
end

for i = 1:k-1
    for j = i+1:k
        Bqp{i, j} = zeros(13, 12);
    end
end

Bqp = cell2mat(Bqp);

%% QP Formulation
x0 = ; y = ;
L = ; K = ; 
C = ;

H = 2*(Bqp'*L*Bqp + K);
g = 2*Bqp'*L*(Aqp*x0 - y);



end