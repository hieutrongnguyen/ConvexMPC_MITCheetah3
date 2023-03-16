clear
clc
% addpath(genpath('D:\[2] Resarch Resources\[1] Robotics and Control\Prof Park Hae Won\ConvexMPC_MITCheetah\ConvexMPC_MITCheetah\dynamics)'));
% addpath(genpath('D:\[2] Resarch Resources\[1] Robotics and Control\Prof Park Hae Won\ConvexMPC_MITCheetah\ConvexMPC_MITCheetah\functions)'));
addpath(genpath(pwd))

gait = 1; % trotting

%% Robot parameters

%%
vd = 1;  % m/s

%% Gait parameters
T_stance = 0.3;

%% Initialization
p0 = [0; 0; 0];
dp0 = [0; 0; 0];
omega0 = [0; 0; 0];
R0 = eye(3);
RPY0 = [0; 0; 0];

Xs0 = [p0; dp0; omega0; R0(:)];

l_body = 0.6;
w_body = 0.256;

fp_example = [[-w_body/2; -l_body/2; 0]; ...
              [-w_body/2;  l_body/2; 0]; ...
              [ w_body/2;  l_body/2; 0]; ...
              [ w_body/2; -l_body/2; 0]];
F_example = [[0; 0; 43*9.8/2]; [0; 0; 0]; ...
             [0; 0; 43*9.8/2]; [0; 0; 0]];

fp_0 = fp_example;

