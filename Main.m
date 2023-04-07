clear
clc
addpath(genpath(pwd))

global tStart robotParams MPCParams gaitParams pf_desired

%%
tStart = 0;
tSim = 5;

%% Robot parameters
robotParams.m = 43;
robotParams.Ib = [0.41,   0,    0; ...
                     0, 2.1,    0; ...
                     0,   0, 2.1]; 
robotParams.l_body = 0.6;
robotParams.w_body = 0.256;
robotParams.h_body = 0.2;
robotParams.g = -9.8;

%% Gait parameters
gaitParams.gait = 1;       % 0 - position/yaw control in place, 1 - trotting
gaitParams.timestepLength = 0.05;
gaitParams.numStep = 10;
gaitParams.T_gait = gaitParams.numStep*gaitParams.timestepLength;
gaitParams.T_stance = gaitParams.T_gait/2;
gaitParams.T_swing = gaitParams.T_gait/2;

%% MPC Controller parameters
MPCParams.alpha = 1e-6;
MPCParams.RPY_weight = 1;
MPCParams.pz_weight = 50;
MPCParams.yaw_dot_weight = 1;
MPCParams.p_dot_weight = 1;

MPCParams.f_min = 10;
MPCParams.f_max = 666;
MPCParams.mu = 0.6;
MPCParams.horizon = gaitParams.numStep;
MPCParams.dt_MPC = gaitParams.T_gait/MPCParams.horizon;

%% Initialization
p0 = [0; 0; 0.2];
dp0 = [0; 0; 0];
omega0 = [0; 0; 0];
R0 = eye(3);
RPY0 = [0; 0; 0];

Xs0 = [p0; dp0; omega0; R0(:)];

%% User command
Case = 3;

if Case == 1
    % COM position control in place
    pz_desired = 0.4;
    px_dot_desired = 0.3*robotParams.l_body/tSim;  % desired vx
    py_dot_desired = 0;                            % desired vy
    yaw_dot_desired = 0;
end

d2r = pi/180;
if Case == 2
    % Turning control in place
    pz_desired = p0(3);
    px_dot_desired = 0;                            % desired vx
    py_dot_desired = 0;                            % desired vy
    yaw_dot_desired = 40*d2r/tSim;
end

if Case == 3
    % Trotting in place
    pz_desired = p0(3);
    px_dot_desired = 0;                              % desired vx
    py_dot_desired = 0;                              % desired vy
    yaw_dot_desired = 0;
end

if Case == 4
    % Trotting
    pz_desired = p0(3);
    px_dot_desired = 1;                              % desired vx
    py_dot_desired = 0;                              % desired vy
    yaw_dot_desired = 0;
end

%% Draft
% dt_MPC = MPCParams.dt_MPC;
% 
l_body = robotParams.l_body;
w_body = robotParams.w_body;
% 
% fp_example = [[ l_body/2; -w_body/2; 0]; ...
%               [ l_body/2;  w_body/2; 0]; ...
%               [-l_body/2; -w_body/2; 0]; ...
%               [-l_body/2;  w_body/2; 0]];
% F_example = [[0; 0; 43*9.8/2]; [0; 0; 0]; ...
%              [0; 0; 43*9.8/2]; [0; 0; 0]];

pf_desired = zeros(12, k);

pf_0 = [[ l_body/2; -w_body/2; 0]; ...
        [ l_body/2;  w_body/2; 0]; ...
        [-l_body/2; -w_body/2; 0]; ...
        [-l_body/2;  w_body/2; 0]];

