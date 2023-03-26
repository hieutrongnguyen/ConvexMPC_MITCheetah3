function [i, i_global] = timeStep(t, tStart, timestepLength, T_gait)

i_global = ceil((t - tStart)/timestepLength);
i = mod(i_global, T_gait/timestepLength);

end