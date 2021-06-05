function [EmissionsGas, EmissionsOil, Superemitters, welldata, equipdata] = mat_extend(dataraw, welldata, equipdata, k, welloption, equipoption)

data = dataraw;
[rows, columns] = size(data);

%  - - OUTPUTS - - 

% Study.All

%    gas  oil  dataraw	
% row 1  (18) (6) - Wells
% row 2  (19) (7) - Header
% row 3  (20) (8) - Heater
% row 4  (21) (9) - separators
% row 5  (22) (10) - Meter
% row 6  (23) (11) - Tanks - leaks
% row 7  (24) (12) - Tanks - vents
% row 8  (25) (13) - Recip Compressor
% row 9  (26) (14) - Dehydrators
% row 10 (27) (15) - CIP
% row 11 (28) (16) - PC
% row 12 (29) (17) - LU
% row 13 (30) (18) - completions
% row 14 (31) (19) - workovers
% row 15 (32) (x) - Combustion
% row 16 (33) (20) - Tank Venting
% row 17 (34) (21) - Flare methane


%% Replace completions and workovers with 
% Non-flaring C&W from GHGRP_Master

Gas.workovers = 2.3; % MTCH4/year
Gas.completions = 34.0; % MTCH4/year
Oil.workovers = 0; % MTCH4/year
Oil.completions = 68.5; % MTCH4/year

Gas.workovers = Gas.workovers *(1/1000); %Tg/year
Gas.completions = Gas.completions *(1/1000); %Tg/year
Oil.workovers = Oil.workovers *(1/1000); %Tg/year
Oil.completions = Oil.completions *(1/1000); %Tg/year

%% Combustion emissions output from combustion.v1

Gas.Combustion = 0.0983; % Tg/year

%% EXTEND MATRIX

    for i = 200:259
        matpart = data(data(:,2) == i, :);
        [m,n] = size(matpart);
        
        % The length of the matrix is transformed to the count of actual
        % wells
        % matpart(1,3) = sample = (actual wells) / (sampled wells)
        % (actual wells) = sample * (sampled wells)
        
        len = ceil(matpart(1,3)*m);
        
        % Extend the matrix to the count of actual wells using Matlab's
        % "repmat" function (duplicates copies of the matrix proportional
        % to (actual wells/sampled wells)
        matpartextend = repmat(matpart,ceil(len/m),1);
        matpartextend = matpartextend(1:len,:);
        if i > 200
            matpartextend_full = vertcat(matpartextend_full,matpartextend);
        else
            matpartextend_full = matpartextend;
        end
    end

    % The emissions matrix is broken out as follows:
    % drygas : Gas wells with no oil production
    % gaswoil : Gas wells with oil production and GOR > 100 Mscf/bbl
    
    data = matpartextend_full;
    dataplot.gas = matpartextend_full;
    dataplot.gas(:,22) = sum(dataplot.gas(:,6:21),2);
    dataplot.gas(:,23) = dataplot.gas(:,22)./dataplot.gas(:,4);

    dataplot.drygas = dataplot.gas((dataplot.gas(:,2) < 230),:);
    dataplot.gaswoil = dataplot.gas((dataplot.gas(:,2) > 229 & data(:,2) < 260),:);
    
    %% Wells (gas)

    % Data prep
        Gas.W = data(:,6);
        Gas.W(Gas.W==0) = NaN;
        ind = isnan(Gas.W);
        Gas.W = Gas.W(~ind);
        SortC = sort(Gas.W,'descend');
        SumC = nansum(Gas.W);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(1) = ceil(length(Gas.W)*0.05);

    % Parameters
        ContributionPerc5(1) = CumC(Perc5Location(1));
        ContributionPerc5Norm(1) = CumCNorm(Perc5Location(1));
        Minimum(1) = min(Gas.W);
        Maximum(1) = max(Gas.W);
        Average(1) = mean(Gas.W);
        MedC(1) = median(Gas.W);
        SumEmissions(1) = sum(Gas.W);

    %% Heater (gas)

    % Data prep
        Gas.H = data(:,8);
        Gas.H(Gas.H==0) = NaN;
        ind = isnan(Gas.H);
        Gas.H = Gas.H(~ind);
        SortC = sort(Gas.H,'descend');
        SumC = nansum(Gas.H);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(3) = ceil(length(Gas.H)*0.05);

    % Parameters
        ContributionPerc5(3) = CumC(Perc5Location(3));
        ContributionPerc5Norm(3) = CumCNorm(Perc5Location(3));
        Minimum(3) = min(Gas.H);
        Maximum(3) = max(Gas.H);
        Average(3) = mean(Gas.H);
        MedC(3) = median(Gas.H);
        SumEmissions(3) = sum(Gas.H);
        
    %% Gas separators

    % Data prep
        Gas.S = data(:,9);
        Gas.S(Gas.S==0) = NaN;
        ind = isnan(Gas.S);
        Gas.S = Gas.S(~ind);
        SortC = sort(Gas.S,'descend');
        SumC = nansum(Gas.S);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(4) = ceil(length(Gas.S)*0.05);

    % Parameters
        ContributionPerc5(4) = CumC(Perc5Location(4));
        ContributionPerc5Norm(4) = CumCNorm(Perc5Location(4));
        Minimum(4) = min(Gas.S);
        Maximum(4) = max(Gas.S);
        Average(4) = mean(Gas.S);
        MedC(4) = median(Gas.S);
        SumEmissions(4) = sum(Gas.S);
    %% Meter (gas)

    % Data prep
        Gas.M = data(:,10);
        Gas.M(Gas.M==0) = NaN;
        ind = isnan(Gas.M);
        Gas.M = Gas.M(~ind);
        SortC = sort(Gas.M,'descend');
        SumC = nansum(Gas.M);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(5) = ceil(length(Gas.M)*0.05);

    % Parameters
        ContributionPerc5(5) = CumC(Perc5Location(5));
        ContributionPerc5Norm(5) = CumCNorm(Perc5Location(5));
        Minimum(5) = min(Gas.M);
        Maximum(5) = max(Gas.M);
        Average(5) = mean(Gas.M);
        MedC(5) = median(Gas.M);
        SumEmissions(5) = sum(Gas.M);
    %% Tanks - leaks (gas)

    % Data prep
        Gas.TKl = data(:,11);
        Gas.TKl(Gas.TKl==0) = NaN;
        ind = isnan(Gas.TKl);
        Gas.TKl = Gas.TKl(~ind);
        SortC = sort(Gas.TKl,'descend');
        SumC = nansum(Gas.TKl);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(6) = ceil(length(Gas.TKl)*0.05);

    % Parameters
        ContributionPerc5(6) = CumC(Perc5Location(6));
        ContributionPerc5Norm(6) = CumCNorm(Perc5Location(6));
        Minimum(6) = min(Gas.TKl);
        Maximum(6) = max(Gas.TKl);
        Average(6) = mean(Gas.TKl);
        MedC(6) = median(Gas.TKl);
        SumEmissions(6) = sum(Gas.TKl);

    %% Tanks - vents (gas)

    % Data prep
        Gas.TKv = data(:,12);
        Gas.TKv(Gas.TKv==0) = NaN;
        ind = isnan(Gas.TKv);
        Gas.TKv = Gas.TKv(~ind);
        SortC = sort(Gas.TKv,'descend');
        SumC = nansum(Gas.TKv);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(7) = ceil(length(Gas.TKv)*0.05);

    % Parameters
        ContributionPerc5(7) = CumC(Perc5Location(7));
        ContributionPerc5Norm(7) = CumCNorm(Perc5Location(7));
        Minimum(7) = min(Gas.TKv);
        Maximum(7) = max(Gas.TKv);
        Average(7) = mean(Gas.TKv);
        MedC(7) = median(Gas.TKv);
        SumEmissions(7) = sum(Gas.TKv);
    %% Recip Compressor (gas)

    % Data prep
        Gas.RC = data(:,13);
        Gas.RC(Gas.RC==0) = NaN;
        ind = isnan(Gas.RC);
        Gas.RC = Gas.RC(~ind);
        SortC = sort(Gas.RC,'descend');
        SumC = nansum(Gas.RC);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(8) = ceil(length(Gas.RC)*0.05);

    % Parameters
        ContributionPerc5(8) = CumC(Perc5Location(8));
        ContributionPerc5Norm(8) = CumCNorm(Perc5Location(8));
        Minimum(8) = min(Gas.RC);
        Maximum(8) = max(Gas.RC);
        Average(8) = mean(Gas.RC);
        MedC(8) = median(Gas.RC);
        SumEmissions(8) = sum(Gas.RC);

    %% Dehydrators (gas)

    %Data prep
        Gas.D = data(:,14);
        Gas.D(Gas.D==0) = NaN;
        ind = isnan(Gas.D);
        Gas.D = Gas.D(~ind);
        SortC = sort(Gas.D,'descend');
        SumC = nansum(Gas.D);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(9) = ceil(length(Gas.D)*0.05);

    %Parameters
        ContributionPerc5(9) = CumC(Perc5Location(9));
        ContributionPerc5Norm(9) = CumCNorm(Perc5Location(9));
        Minimum(9) = min(Gas.D);
        Maximum(9) = max(Gas.D);
        Average(9) = mean(Gas.D);
        MedC(9) = median(Gas.D);
        SumEmissions(9) = sum(Gas.D);

    %% CIJ (gas)

    %Data prep
        Gas.CIJ = data(:,15);
        Gas.CIJ(Gas.CIJ==0) = NaN;
        ind = isnan(Gas.CIJ);
        Gas.CIJ = Gas.CIJ(~ind);
        SortC = sort(Gas.CIJ,'descend');
        SumC = nansum(Gas.CIJ);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(10) = ceil(length(Gas.CIJ)*0.05);

    %Parameters
        ContributionPerc5(10) = CumC(Perc5Location(10));
        ContributionPerc5Norm(10) = CumCNorm(Perc5Location(10));
        Minimum(10) = min(Gas.CIJ);
        Maximum(10) = max(Gas.CIJ);
        Average(10) = mean(Gas.CIJ);
        MedC(10) = median(Gas.CIJ);
        SumEmissions(10) = sum(Gas.CIJ);

 %% PC (gas)

    % Data prep
        Gas.PC = data(:,16);
        Gas.PC(Gas.PC==0) = NaN;
        ind = isnan(Gas.PC);
        Gas.PC = Gas.PC(~ind);
        SortC = sort(Gas.PC,'descend');
        SumC = nansum(Gas.PC);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(11) = ceil(length(Gas.PC)*0.05);

    % Parameters
        ContributionPerc5(11) = CumC(Perc5Location(11));
        ContributionPerc5Norm(11) = CumCNorm(Perc5Location(11));
        Minimum(11) = min(Gas.PC);
        Maximum(11) = max(Gas.PC);
        Average(11) = mean(Gas.PC);
        MedC(11) = median(Gas.PC);
        SumEmissions(11) = sum(Gas.PC);

    %% LU (gas)

    % Data prep
        Gas.LU = data(:,17);
        Gas.LU(Gas.LU==0) = NaN;
        ind = isnan(Gas.LU);
        Gas.LU = Gas.LU(~ind);
        SortC = sort(Gas.LU,'descend');
        SumC = nansum(Gas.LU);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(12) = ceil(length(Gas.LU)*0.05);

    % Parameters
        ContributionPerc5(12) = CumC(Perc5Location(12));
        ContributionPerc5Norm(12) = CumCNorm(Perc5Location(12));
        Minimum(12) = min(Gas.LU);
        Maximum(12) = max(Gas.LU);
        Average(12) = mean(Gas.LU);
        MedC(12) = median(Gas.LU);
        SumEmissions(12) = sum(Gas.LU);

    %% Completions (gas)

    % Data prep
%         Gas.CM = data(:,18);
%         Gas.CM(Gas.CM==0) = NaN;
%         ind = isnan(Gas.CM);
%         Gas.CM = Gas.CM(~ind);
%         SortC = sort(Gas.CM,'descend');
%         SumC = nansum(Gas.CM);
%         NormSortC = SortC/SumC;
%         CumCNorm = cumsum(NormSortC);
%         CumC = cumsum(SortC);
%         Perc5Location(13) = ceil(length(Gas.CM)*0.05);
% 
%     % Parameters
%         ContributionPerc5(13) = CumC(Perc5Location(13));
%         ContributionPerc5Norm(13) = CumCNorm(Perc5Location(13));
%         Minimum(13) = min(Gas.CM);
%         Maximum(13) = max(Gas.CM);
%         Average(13) = mean(Gas.CM);
%         MedC(13) = median(Gas.CM);
%         SumEmissions(13) = sum(Gas.CM);
% 
%     %% Workovers (gas)
% 
%     % Data prep
%         Gas. WK = data(:,19);
%         Gas. WK(Gas. WK==0) = NaN;
%         ind = isnan(Gas. WK);
%         Gas. WK = Gas. WK(~ind);
%         SortC = sort(Gas. WK,'descend');
%         SumC = nansum(Gas. WK);
%         NormSortC = SortC/SumC;
%         CumCNorm = cumsum(NormSortC);
%         CumC = cumsum(SortC);
%         Perc5Location(14) = ceil(length(Gas. WK)*0.05);
% 
%     % Parameters
%         ContributionPerc5(14) = CumC(Perc5Location(14));
%         ContributionPerc5Norm(14) = CumCNorm(Perc5Location(14));
%         Minimum(14) = min(Gas. WK);
%         Maximum(14) = max(Gas. WK);
%         Average(14) = mean(Gas. WK);
%         MedC(14) = median(Gas. WK);
%         SumEmissions(14) = sum(Gas.WK);

    %% Engine slip (gas)
% 
%     % Data prep
%         Gas. ES = data(:,20);
%         Gas. ES(Gas. ES==0) = NaN;
%         ind = isnan(Gas. ES);
%         Gas. ES = Gas. ES(~ind);
%         SortC = sort(Gas. ES,'descend');
%         SumC = nansum(Gas. ES);
%         NormSortC = SortC/SumC;
%         CumCNorm = cumsum(NormSortC);
%         CumC = cumsum(SortC);
%         Perc5Location(15) = ceil(length(Gas. ES)*0.05);
% 
%     % Parameters
%         ContributionPerc5(15) = CumC(Perc5Location(15));
%         ContributionPerc5Norm(15) = CumCNorm(Perc5Location(15));
%         Minimum(15) = min(Gas. ES);
%         Maximum(15) = max(Gas. ES);
%         Average(15) = mean(Gas. ES);
%         MedC(15) = median(Gas. ES);
%         SumEmissions(15) = sum(Gas.ES);

    %% Tank Venting (gas)

    % Data prep
        Gas. TV = data(:,20);
        Gas. TV(Gas. TV==0) = NaN;
        ind = isnan(Gas. TV);
        Gas. TV = Gas. TV(~ind);
        SortC = sort(Gas. TV,'descend');
        SumC = nansum(Gas. TV);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(16) = ceil(length(Gas. TV)*0.05);

    % Parameters
        ContributionPerc5(16) = CumC(Perc5Location(16));
        ContributionPerc5Norm(16) = CumCNorm(Perc5Location(16));
        Minimum(16) = min(Gas. TV);
        Maximum(16) = max(Gas. TV);
        Average(16) = mean(Gas. TV);
        MedC(16) = median(Gas. TV);
        SumEmissions(16) = sum(Gas.TV);

    %% Flare methane (gas)

    % Data prep
        Gas.FM = data(:,21);
        Gas.FM(Gas.FM==0) = NaN;
        ind = isnan(Gas.FM);
        Gas.FM = Gas.FM(~ind);
        SortC = sort(Gas.FM,'descend');
        SumC = nansum(Gas.FM);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(17) = ceil(length(Gas.FM)*0.05);

    % Parameters
        ContributionPerc5(17) = CumC(Perc5Location(17));
        ContributionPerc5Norm(17) = CumCNorm(Perc5Location(17));
        Minimum(17) = min(Gas.FM);
        Maximum(17) = max(Gas.FM);
        Average(17) = mean(Gas.FM);
        MedC(17) = median(Gas.FM);
        SumEmissions(17) = sum(Gas.FM);
    
        
%% Save Equipment for plotting

% well = Gas.W;
% sep = Gas.S;
% dehy = Gas.D;
% met = Gas.M;
% Recip = Gas.RC;

%save('Plot_api.mat','well','sep','dehy','met','Recip');

%% Oil equipment

data= dataraw;
[rows, columns] = size(data);

%% EXTEND MATRIX

    for i = 260:273
        matpart = data(data(:,2) == i, :);
        [m,n] = size(matpart);
                
        % The length of the matrix is transformed to the count of actual
        % wells
        % matpart(1,3) = sample = (actual wells) / (sampled wells)
        % (actual wells) = sample * (sampled wells)
        
        len = ceil(matpart(1,3)*m);
                
        % Extend the matrix to the count of actual wells using Matlab's
        % "repmat" function (duplicates copies of the matrix proportional
        % to (actual wells/sampled wells)
        
        matpartextend = repmat(matpart,ceil(len/m),1);
        matpartextend = matpartextend(1:len,:);
        if i > 260
            matpartextend_full = vertcat(matpartextend_full,matpartextend);
        else
            matpartextend_full = matpartextend;
        end
    end

    data = matpartextend_full;

    % The emissions matrix is broken out as follows:
    % oil : Oil wells with no gas production
    % gaswoil : Oil wells with gas production and GOR < 100 Mscf/bbl
    
    dataplot.assoc = data(data(:,2) < 270 & data(:,2) > 259,:);
    dataplot.assoc(:,22) = sum(dataplot.assoc(:,6:21),2);
    dataplot.assoc(:,23) = dataplot.assoc(:,22)./dataplot.assoc(:,4);
%     dataplot.assoc(:,1) = dataplot.assoc(:,1) + 60;
    dataplot.assoc(:,1) = dataplot.assoc(:,1);

    dataplot.oil = data(data(:,2) > 269,:);
    dataplot.oil(:,22) = sum(dataplot.oil(:,6:21),2);
    dataplot.oil(:,23) = dataplot.oil(:,22)./dataplot.oil(:,4);
%     dataplot.oil(:,1) = dataplot.oil(:,1) + 60;
    dataplot.oil(:,1) = dataplot.oil(:,1);
    %% Wells (oil)

    % Data prep
        Oil.W = data(:,6);
        Oil.W(Oil.W==0) = NaN;
        ind = isnan(Oil.W);
        Oil.W = Oil.W(~ind);
        SortC = sort(Oil.W,'descend');
        SumC = nansum(Oil.W);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(18) = ceil(length(Oil.W)*0.05);

    % Parameters
        ContributionPerc5(18) = CumC(Perc5Location(18));
        ContributionPerc5Norm(17) = CumCNorm(Perc5Location(18));
        Minimum(18) = min(Oil.W);
        Maximum(18) = max(Oil.W);
        Average(18) = mean(Oil.W);
        MedC(18) = median(Oil.W);
        SumEmissions(18) = sum(Oil.W);
        
    %% Header (oil)

    % Data prep
        Oil.HD = data(:,7);
        Oil.HD(Oil.HD==0) = NaN;
        ind = isnan(Oil.HD);
        Oil.HD = Oil.HD(~ind);
        SortC = sort(Oil.HD,'descend');
        SumC = nansum(Oil.HD);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(19) = ceil(length(Oil.HD)*0.05);

    % Parameters
        ContributionPerc5(19) = CumC(Perc5Location(19));
        ContributionPerc5Norm(19) = CumCNorm(Perc5Location(19));
        Minimum(19) = min(Oil.HD);
        Maximum(19) = max(Oil.HD);
        Average(19) = mean(Oil.HD);
        MedC(19) = median(Oil.HD);
        SumEmissions(19) = sum(Oil.HD);   

    %% Heater (oil)

    % Data prep
        Oil.H = data(:,8);
        Oil.H(Oil.H==0) = NaN;
        ind = isnan(Oil.H);
        Oil.H = Oil.H(~ind);
        SortC = sort(Oil.H,'descend');
        SumC = nansum(Oil.H);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);

    % Parameters
        Perc5Location(20) = ceil(length(Oil.H)*0.05);
        ContributionPerc5(20) = CumC(Perc5Location(20));
        ContributionPerc5Norm(20) = CumCNorm(Perc5Location(20));
        Minimum(20) = min(Oil.H);
        Maximum(20) = max(Oil.H);
        Average(20) = mean(Oil.H);
        MedC(20) = median(Oil.H);
        SumEmissions(20) = sum(Oil.H);
            
    %% Oil separators

    % Data prep
        Oil.S = data(:,9);
        Oil.S(Oil.S==0) = NaN;
        ind = isnan(Oil.S);
        Oil.S = Oil.S(~ind);
        SortC = sort(Oil.S,'descend');
        SumC = nansum(Oil.S);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(21) = ceil(length(Oil.S)*0.05);

    % Parameters
        ContributionPerc5(21) = CumC(Perc5Location(21));
        ContributionPerc5Norm(21) = CumCNorm(Perc5Location(21));
        Minimum(21) = min(Oil.S);
        Maximum(21) = max(Oil.S);
        Average(21) = mean(Oil.S);
        MedC(21) = median(Oil.S);
        SumEmissions(21) = sum(Oil.S);

    %% Tanks - leaks(oil)

    % Data prep
        Oil.TKl = data(:,11);
        Oil.TKl(Oil.TKl==0) = NaN;
        ind = isnan(Oil.TKl);
        Oil.TKl = Oil.TKl(~ind);
        SortC = sort(Oil.TKl,'descend');
        SumC = nansum(Oil.TKl);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(23) = ceil(length(Oil.TKl)*0.05);

    % Parameters
        ContributionPerc5(23) = CumC(Perc5Location(23));
        ContributionPerc5Norm(23) = CumCNorm(Perc5Location(23));
        Minimum(23) = min(Oil.TKl);
        Maximum(23) = max(Oil.TKl);
        Average(23) = mean(Oil.TKl);
        MedC(23) = median(Oil.TKl);
        SumEmissions(23) = sum(Oil.TKl);

    %% Tanks - vents(oil)

    % Data prep
        Oil.TKv = data(:,12);
        Oil.TKv(Oil.TKv==0) = NaN;
        ind = isnan(Oil.TKv);
        Oil.TKv = Oil.TKv(~ind);
        SortC = sort(Oil.TKv,'descend');
        SumC = nansum(Oil.TKv);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(24) = ceil(length(Oil.TKv)*0.05);

    % Parameters
        ContributionPerc5(24) = CumC(Perc5Location(24));
        ContributionPerc5Norm(24) = CumCNorm(Perc5Location(24));
        Minimum(24) = min(Oil.TKv);
        Maximum(24) = max(Oil.TKv);
        Average(24) = mean(Oil.TKv);
        MedC(24) = median(Oil.TKv);
        SumEmissions(24) = sum(Oil.TKv);

     %% CIP (oil)

    % Data prep
        Oil.CIP = data(:,15);
        Oil.CIP(Oil.CIP==0) = NaN;
        ind = isnan(Oil.CIP);
        Oil.CIP = Oil.CIP(~ind);
        SortC = sort(Oil.CIP,'descend');
        SumC = nansum(Oil.CIP);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(27) = ceil(length(Oil.CIP)*0.05);

%     % Parameters
        ContributionPerc5(27) = CumC(Perc5Location(27));
        ContributionPerc5Norm(27) = CumCNorm(Perc5Location(27));
        Minimum(27) = min(Oil.CIP);
        Maximum(27) = max(Oil.CIP);
        Average(27) = mean(Oil.CIP);
        MedC(27) = median(Oil.CIP);
        SumEmissions(27) = sum(Oil.CIP);

    %% PC (oil)

    % Data prep
        Oil.PC = data(:,16);
        Oil.PC(Oil.PC==0) = NaN;
        ind = isnan(Oil.PC);
        Oil.PC = Oil.PC(~ind);
        SortC = sort(Oil.PC,'descend');
        SumC = nansum(Oil.PC);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(28) = ceil(length(Oil.PC)*0.05);

    % Parameters
        ContributionPerc5(28) = CumC(Perc5Location(28));
        ContributionPerc5Norm(28) = CumCNorm(Perc5Location(28));
        Minimum(28) = min(Oil.PC);
        Maximum(28) = max(Oil.PC);
        Average(28) = mean(Oil.PC);
        MedC(28) = median(Oil.PC);
        SumEmissions(28) = sum(Oil.PC);


    %% Completions (oil)

    % Data prep
%         Oil.CM = data(:,18);
%         Oil.CM(Oil.CM==0) = NaN;
%         ind = isnan(Oil.CM);
%         Oil.CM = Oil.CM(~ind);
%         SortC = sort(Oil.CM,'descend');
%         SumC = nansum(Oil.CM);
%         NormSortC = SortC/SumC;
%         CumCNorm = cumsum(NormSortC);
%         CumC = cumsum(SortC);
%         Perc5Location(29) = ceil(length(Oil.CM)*0.05);
% 
%     % Parameters
%         ContributionPerc5(29) = CumC(Perc5Location(29));
%         ContributionPerc5Norm(29) = CumCNorm(Perc5Location(29));
%         Minimum(29) = min(Oil.CM);
%         Maximum(29) = max(Oil.CM);
%         Average(29) = mean(Oil.CM);
%         MedC(29) = median(Oil.CM);
%         SumEmissions(29) = sum(Oil.CM);
% 
%     %% Workovers (oil)
% 
%     % Data prep
%         Oil.WK = data(:,19);
%         Oil.WK(Oil.WK==0) = NaN;
%         ind = isnan(Oil.WK);
%         Oil.WK = Oil.WK(~ind);
%         SortC = sort(Oil.WK,'descend');
%         SumC = nansum(Oil.WK);
%         NormSortC = SortC/SumC;
%         CumCNorm = cumsum(NormSortC);
%         CumC = cumsum(SortC);
%         Perc5Location(30) = ceil(length(Oil.WK)*0.05);
% 
%     % Parameters
%         ContributionPerc5(30) = CumC(Perc5Location(30));
%         ContributionPerc5Norm(30) = CumCNorm(Perc5Location(30));
%         Minimum(30) = min(Oil.WK);
%         Maximum(30) = max(Oil.WK);
%         Average(30) = mean(Oil.WK);
%         MedC(30) = median(Oil.WK);
%         SumEmissions(30) = sum(Oil.WK);

    %% Engine Slip (oil)

    % Data prep
%         Oil.ES = data(:,20);
%         Oil.ES(Oil.ES==0) = NaN;
%         ind = isnan(Oil.ES);
%         Oil.ES = Oil.ES(~ind);
%         SortC = sort(Oil.ES,'descend');
%         SumC = nansum(Oil.ES);
%         NormSortC = SortC/SumC;
%         CumCNorm = cumsum(NormSortC);
%         CumC = cumsum(SortC);
%         Perc5Location(31) = ceil(length(Oil.ES)*0.05);
% 
%     % Parameters
%         ContributionPerc5(31) = CumC(Perc5Location(31));
%         ContributionPerc5Norm(31) = CumCNorm(Perc5Location(31));
%         Minimum(31) = min(Oil.ES);
%         Maximum(31) = max(Oil.ES);
%         Average(31) = mean(Oil.ES);
%         MedC(31) = median(Oil.ES);
%         SumEmissions(31) = sum(Oil.ES);

    %% Tank Venting (oil)

    % Data prep
        Oil.TV = data(:,20);
        Oil.TV(Oil.TV==0) = NaN;
        ind = isnan(Oil.TV);
        Oil.TV = Oil.TV(~ind);
        SortC = sort(Oil.TV,'descend');
        SumC = nansum(Oil.TV);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(33) = ceil(length(Oil.TV)*0.05);

    % Parameters
        ContributionPerc5(33) = CumC(Perc5Location(33));
        ContributionPerc5Norm(33) = CumCNorm(Perc5Location(33));
        Minimum(33) = min(Oil.TV);
        Maximum(33) = max(Oil.TV);
        Average(33) = mean(Oil.TV);
        MedC(33) = median(Oil.TV);
        SumEmissions(33) = sum(Oil.TV);

    %% Flare methane (oil)

    % Data prep
        Oil.FM = data(:,21);
        Oil.FM(Oil.FM==0) = NaN;
        ind = isnan(Oil.FM);
        Oil.FM = Oil.FM(~ind);
        SortC = sort(Oil.FM,'descend');
        SumC = nansum(Oil.FM);
        NormSortC = SortC/SumC;
        CumCNorm = cumsum(NormSortC);
        CumC = cumsum(SortC);
        Perc5Location(34) = ceil(length(Oil.FM)*0.05);

    % Parameters
        ContributionPerc5(34) = CumC(Perc5Location(34));
        ContributionPerc5Norm(34) = CumCNorm(Perc5Location(34));
        Minimum(34) = min(Oil.FM);
        Maximum(34) = max(Oil.FM);
        Average(34) = mean(Oil.FM);
        MedC(34) = median(Oil.FM);
        SumEmissions(34) = sum(Oil.FM);

% Convert our data from kg/day to Tg/year
Study.Gas = SumEmissions(1:17) * 365/10^9;

Superemitters = sum(ContributionPerc5) * 365/10^9;

Study.Oil = SumEmissions(18:34) * 365/10^9;

% REPLACE COMPLETIONS AND WORKOVERS
Study.Gas(13) = Gas.completions;
Study.Gas(14) = Gas.workovers;
Study.Gas(15) = Gas.Combustion;

Study.Oil(13) = Oil.completions;
Study.Oil(14) = Oil.workovers;

% Combustion emissions are added to the site-level vectors
load('EF_Comp_v2');

if k == 1
    Study.All = [Study.Gas', Study.Oil'];
    if welloption == 1
        addlength = length(dataplot.drygas(:,1)) + length(dataplot.gaswoil(:,1));
        EF = [EF; zeros(addlength - length(EF),1)];
        EF = EF(randperm(length(EF)));
        
        welldata.drygas = dataplot.drygas(:,[1 22]);
        welldata.gaswoil = dataplot.gaswoil(:,[1 22]);
        
        welldata.drygas(:,2) = welldata.drygas(:,2) + EF(1:length(dataplot.drygas(:,1)));
        welldata.gaswoil(:,2) = welldata.gaswoil(:,2) + EF((length(dataplot.drygas(:,1))+1):end);
        
        welldata.assoc = dataplot.assoc(:,[1 22]);
        welldata.oil = dataplot.oil(:,[1 22]);
    end
else
    Study.All = [Study.Gas', Study.Oil'];
    if welloption == 1
        welldata.drygas(:,:,k) = dataplot.drygas(:,[1 22]);
        welldata.gaswoil(:,:,k) = dataplot.gaswoil(:,[1 22]);
        welldata.assoc(:,:,k) = dataplot.assoc(:,[1 22]);
        welldata.oil(:,:,k) = dataplot.oil(:,[1 22]);
    end
end

if equipoption == 1
    equipdata.drygas = [dataplot.drygas(:,6:21) dataplot.drygas(:,1) dataplot.drygas(:,4) dataplot.drygas(:,5)];
    equipdata.gaswoil = [dataplot.gaswoil(:,6:21) dataplot.gaswoil(:,1) dataplot.gaswoil(:,4) dataplot.gaswoil(:,5)];
    equipdata.assoc = [dataplot.assoc(:,6:21) dataplot.assoc(:,1) dataplot.assoc(:,4) dataplot.assoc(:,5)];
    equipdata.oil = [dataplot.oil(:,6:21) dataplot.oil(:,1) dataplot.oil(:,4) dataplot.oil(:,5)];
end

% Study.All = sum(Study.All,2);
EmissionsGas = Study.All(:,1);
EmissionsOil = Study.All(:,2);



