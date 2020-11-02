function [M, Prciles, Meen] = prcile_sub_v3(study_data, sitedata_All_2_tr)

% Tranche 1:30 -- dry gas
% Tranche 31:60 -- gas w oil
% Tranche 61:70 -- oil w gas

ind(:,1) = sitedata_All_2_tr >= 1 & sitedata_All_2_tr <= 30;
ind(:,2) = sitedata_All_2_tr >= 31 & sitedata_All_2_tr <= 60;
ind(:,3) = sitedata_All_2_tr >= 61 & sitedata_All_2_tr <= 70;
ind(:,4) = sitedata_All_2_tr >= 1 & sitedata_All_2_tr <= 70;
ind(:,5) = sitedata_All_2_tr >= 71 & sitedata_All_2_tr <= 74;

M.drygas = study_data(ind(:,1) == 1,:);
M.gaswoil = study_data(ind(:,2) == 1,:);
M.oilwgas = study_data(ind(:,3) == 1,:);
M.gasall = study_data(ind(:,4) == 1,:);
M.oilonly = study_data(ind(:,5) == 1,:);

M.drygas = squeeze(M.drygas(:,1,:));
M.gaswoil = squeeze(M.gaswoil(:,1,:));
M.oilwgas = squeeze(M.oilwgas(:,1,:));
M.gasall = squeeze(M.gasall(:,1,:));
M.oilonly = squeeze(M.oilonly(:,1,:));

M.drygas = M.drygas(:);
M.gaswoil = M.gaswoil(:);
M.oilwgas = M.oilwgas(:);
M.gasall = M.gasall(:);
M.oilonly = M.oilonly(:);

Prciles.drygas = prctile(M.drygas,[2.5 50 97.5]);
Prciles.gaswoil = prctile(M.gaswoil,[2.5 50 97.5]);
Prciles.oilwgas = prctile(M.oilwgas,[2.5 50 97.5]);
Prciles.all = prctile(study_data,[2.5 50 97.5]);

Meen.drygas = nanmean(M.drygas);
Meen.gaswoil = nanmean(M.gaswoil);
Meen.oilwgas = nanmean(M.oilwgas);
Meen.gasall = nanmean(M.gasall);
% Meen.oilonly = nanmean(M.oilonly);
Meen.all = nanmean(study_data);