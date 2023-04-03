function D = eqConstraint(t)

global tStart gaitParams 

T_gait = gaitParams.T_gait;
timestepLength = gaitParams.timestepLength;

if gaitParams.gait == 1
    % Foot 1 and 4 are in contact, foot 2 and 3 are in swing phase
    D1 = [zeros(3),   eye(3), zeros(3), zeros(3); ...
          zeros(3), zeros(3),   eye(3), zeros(3)];
    % Foot 2 and 3 are in contact, foot 1 and 4 are in swing phase
    D2 = [  eye(3), zeros(3), zeros(3), zeros(3); ...
          zeros(3), zeros(3), zeros(3),  eye(3)];
    
    [i, ~] = timeStep(t, tStart, timestepLength, T_gait);
        
    % May need to write more systematically
    if i == 1
        D = blkdiag(D1, D1, D1, D1, D1, D2, D2, D2, D2, D2);
    elseif i == 2
        D = blkdiag(D1, D1, D1, D1, D2, D2, D2, D2, D2, D1);
    elseif i == 3
        D = blkdiag(D1, D1, D1, D2, D2, D2, D2, D2, D1, D1);
    elseif i == 4
        D = blkdiag(D1, D1, D2, D2, D2, D2, D2, D1, D1, D1);
    elseif i == 5
        D = blkdiag(D1, D2, D2, D2, D2, D2, D1, D1, D1, D1);
    elseif i == 6
        D = blkdiag(D2, D2, D2, D2, D2, D1, D1, D1, D1, D1);
    elseif i == 7
        D = blkdiag(D2, D2, D2, D2, D1, D1, D1, D1, D1, D2);
    elseif i == 8
        D = blkdiag(D2, D2, D2, D1, D1, D1, D1, D1, D2, D2);
    elseif i == 9
        D = blkdiag(D2, D2, D1, D1, D1, D1, D1, D2, D2, D2);
    else
        D = blkdiag(D2, D1, D1, D1, D1, D1, D2, D2, D2, D2);
    end
end

end