%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FINAL PLOTS FOR METHANE PAPER
% Jeff Rutherford
% last updated November 1, 2020
%
% The purpose of this code is to generate final plots for the methane paper
% 
% Inputs from DATA_PROC_MASTER
%   - Emissions totals:
%       - Emissionsdata_setX.mat
%   - Clustered site-level outputs:
%       - sitedata_SetX.mat
%
% Omara data (data file of bootstrapped model outputs obtained from Mark Omara)
%       - Omara_data_kgh_allsites.csv
%
% EPA Inputs (data loaded in subfunction)
%       - EPA_import.csv
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%% Inputs

n.trial = 100;

%% Load data

%   - Emissions totals:
    load('Emissionsdata_set16_1-100.mat')

%   - Clustered site-level outputs:
%   - COURSE RESOLUTION
%     % Runs 1 to 25
%      load('sitedata_Set16_1-25.mat')
%      sitedata_1 = sitedata_All;
%     % Runs 26 to 42
%      load('sitedata_Set16_26-42.mat')
%      sitedata_2 = sitedata_All;
%     % Runs 43 to 71
%      load('sitedata_Set16_43-71.mat')
%      sitedata_3 = sitedata_All;
%     % Runs 72 to 100        
%      load('sitedata_Set16_72-100.mat')
%      sitedata_4 = sitedata_All;

    % Runs 1 to 10
     load('sitedata_Set16_1-10.mat')
     sitedata_1 = sitedata_All;
    % Runs 11 to 25
     load('sitedata_Set16_11-25.mat')
     sitedata_2 = sitedata_All_reduced;
    % Runs 26 to 35
     load('sitedata_Set16_26-35.mat')
     sitedata_3 = sitedata_All;
    % Runs 36 to 42        
     load('sitedata_Set16_36-42.mat')
     sitedata_4 = sitedata_All_reduced;
    % Runs 43 to 61
     load('sitedata_Set16_43-61.mat')
     sitedata_5 = sitedata_All_reduced;
    % Runs 62 to 71
     load('sitedata_Set16_62-71.mat')
     sitedata_6 = sitedata_All;
    % Runs 72 to 81
     load('sitedata_Set16_72-81.mat')
     sitedata_7 = sitedata_All;
    % Runs 82 to 100        
     load('sitedata_Set16_82-100.mat')
     sitedata_8 = sitedata_All_reduced;


%   - Omara data
    omara_data=importdata('Omara_data_kgh_allsites.csv');
    omara_data(omara_data==0) = NaN;
    omara_data(any(isnan(omara_data),2),:) = [];

%% Calculations 


% Site level data    

     sitedata_1 = sitedata_1(:,[2 4 6],:);
     sitedata_2 = sitedata_2(:,[2 4 6],:);
     sitedata_3 = sitedata_3(:,[2 4 6],:);
     sitedata_4 = sitedata_4(:,[2 4 6],:);
     sitedata_5 = sitedata_5(:,[2 4 6],:);
     sitedata_6 = sitedata_6(:,[2 4 6],:);
     sitedata_7 = sitedata_7(:,[2 4 6],:);
     sitedata_8 = sitedata_8(:,[2 4 6],:);
     
     [length1,m,~] = size(sitedata_1);
     [length2,m,~] = size(sitedata_2);
     [length3,m,~] = size(sitedata_3);
     [length4,m,~] = size(sitedata_4);
     [length5,m,~] = size(sitedata_5);
     [length6,m,~] = size(sitedata_6);
     [length7,m,~] = size(sitedata_7);
     [length8,m,~] = size(sitedata_8);

% Option 1: Reduce vectors in size
     sitedata_index = sitedata_3(:,1);
	 sitedata_1 = sitedata_1(1:length3,:,:);
	 sitedata_2 = sitedata_2(1:length3,:,:);
     sitedata_4 = sitedata_4(1:length3,:,:);
	 sitedata_5 = sitedata_5(1:length3,:,:);
	 sitedata_6 = sitedata_6(1:length3,:,:);
     sitedata_7 = sitedata_7(1:length3,:,:);
	 sitedata_8 = sitedata_8(1:length3,:,:);
    
     
% Option 2: Pad vectors
%    sitedata_index = sitedata_5(:,1);
%     sitedata_1 = cat(1, sitedata_1, sitedata_5((length1 + 1):length5,:,1:10));
%     sitedata_2 = cat(1, sitedata_2, sitedata_5((length2 + 1):length5,:,1:15));
%     sitedata_3 = cat(1, sitedata_3, sitedata_5((length3 + 1):length5,:,1:10));
%     sitedata_4 = cat(1, sitedata_4, sitedata_5((length4 + 1):length5,:,1:7));
%     sitedata_6 = cat(1, sitedata_6, sitedata_5((length6 + 1):length5,:,1:10));
%     sitedata_7 = cat(1, sitedata_7, sitedata_5((length7 + 1):length5,:,1:10));
%     sitedata_8 = cat(1, sitedata_8, sitedata_5((length8 + 1):length5,:,1:19));
    
	sitedata_All = cat(3, sitedata_1,sitedata_2, sitedata_3, sitedata_4, sitedata_5, sitedata_6, sitedata_7, sitedata_8);
    sitedata_All = single(sitedata_All);

% Omara data    
	
    omara_data(:,3) = omara_data(:,2)./omara_data(:,1);
    % Convert column 1 from kg/hr to mscf/d
    omara_data(:,1) = omara_data(:,1) * ((1000*24)/(16 * 1.202 * 0.794 * 1000));

% Emissions plots
EmissionsPlots(EmissionsGas, EmissionsOil, Superemitters, sitedata_All, sitedata_index, omara_data, n.trial)

