%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OPGEE OUTPUTS DATA PROCESSING
% Jeff Rutherford
% last updated November 1, 2020
%
% The purpose of this code is to generate processed data from OPGEE outputs
% See Supplementary Information Section 3.1.3 for a description of OPGEE
% output formatting
% 
% First, this script produces outputs which are transferred to Total 
% Emissions plotting scripts. 
%   - Emissions totals
%       - save('Emissionsdata_SetX.mat','EmissionsGas','EmissionsOil','Superemitters');
%   - Clustered site-level outputs (see below):
%       - save('sitedata_SetX.mat','sitedata_All');
%
% Second, this script also produces outputts which are transferred to
% Equipment level emissions factor plots
%   - Equipment level emission factor vectors
%       - save('equipdata_SetX.mat','equipdata_tot', '-v7.3'); 
%
% recall that OPGEE sampled only a subset of national wells to
% reduce processing time. This script references a function to extrapolate
% wells:
%    - "mat_extend.m" - "Sampled" well totals from OPGEE outputs are
%   extrapolated to actual national well counts. This extrapolation is
%   done, tranche by tranche, by duplicating the existing sampled matrix
%
% Several additional functions are available depending on several binary
% user inputs:
%   (i) welloption = 1
%       This option uses the function "wellpersite_v5.m" 
%       - "wellpersite_v5.m" - USing well counts per site from the Alvarez
%       2018 paper, bin specific well counts are randomly assigned and
%       OPGEE resultts rows are "clustered"
%
%   (ii) equipoption = 1
%       Equipment level vectors are saved
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% Input data:
%
%  OPGEE outputs
%       col 1 = tranche iteration (1-74)
%       col 2 = OPGEE row (200 - 273)
%       col 3 = sample (wells/sample size)
%       col 4 = well productivity [kg/well/d]
%       col 5 = well productivity [scf/well/d]
%       col 6 - 21 = equipment array
%       col 22 = sum of equipment array
%
% Output data:
%
%  Equipment-level outputs are as follows:
%       row 1  - Wells
%       row 2  - Header
%       row 3  - Heater
%       row 4  - separators
%       row 5  - Meter
%       row 6  - Tanks - leaks
%       row 7  - Tanks - vents
%       row 8  - Recip Compressor
%       row 9  - Dehydrators
%       row 10 - CIP
%       row 11 - PC
%       row 12 - LU
%       row 13 - completions
%       row 14 - workovers
%       row 15 - Combustion
%       row 16 - Tank Venting
%       row 17 - Flare methane
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clean up workspace
clear; clc; close all;

%% Inputs

% Set total trials
n.trial = 100;

% Binary options
    welloption = 0;
    equipoption = 0;

%% Begin data processing
    
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

% Preallocate matrices
    welldata.drygas = zeros(1,1);
    welldata.gaswoil = zeros(1,1);
    welldata.assoc = zeros(1,1);
    welldata.oil = zeros(1,1);
    % welldata_all = zeros(1,1,1);
    equipdata.drygas = zeros(1,1);
    equipdata.gaswoil = zeros(1,1);
    equipdata.assoc = zeros(1,1);
    equipdata.oil = zeros(1,1);
    gasvectot = zeros(1,1);
    oilvectot = zeros(1,1);
    sitedatainit.drygas = zeros(1,1);
    sitedatainit.gaswoil = zeros(1,1);
    sitedatainit.assoc = zeros(1,1);
    sitedatainit.oil = zeros(1,1);
    sitedata.drygas = zeros(1,1);
    sitedata.gaswoil = zeros(1,1);
    sitedata.assoc = zeros(1,1);
    sitedata.oil = zeros(1,1);
    results_tab = zeros(1,1);
    results_hist = zeros(1,1);

% Process tranche data from the David Lyon file if welloption is selected
if welloption == 1
    [tranche] = tranche_data;
end
    
counter = 0;
s = [];

for k = 1:n.trial

        csvFileName = ['Equip' num2str(k) 'out.csv'];
        dataraw = importdata(csvFileName);

        counter = counter + 1;

        [EmissionsGas(:,counter), EmissionsOil(:,counter), Superemitters(counter), welldata, equipdata] = mat_extend(dataraw, welldata, equipdata, k, welloption, equipoption);

    if welloption == 1
        sitedata = wellpersite_v5(welldata, tranche);
        [sitedata, sitedatainit] = adjustlengths(sitedata,sitedatainit, k);
        sitedata_All(:,:,k) = vertcat(sitedata.drygas, sitedata.gaswoil, sitedata.assoc);
    end
    
    if equipoption == 1
        
        equipdata_tot.drygas(:,:,k) = equipdata.drygas;
        equipdata_tot.gaswoil(:,:,k) = equipdata.gaswoil;
        equipdata_tot.assoc(:,:,k) = equipdata.assoc;
        equipdata_tot.oil(:,:,k) = equipdata.oil;
        
        if k == n.trial
           save('equipdata_Set20_25reals.mat','equipdata_tot', '-v7.3'); 
        end
        
    end
    
end

x=1;
% save('Emissionsdata_set16_1-100.mat','EmissionsGas','EmissionsOil','Superemitters');
% 
% 
% sitedata_All = sitedata_All(:,[2 4 6],:);


    
