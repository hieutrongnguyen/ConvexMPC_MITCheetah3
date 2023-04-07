function y = fcn2(x)
global b tStart gaitParams 

numStep = gaitParams.numStep;
T_stance = gaitParams.T_stance;
T_gait = gaitParams.T_gait;
timestepLength = gaitParams.timestepLength;

%%
b = 1;
t = x(3);
y1 = -(x(1) + x(2) + b);

%%
[i, ~] = timeStep(t, tStart, timestepLength, T_gait);

if i == 0
    phase = 2;                                   % Foot 2 and 3 are in contact
    isContact = [0; 1; 1; 0];
elseif i <= 5
    phase = 1;                                   % Foot 1 and 4 are in contact
    isContact = [1; 0; 0; 1];
else
    phase = 2;                                   % Foot 2 and 3 are in contact
    isContact = [0; 1; 1; 0];
end

%%
y = [i; isContact];

end