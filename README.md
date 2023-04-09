# ConvexMPC_MITCheetah3
ConvexMPC_MITCheetah3 is the simulation framework written in MATLAB and Simulink that implements the control strategy proposed in the paper "Dynamic Locomotion in the MIT Cheetah 3 Through Convex Model-Predictive Control". This repository has the following main components
(1) Folder "dynamics" includes the function describing single rigid body dynamics model of the robot.
(2) Folder "controller" includes functions implemting the main control stratgey described in the paper.
(3) Folder "functions" includes auxiliary functions for run the whole control system.
(4) File "Main.m" declares all dât for simulation.
(5) File "Convex_MPC_Cheetah.slx" is the main simulation model for running and getting results.

# Usage
To run the simulation, there are two files to note:
(1) Run Main.m file to get neccessary data. To choose a specific gait to run, in the line 22, choose corresponding gait's number.
(2) Run file Convex_MPC_Cheetah.slx to get the simulation results at chosen gait.
