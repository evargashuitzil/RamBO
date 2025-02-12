%% Example of how to configure and execute RamBO (and Occam)

clearvars; close all; clc

%% Paths to core functions and user specified functions
addpath('RamBO_CoreFunctions/')         % Path to RamBO Code
addpath('UserSpecifiedFunctions/')      % Path to user specified functions;
                                        % contains forward model and data
addpath('SummaryPlotting/')             % Path to plotting and summary routines                                       

%% Get model and data
%% ------------------------------------------------------------------------
ModelConfig = MakeModel;
DataConfig = MakeData;
%% ------------------------------------------------------------------------


%% Configure & run RamBO
%% ------------------------------------------------------------------------
% Configure RamBO
RamBOConfig.TargetRMS       = 1;   
RamBOConfig.muRange         = -3:.1:1;                   
RamBOConfig.MaxIts          = 20;
RamBOConfig.RoughTol        = 1e-2;
RamBOConfig.BregmanTol      = 1e-4;
RamBOConfig.BregmanMaxIts   = 300;
RamBOConfig.nos             = 50;
RamBOConfig.mu              = 0.1;
RamBOConfig.alpha           = 0.2;
RamBOConfig.RMSThreshold    = 3;
% Run RamBO
RamBO_Out = RamBO(RamBOConfig, ModelConfig, DataConfig);
%% ------------------------------------------------------------------------


%% Configure and run Occam (for comparison)
%% ------------------------------------------------------------------------
OccamConfig.TargetRMS = 1;     
OccamConfig.muRange   = -3:.1:1;     
OccamConfig.MaxIts    = 30;
OccamConfig.tol       = 1e-2;
% Run Occam
Occam_Out = Occam(OccamConfig, ModelConfig, DataConfig);
%% ------------------------------------------------------------------------


%% Summarize & plot results
%% ------------------------------------------------------------------------
% Blocky Occam
PrintOutputBlockyOccam
PlotBlockyOccamResults
% RamBO
PrintOutputRamBO
PlotRamBOResults
% Occam
PrintOutputOccam
PlotOccamResults
%% ------------------------------------------------------------------------
