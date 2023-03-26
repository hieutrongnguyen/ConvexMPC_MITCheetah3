clear
clc
addpath(genpath(pwd))

global robotParams MPCParams gaitParams pf_saved X_saved 

%%
tStart = 0;
tSim = 5;

%% User command
pz_desired = h_body;
px_dot_desired = 1;  % desired vx 
py_dot_desired = 0;  % desired vy 
yaw_dot_desired = 0;

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
gaitParams.gait = 1; % trotting
gaitParams.timestepLength = 0.05;
gaitParams.numStep = 10;
gaitParams.T_gait = gaitParams.numStep*gaitParams.timestepLength;
gaitParams.T_stance = gaitParams.T_gait/2;
gaitParams.T_swing = gaitParams.T_gait/2;

MPCParams.horizon = gaitParams.numStep;
MPCParams.dt_MPC = gaitParams.T_gait/MPCParams.horizon;

%%
N_saved = tSim/MPCParams.dt_MPC;
pf_saved = zeros(12, N_saved);    % Each column stores foot postion of 4 legs in the world coordinate
X_saved = zeros(13, N_saved);     % Each column stores MPC states of 4 legs in the world coordinate

%% Initialization
p0 = [0; 0; 0];
dp0 = [0; 0; 0];
omega0 = [0; 0; 0];
R0 = eye(3);
RPY0 = [0; 0; 0];

Xs0 = [p0; dp0; omega0; R0(:)];

%%
% fp_example = [[-w_body/2; -l_body/2; -h_body]; ...
%               [-w_body/2;  l_body/2; -h_body]; ...
%               [ w_body/2;  l_body/2; -h_body]; ...
%               [ w_body/2; -l_body/2; -h_body]];
% F_example = [[0; 0; 43*9.8/2]; [0; 0; 0]; ...
%              [0; 0; 43*9.8/2]; [0; 0; 0]];

fp_0 = fp_example;


