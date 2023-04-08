function y = fcn1(t)
global tStart gaitParams 
persistent a

T_gait = gaitParams.T_gait;
timestepLength = gaitParams.timestepLength;

%%
[i, i_global] = timeStep(t, tStart, timestepLength, T_gait);

if i_global == 0
    a = zeros(10, 1);
end

if i == 0
    a(1:5) = t*ones(5, 1);
elseif i == 5    
    a(6:10) = t*ones(5, 1);
end

y = sum(a);

end