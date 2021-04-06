%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EQUIPMENT-LEVEL EMISSIONS FACTOR PLOTTING SCRIPT
% 
% This script serves several purposes in executing equipment-level functions
% based upon user-defined inputs
%
% (i) Equipment emissions distributions
%		set all_equip = 1
%	  Figure for methods description
%		set figure_all = 1
% (ii) Calculates marginal and non-marginal post-hoc EFs
%		set EF_assess = 1
% (iii) Tank figures
%
% Inputs:
% 	Equipment vectors are exported from "DATA_PROC_MASTER"
%
%   col 1 - 16 = equipment emissions array [kg/d]
%   col 17 = tranche iteration (1-74)
%   col 18 = well productivity [kg/well/d]
%   col 19 = well productivity [scf/well/d]
%
%
% 	row 1  - Wells
% 	row 2  - Header
% 	row 3  - Heater
% 	row 4  - separators
% 	row 5  - Meter
% 	row 6  - Tanks - leaks
% 	row 7  - Tanks - vents
% 	row 8  - Recip Compressor
% 	row 9  - Dehydrators
% 	row 10 - CIP
% 	row 11 - PC
% 	row 12 - LU
% 	row 13 - completions
% 	row 14 - workovers
% 	row 15 - Tank Venting
%   row 16 - Flare methane
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear; clc; close all;


%% Settings

all_equip = 0;
tanks_only = 1;
figure_all = 0;
EF_assess = 1;


n.trial = 25;

%% LOAD DATA

load('equipdata_Set20_25reals.mat')

%% CALCULATIONS

% Define colors to use in plots
StanfordRed = [140/255,21/255,21/255]; %Stanford red
StanfordOrange = [233/255,131/255,0/255];% Stanford orange
StanfordYellow = [234/255,171/255,0/255];% Stanford yello
StanfordLGreen = [0/255,155/255,118/255];% Stanford light green
StanfordDGreen = [23/255,94/255,84/255];% Stanford dark green
StanfordBlue = [0/255,152/255,219/255];% Stanford blue
StanfordPurple = [83/255,40/255,79/255];% Stanford purple
Sandstone = [210/255,194/255,149/255];
LightGrey = [0.66, 0.66, 0.66];

gasvectot = zeros(1,1);
oilvectot = zeros(1,1);

results_tab = zeros(1,1);
results_hist = zeros(1,1);

counter = 0;
s = [];
t = [];

for k = 1:n.trial

        gasvec = vertcat(equipdata_tot.drygas(:,:,k), equipdata_tot.gaswoil(:,:,k));
        gasvec_nonan = gasvec;
        gasvec(gasvec==0) = NaN;
        gasvec(gasvec < 0) = NaN;
        oilvec = vertcat(equipdata_tot.oil(:,:,k), equipdata_tot.assoc(:,:,k));
        oilvec_nonan = oilvec;
        oilvec(oilvec==0) = NaN;
        oilvec(oilvec < 0) = NaN;
    
        [s, t, results_tab, gasvectot, oilvectot] = Equip_Plotting_Main(gasvec, oilvec, k, s, t, n, gasvectot, oilvectot, all_equip, tanks_only, figure_all, EF_assess);
        %results_tab_all(:,:,k) = results_tab;
  
end
