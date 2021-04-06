function [tranche] = tranche_data

    cutoff = 100;% Mscf/bbl

% The file 'data_lyon_2015_no_offshore.csv' contains data DI data provided by David
% Lyon on August 14, 2019, with offshore wells removed

    csvFileName = 'david_lyon_2015_no_offshore.csv';
    file = fopen(csvFileName);
    M.raw = csvread(csvFileName,0,0);
    fclose(file);

% Data is organized as follows:
% Col 1 = oil (bbl/year)
% Col 2 = gas (Mscf/year)
% Col 3 = well count (in TX, a row is a lease with multiple wells, source =
% David Lyons)

%% DATA CLASSIFICATION

% Create a logind variable (1 = dry gas, 2 = oil only, 3 = oil with
% associated gas
%   1 = GOR > 100 Mscf/bbl OR no oil production
%   2 = no gas production
%   3 = GOR < 100 Mscf/bbl

% Convert from annual basis to daily basis
M.raw(:,1) = M.raw(:,1)/365.25;
M.raw(:,2) = M.raw(:,2)/365.25;

M.raw(M.raw <= 0) = 99E-8;
[size_mat,~] = size(M.raw);

% Calculate GOR
M.raw(:,4) = M.raw(:,2)./M.raw(:,1);

% Calculate a per well productivity
M.raw(:,5) = M.raw(:,2)./M.raw(:,3);

% Assigning logind variable
logind = zeros(size_mat,7);

    logind(:,7) = (M.raw(:,2) == 99E-8  & M.raw(:,1) == 99E-8);
    
    logind(:,1) = (M.raw(:,4) > cutoff  & M.raw(:,1) == 99E-8 & logind(:,7) ~= 1); % gas only
    logind(:,2) = (M.raw(:,4) < cutoff  & M.raw(:,2) == 99E-8 & logind(:,7) ~= 1); % oil only
    logind(:,3) = (M.raw(:,4) > cutoff  & M.raw(:,1) ~= 99E-8 & logind(:,7) ~= 1); % gas with oil
    logind(:,4) = (M.raw(:,4) < cutoff  & M.raw(:,2) ~= 99E-8 & logind(:,7) ~= 1); % oil with gas
    logind(:,5) = (M.raw(:,4) > cutoff  & M.raw(:,2) == 99E-8 & logind(:,7) ~= 1); % should be zero
    logind(:,6) = (M.raw(:,4) < cutoff  & M.raw(:,1) == 99E-8 & logind(:,7) ~= 1); % should be zero
    
%(i) Separate by categories
    
    %   Dry gas from gas wells
        ind.drygas = logind(:,1);
        ind.drygas = int16(ind.drygas);
        M.drygas = M.raw(ind.drygas == 1,:);
    
        ind.i1 = M.drygas(:,5) < 1;
        ind.i2 = M.drygas(:,5) > 1 & M.drygas(:,5) < 5;
        ind.i3 = M.drygas(:,5) > 5 & M.drygas(:,5) < 10;
        ind.i4 = M.drygas(:,5) > 10 & M.drygas(:,5) < 20;
        ind.i5 = M.drygas(:,5) > 20 & M.drygas(:,5) < 50;
        ind.i6 = M.drygas(:,5) > 50 & M.drygas(:,5) < 100;
        ind.i7 = M.drygas(:,5) > 100 & M.drygas(:,5) < 500;
        ind.i8 = M.drygas(:,5) > 500 & M.drygas(:,5) < 1000;
        ind.i9 = M.drygas(:,5) > 1000 & M.drygas(:,5) < 10000;
        ind.i10 = M.drygas(:,5) > 10000;

        tranche.i1 = M.drygas(ind.i1,:);
        tranche.i2 = M.drygas(ind.i2,:);
        tranche.i3 = M.drygas(ind.i3,:);
        tranche.i4 = M.drygas(ind.i4,:);
        tranche.i5 = M.drygas(ind.i5,:);
        tranche.i6 = M.drygas(ind.i6,:);
        tranche.i7 = M.drygas(ind.i7,:);
        tranche.i8 = M.drygas(ind.i8,:);
        tranche.i9 = M.drygas(ind.i9,:);
        tranche.i10 = M.drygas(ind.i10,:);
        
    %   Gas with associated oil
        ind.gaswoil = logind(:,3);
        ind.gaswoil = int16(ind.gaswoil);
        M.gaswoil = M.raw(ind.gaswoil == 1,:);
    
        ind.i11 = M.gaswoil(:,5) < 1;
        ind.i12 = M.gaswoil(:,5) > 1 & M.gaswoil(:,5) < 5;
        ind.i13 = M.gaswoil(:,5) > 5 & M.gaswoil(:,5) < 10;
        ind.i14 = M.gaswoil(:,5) > 10 & M.gaswoil(:,5) < 20;
        ind.i15 = M.gaswoil(:,5) > 20 & M.gaswoil(:,5) < 50;
        ind.i16 = M.gaswoil(:,5) > 50 & M.gaswoil(:,5) < 100;
        ind.i17 = M.gaswoil(:,5) > 100 & M.gaswoil(:,5) < 500;
        ind.i18 = M.gaswoil(:,5) > 500 & M.gaswoil(:,5) < 1000;
        ind.i19 = M.gaswoil(:,5) > 1000 & M.gaswoil(:,5) < 10000;
        ind.i20 = M.gaswoil(:,5) > 10000;

        tranche.i11 = M.gaswoil(ind.i11,:);
        tranche.i12 = M.gaswoil(ind.i12,:);
        tranche.i13 = M.gaswoil(ind.i13,:);
        tranche.i14 = M.gaswoil(ind.i14,:);
        tranche.i15 = M.gaswoil(ind.i15,:);
        tranche.i16 = M.gaswoil(ind.i16,:);
        tranche.i17 = M.gaswoil(ind.i17,:);
        tranche.i18 = M.gaswoil(ind.i18,:);
        tranche.i19 = M.gaswoil(ind.i19,:);
        tranche.i20 = M.gaswoil(ind.i20,:);

    %   Oil only
        ind.oil = logind(:,2);
        ind.oil = int16(ind.oil);
        M.oil = M.raw(ind.oil == 1,:);    
        
        ind.i31 = M.oil(:,5) < 0.5;
        ind.i32 = M.oil(:,5) > 0.5 & M.oil(:,5) < 1;
        ind.i33 = M.oil(:,5) > 1 & M.oil(:,5) < 10;
        ind.i34 = M.oil(:,5) > 10;

        tranche.i31 = M.oil(ind.i31,:);
        tranche.i32 = M.oil(ind.i32,:);
        tranche.i33 = M.oil(ind.i33,:);
        tranche.i34 = M.oil(ind.i34,:);
        
    %   Oil with gas
        ind.oilwgas = logind(:,4);
        ind.oilwgas = int16(ind.oilwgas);
        M.oilwgas = M.raw(ind.oilwgas == 1,:);      

        ind.i21 = M.oilwgas(:,5) < 1;
        ind.i22 = M.oilwgas(:,5) > 1 & M.oilwgas(:,5) < 5;
        ind.i23 = M.oilwgas(:,5) > 5 & M.oilwgas(:,5) < 10;
        ind.i24 = M.oilwgas(:,5) > 10 & M.oilwgas(:,5) < 20;
        ind.i25 = M.oilwgas(:,5) > 20 & M.oilwgas(:,5) < 50;
        ind.i26 = M.oilwgas(:,5) > 50 & M.oilwgas(:,5) < 100;
        ind.i27 = M.oilwgas(:,5) > 100 & M.oilwgas(:,5) < 500;
        ind.i28 = M.oilwgas(:,5) > 500 & M.oilwgas(:,5) < 1000;
        ind.i29 = M.oilwgas(:,5) > 1000 & M.oilwgas(:,5) < 10000;
        ind.i30 = M.oilwgas(:,5) > 10000;

        tranche.i21 = M.oilwgas(ind.i21,:);
        tranche.i22 = M.oilwgas(ind.i22,:);
        tranche.i23 = M.oilwgas(ind.i23,:);
        tranche.i24 = M.oilwgas(ind.i24,:);
        tranche.i25 = M.oilwgas(ind.i25,:);
        tranche.i26 = M.oilwgas(ind.i26,:);
        tranche.i27 = M.oilwgas(ind.i27,:);
        tranche.i28 = M.oilwgas(ind.i28,:);
        tranche.i29 = M.oilwgas(ind.i29,:);
        tranche.i30 = M.oilwgas(ind.i30,:);
        
