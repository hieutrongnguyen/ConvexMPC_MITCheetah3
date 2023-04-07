tStart = 0;
timestepLength = 0.05;
numStep = 10;
T_gait = numStep*timestepLength;
T_stance = T_gait/2;
T_swing = T_gait/2;

horizon = numStep;
dt_MPC = T_gait/horizon;

%% Example 
t = 0.05;

i_global = ceil((t - tStart)/timestepLength);
i = mod(i_global, T_gait/timestepLength);
i

if i >= 1 && i <= numStep/2
    phase = 1;                                   % Foot 1 and 4 are in contact
else
    phase = 2;                                   % Foot 2 and 3 are in contact
end

if mod(i - 1, numStep/2) == 0
   i;
   i + numStep/2 - 1;
end

%%
  
%     pf = zeros(12, 1);
%     if mod(i - 1, numStep/2) == 0 && phase == 1
%         % Foot 1 and 4 are in contact, compute desired foot placement for
%         % foot 2 and 3
%         pf(1:3) = pf_p(1:3);
%         pf(4:6) = p + p_dot*T_stance/2 + Rz*[ l_body/2;  w_body/2; -pz_desired];
%         pf(7:9) = p + p_dot*T_stance/2 + Rz*[-l_body/2; -w_body/2; -pz_desired];
%         pf(10:12) = pf_p(10:12);
%    
%     elseif mod(i - 1, numStep/2) == 0 && phase == 2
%         % Foot 2 and 3 are in contact, compute desired foot placement for
%         % foot 1 and 4
%         pf(1:3) = p + p_dot*T_stance/2 + Rz*[ l_body/2; -w_body/2; -pz_desired];
%         pf(4:6) = pf_p(4:6);
%         pf(7:9) = pf_p(7:9);
%         pf(10:12) = p + p_dot*T_stance/2 + Rz*[-l_body/2;  w_body/2; -pz_desired];
%  
%     else
%         pf = pf_p;
%     end
