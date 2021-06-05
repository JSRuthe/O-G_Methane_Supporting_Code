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
    load('Emissionsdata_set21_1-100.mat')
    
     load('sitedata_Set21_1-10.mat')
     sitedata_1 = sitedata_All;
    % Runs 11 to 20
     load('sitedata_Set21_11-20.mat')
     sitedata_2 = sitedata_All;
    % Runs 21 to 30
     load('sitedata_Set21_21-30.mat')
     sitedata_3 = sitedata_All;
    % Runs 31 to 40        
     load('sitedata_Set21_31-40.mat')
     sitedata_4 = sitedata_All;
    % Runs 41 to 50
     load('sitedata_Set21_41-50.mat')
     sitedata_5 = sitedata_All;
    % Runs 51 to 60
     load('sitedata_Set21_51-60.mat')
     sitedata_6 = sitedata_All;
    % Runs 61 to 70
     load('sitedata_Set21_61-70.mat')
     sitedata_7 = sitedata_All;
    % Runs 71 to 80        
     load('sitedata_Set21_71-80.mat')
     sitedata_8 = sitedata_All;
    % Runs 81 to 90        
     load('sitedata_Set21_81-90.mat')
     sitedata_9 = sitedata_All;
    % Runs 91 to 100        
     load('sitedata_Set21_91-95.mat')
     sitedata_10 = sitedata_All;
    % Runs 91 to 100        
     load('sitedata_Set21_96-100.mat')
     sitedata_11 = sitedata_All;
     
%   - Omara data
    omara_data=importdata('Omara_data_kgh_allsites.csv');
    omara_data(omara_data==0) = NaN;
    omara_data(any(isnan(omara_data),2),:) = [];

%% Calculations 


% Site level data    

% Vector size
%   1: 550,354
%   2: 547007
%   3: 548288
%   4: 543589**
%   5: 548119
%   6: 546926
%   7: 550321
%   8: 546467
%   9: 549043
%   10:548748
%   11:547119

     sitedata_index = sitedata_4(:,1);

     sitedata_1 = sitedata_1(:,[2 4 6],:);
     sitedata_2 = sitedata_2(:,[2 4 6],:);
     sitedata_3 = sitedata_3(:,[2 4 6],:);
     sitedata_4 = sitedata_4(:,[2 4 6],:);
     sitedata_5 = sitedata_5(:,[2 4 6],:);
     sitedata_6 = sitedata_6(:,[2 4 6],:);
     sitedata_7 = sitedata_7(:,[2 4 6],:);
     sitedata_8 = sitedata_8(:,[2 4 6],:);
     sitedata_9 = sitedata_9(:,[2 4 6],:);
     sitedata_10 = sitedata_10(:,[2 4 6],:);
     sitedata_11 = sitedata_11(:,[2 4 6],:);
     
     [length1,m,~] = size(sitedata_1);
     [length2,m,~] = size(sitedata_2);
     [length3,m,~] = size(sitedata_3);
     [length4,m,~] = size(sitedata_4);
     [length5,m,~] = size(sitedata_5);
     [length6,m,~] = size(sitedata_6);
     [length7,m,~] = size(sitedata_7);
     [length8,m,~] = size(sitedata_8);
     [length9,m,~] = size(sitedata_9);
     [length10,m,~] = size(sitedata_10);  
     [length11,m,~] = size(sitedata_11); 
     
% Option 1: Reduce vectors in size

	 sitedata_1 = sitedata_1(1:length4,:,:);
	 sitedata_2 = sitedata_2(1:length4,:,:);
	 sitedata_3 = sitedata_3(1:length4,:,:);
     sitedata_5 = sitedata_4(1:length4,:,:);
	 sitedata_6 = sitedata_6(1:length4,:,:);
     sitedata_7 = sitedata_7(1:length4,:,:);
	 sitedata_8 = sitedata_8(1:length4,:,:);
	 sitedata_9 = sitedata_9(1:length4,:,:);
	 sitedata_10 = sitedata_10(1:length4,:,:);
     sitedata_11 = sitedata_11(1:length4,:,:);
     
	sitedata_All = cat(3, sitedata_1,sitedata_2, sitedata_3, sitedata_4, sitedata_5, sitedata_6, sitedata_7, sitedata_8, sitedata_9, sitedata_10, sitedata_11);
    sitedata_All = single(sitedata_All);

% Omara data    
	
    omara_data(:,3) = omara_data(:,2)./omara_data(:,1);
    % Convert column 1 from kg/hr to mscf/d
    omara_data(:,1) = omara_data(:,1) * ((1000*24)/(16 * 1.202 * 0.794 * 1000));

% Emissions plots
EmissionsPlots(EmissionsGas, EmissionsOil, Superemitters, sitedata_All, sitedata_index, omara_data, n.trial)

