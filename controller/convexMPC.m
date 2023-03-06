function F = convexMPC(X, X_desired)

psi = X(3);

%%

Rz = [ cos(psi), sin(psi), 0; ...
      -sin(psi), cos(psi), 0; ...
              0,        0, 1];

Ac = zeros(13, 13); 
Ac([1:3], [7:9]) = Rz;
Ac([4:6], [10:12]) = ones(3);
Ac(12, 13) = 1;   % g

Bc = zeros(13, 3*n);
for i = 1:n
    Bc[] = (inv(I)*skewsymMat(r()));
end


%%

end