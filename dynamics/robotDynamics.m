function dXs = robotDynamics(Xs, F, gait)
% Xs = [p; dp; omega; R(:)]
% F = [f1, f2, f3, f4] in which fi is 3*1 dimensional vector representing
% force acting at foot i location expressed in the world frame
% pf = [pf1, pf2, pf3, pf4] in which pfi is 3*1 dimensional vector representing
% location of the foot i expressed in the world frame

global robotParams

%% Robot parameters
m = robotParams.m;
Ib = robotParams.Ib;

%% Extract variables from input
p = Xs(1:3);   
dp = Xs(4:6);
omega = Xs(7:9);
R = reshape(Xs(10:18), [3, 3]);

F = reshape(F, [3, 4]);
pf = reshape(gait(1:12), [3, 4]);
c = reshape(gait(13:16), [4, 1]);

%% Define Ground Reaction Forces from only legs which are in contact
nContact = sum(c==1);     % number of foot in contact
F = F(:, c==1);
pf = pf(:, c==1);

%% Dynamics model
%========= Equation (5) =========% 
g = [0; 0; robotParams.g];
ddp = sum(F, 2)/m + g;

%========= Equation (6) =========% 
I = R*Ib*R';
r = zeros(3, nContact);
T = zeros(3, nContact);
for i = 1:nContact
    r(:, i) = pf(:, i) - p;
    T(:, i) = skew(r(:, i))*F(:, i); 
end
domega = I\(sum(T, 2) - skew(omega)*I*omega);

%========= Equation (7) =========% 
dR = skew(omega)*R;

%% Derive dXs
dXs = [dp; ddp; domega; dR(:)];

end
