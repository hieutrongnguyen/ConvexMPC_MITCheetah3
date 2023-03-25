clear
clc
addpath(genpath(pwd))

global delta_t_MPC g 

%%
Tsim = 5;
global T_gait horizon dt_MPC pf_saved X_saved

%% Robot parameters
m = 43;
Ib = [0.41,   0,    0; ...
         0, 2.1,    0; ...
         0,   0, 2.1]; 

l_body = 0.6;
w_body = 0.256;
h_body = 0.2;
g = -9.8;

%% User command
pz_desired = h_body;
px_dot_desired = 1;  % desired vx 
py_dot_desired = 0;  % desired vy 
yaw_dot_desired = 0;

%% Gait parameters
gait = 1; % trotting

T_gait = 0.5;
T_stance = T_gait/2;
T_swing = T_gait/2;

horizon = 10;
dt_MPC = T_gait/horizon;

%%
N_saved = Tsim/dt_MPC;
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


