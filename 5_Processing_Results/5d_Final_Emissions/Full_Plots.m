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
    load('Emissionsdata_Set11_v2.mat')

%   - Clustered site-level outputs:
    % Runs 1 to 50
    load('sitedata_Set11_1.mat')
    % Runs 51 to 94
    load('sitedata_Set11_2.mat')

%   - Omara data
    omara_data=importdata('Omara_data_kgh_allsites.csv');
    omara_data(omara_data==0) = NaN;
    omara_data(any(isnan(omara_data),2),:) = [];

%% Calculations 

% Site level data    
    sitedata_All_2_tr = sitedata_All_1(:,1);
    sitedata_All_1 = sitedata_All_1(:,[2 4 6],:);
    sitedata_All_2 = sitedata_All_2(:,[2 4 6],:);
    [l,m,~] = size(sitedata_All_1);
    sitedata_All_2 = sitedata_All_2(1:l,:,:);
    sitedata_All = cat(3, sitedata_All_1, sitedata_All_2);
    sitedata_All = single(sitedata_All);

% Omara data    
	
    omara_data(:,3) = omara_data(:,2)./omara_data(:,1);
    % Convert column 1 from kg/hr to mscf/d
    omara_data(:,1) = omara_data(:,1) * ((1000*24)/(16 * 1.202 * 0.794 * 1000));

% Emissions plots
EmissionsPlots(EmissionsGas, EmissionsOil, Superemitters, sitedata_All, sitedata_All_2_tr, omara_data, n.trial)

