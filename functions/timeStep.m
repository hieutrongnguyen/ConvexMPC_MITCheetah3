function [i, i_global] = timeStep(t, tStart, timestepLength, T_gait)

%% Draft
% t = 0.0;
% tStart = 0; timestepLength = 0.05;

%% Main function
i_global = ceil((t - tStart)/timestepLength);
i = mod(i_global, T_gait/timestepLength);

end