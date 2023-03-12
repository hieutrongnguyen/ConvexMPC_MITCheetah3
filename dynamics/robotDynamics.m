function dXs = robotDynamics(Xs, F, pf)
% Xs = [p; dp; omega; R(:)]
% F = [f1, f2, f3, f4] in which fi is 3*1 dimensional vector representing
% force acting at foot i location expressed in the world frame
% pf = [pf1, pf2, pf3, pf4] in which pfi is 3*1 dimensional vector representing
% location of the foot i expressed in the world frame

%%
m = 43;
Ib = [0.41,   0,    0; ...
         0, 2.1,    0; ...
         0,   0, 2.1]; 

%% Extract variables from input
p = Xs(1:3);   
dp = Xs(4:6);
omega = Xs(7:9);
R = reshape(Xs(10:18), [3, 3]);

F = reshape(F, [4, 3]);
pf = reshape(pf, [4, 3]);

syms x1 x2 x3
x = [x1; x2; x3];
skew(x)

%% Dynamics model
%========= Equation (5) =========% 
g = [0; 0; -9.8];
ddp = sum(F, 2)/m - g;

%========= Equation (6) =========% 
I = R*Ib*R';
r = zeros(3, 4);
T = zeros(3, 4);
for i = 1:4
    r(:, i) = pf(:, i) - p;
    T(:, i) = skew(r(:, i))*F(:, i); 
end
domega = I\(sum(T,2) - skew(omega)*I*omega);

%========= Equation (7) =========% 
dR = skew(omega)*R;

%% Derive dXs
dXs = [dp; ddp; domega; dR(:)];

end
