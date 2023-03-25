function pf = footPlacement(X, t)
% {FR, FL, BR, BL} - {1, 2, 3, 4}

global T_stance T_gait w_body l_body h_body pf1_desired pf2_desired pf3_desired pf4_desired

%% Extract variables from input
p = X(4:6);
p_dot = X(10:12);
s = stateMachine(t);                             % Planned foot placement for 4 foots

%% Compute desired foot placemants
if t == 0
    pf1 = p + [-w_body/2;  l_body/2; -h_body];
    pf2 = p + [ w_body/2;  l_body/2; -h_body];
    pf3 = p + [-w_body/2; -l_body/2; -h_body];
    pf4 = p + [ w_body/2; -l_body/2; -h_body];
    pf1_desired = pf1;
    pf2_desired = pf2;
    pf3_desired = pf3;
    pf4_desired = pf4;
else
    % Trotting Gait
    if floor(t/T_gait) == t/T_gait
        % Foot 1 and 4 are in contact, compute desired foot placement for
        % foot 2 and 3
        pf1 = pf1_desired;                           % Perfect foot placements assumption
        pf2_desired = p + p_dot*T_stance/2 + [ w_body/2;  l_body/2; -h_body];
        pf3_desired = p + p_dot*T_stance/2 + [-w_body/2; -l_body/2; -h_body];
        pf4 = pf4_desired;                           % Perfect foot placements assumption
    elseif floor(t/(T_gait/2)) == t/(T_gait/2)
        % Foot 2 and 3 are in contact, compute desired foot placement for
        % foot 1 and 4
        pf1_desired = p + p_dot*T_stance/2 + [-w_body/2;  l_body/2; -h_body];
        pf2 = pf2_desired;                           % Perfect foot placements assumption
        pf3 = pf3_desired;                           % Perfect foot placements assumption
        pf4_desired = p + p_dot*T_stance/2 + [ w_body/2; -l_body/2; -h_body];
    end
end
pf = [pf1; pf2; pf3; pf4];

end