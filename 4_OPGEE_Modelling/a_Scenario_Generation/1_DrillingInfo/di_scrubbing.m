%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DI DATA ANALYSIS CODE
% Jeff Rutherford
% last updated August 4, 2020

% The purpose of this code is to process well-level data from Drillinginfo
%
% This code:
%   (i) gather information about US well counts and productivity
%   (ii) generates well "tranches" with average productivity, well counts
%   and total productivity for input into OPGEE Lite
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% PREPROCESSING

clear,clc,close all

format long

% Define colors to use in plots
    StanfordRed = [140/255,21/255,21/255]; %Stanford red
    StanfordOrange = [233/255,131/255,0/255];% Stanford orange
    StanfordYellow = [234/255,171/255,0/255];% Stanford yello
    StanfordLGreen = [0/255,155/255,118/255];% Stanford light green
    StanfordDGreen = [23/255,94/255,84/255];% Stanford dark green
    StanfordBlue = [0/255,152/255,219/255];% Stanford blue
    StanfordPurple = [83/255,40/255,79/255];% Stanford purple
    LightGrey = [0.66, 0.66, 0.66];

% Parameters for processing

    cutoff = 100;% Mscf/bbl

% The file 'data_lyon_2015_no_offshore.csv' contains data DI data provided by David
% Lyon on August 14, 2019, with offshore and inactive wells removed

    csvFileName = 'david_lyon_2015_no_offshore.csv';
    file = fopen(csvFileName);
    M.raw = csvread(csvFileName,0,0);
    fclose(file);

% Data is organized as follows:
% Col 1 = oil (bbl/year)
% Col 2 = gas (Mscf/year)
% Col 3 = well count (in TX, a row is a lease with multiple wells, source =
% David Lyons)

% First transform the array so that each row corresponds to a well

    [size_mat,~] = size(M.raw);
    M.raw(:,3) = round(M.raw(:,3));
    total_wells = sum(M.raw(:,3));
    M.new = zeros(total_wells,2);

row = 1;
for i = 1:size_mat
    wells = M.raw(i,3);
    if wells == 1
        M.new(row,1) = M.raw(i,1)/365.25;
        M.new(row,2) = M.raw(i,2)/365.25;
        row = row + 1;
    else
        for j = 1:wells
            prod.oil = M.raw(i,1)/wells/365.25; % Convert to bbl/day
            prod.gas = M.raw(i,2)/wells/365.25; % Convert to Mscf/day
            M.new(row,1) = prod.oil;
            M.new(row,2) = prod.gas;
            row = row + 1;
        end
    end
    x = 1;
end

M.new(M.new <= 0) = 99E-8;
[size_mat,~] = size(M.new);

% Create empty matrices

count.drygas = zeros(1,1);
count.gaswoil = zeros(1,1);
count.oil = zeros(1,1);
count.oilwgas = zeros(1,1);
count.gasall = zeros(1,1);

totalprod.drygas = zeros(1,2);
totalprod.gaswoil = zeros(1,2);
totalprod.oil = zeros(1,2);
totalprod.oilwgas = zeros(1,2);
totalprod.gasall = zeros(1,2);

averageprod.drygas = zeros(1,2);
averageprod.gaswoil = zeros(1,2);
averageprod.oil = zeros(1,2);
averageprod.oilwgas = zeros(1,2);
averageprod.gasall = zeros(1,2);
    
% Add a test GOR for oil with gas
     GORoil = zeros(size_mat,1);
   
        
%% DATA CLASSIFICATION

% Calculate GOR
M.new(:,3) = M.new(:,2)./M.new(:,1);

% Assigning logind variable
logind = zeros(size_mat,7);

    % Identify rows with zero oil or gas production
    logind(:,7) = (M.new(:,2) == 99E-8  & M.new(:,1) == 99E-8);

    % Classify rows according to gas and oil production
    logind(:,1) = (M.new(:,3) > cutoff  & M.new(:,1) == 99E-8 & logind(:,7) ~= 1); % gas only
    logind(:,2) = (M.new(:,3) < cutoff  & M.new(:,2) == 99E-8 & logind(:,7) ~= 1); % oil only
    logind(:,3) = (M.new(:,3) > cutoff  & M.new(:,1) ~= 99E-8 & logind(:,7) ~= 1); % gas with oil
    logind(:,4) = (M.new(:,3) < cutoff  & M.new(:,2) ~= 99E-8 & logind(:,7) ~= 1); % gas with oil
    logind(:,5) = (M.new(:,3) > cutoff  & M.new(:,2) == 99E-8 & logind(:,7) ~= 1); % should be zero
    logind(:,6) = (M.new(:,3) < cutoff  & M.new(:,1) == 99E-8 & logind(:,7) ~= 1); % should be zero
    
%(i) Separate by categories
    
    %   Dry gas from gas wells
        ind.drygas = logind(:,1);
        count.drygas = sum(ind.drygas);
        ind.drygas = int16(ind.drygas);
        M.drygas = M.new(ind.drygas == 1,:);
        totalprod.drygas(1,2) = sum(M.drygas(:,2)) * (365.25/1000000); % convert to Bscf/year
        averageprod.drygas(1,1) = mean(M.drygas(:,1));
        averageprod.drygas(1,2) = mean(M.drygas(:,2));
    
    %   Gas with associated oil
        ind.gaswoil = logind(:,3);
        count.gaswoil = sum(ind.gaswoil);
        ind.gaswoil = int16(ind.gaswoil);
        M.gaswoil = M.new(ind.gaswoil == 1,:);
        totalprod.gaswoil(1,1) = sum(M.gaswoil(:,1)) * (365.25/1000000); % convert to MMbbl/year;
        totalprod.gaswoil(1,2) = sum(M.gaswoil(:,2)) * (365.25/1000000); % convert to Bscf/year;
        averageprod.gaswoil(1,1) = mean(M.gaswoil(:,1));
        averageprod.gaswoil(1,2) = mean(M.gaswoil(:,2));
    
    %   Oil only
        ind.oil = logind(:,2);
        count.oil = sum(ind.oil);
        ind.oil = int16(ind.oil);
        M.oil = M.new(ind.oil == 1,:);    
        averageprod.oil = mean(M.oil(:,1));
        totalprod.oil(1,1) = sum(M.oil(:,1)) * (365.25/1000000); % convert to MMbbl/year;
        %totalprod.oil(1,2) = sum(M.oil(:,2));
        averageprod.oil(1,1) = mean(M.oil(:,1));
        %averageprod.oil(1,2) = mean(M.oil(:,2));
    
    %   Oil with gas
        ind.oilwgas = logind(:,4);
        count.oilwgas = sum(ind.oilwgas);
        ind.oilwgas = int16(ind.oilwgas);
        M.oilwgas = M.new(ind.oilwgas == 1,:);      
        totalprod.oilwgas(1,1) = sum(M.oilwgas(:,1)) * (365.25/1000000); % convert to MMbbl/year;
        totalprod.oilwgas(1,2) = sum(M.oilwgas(:,2)) * (365.25/1000000); % convert to Bscf/year;
        averageprod.oilwgas(1,1) = mean(M.oilwgas(:,1));
        averageprod.oilwgas(1,2) = mean(M.oilwgas(:,2));
        GORoil = (M.oilwgas(:,2) * 1000) ./ M.oilwgas(:,1);
        
    %   Concatenating gas
        ind.gasall = ind.drygas + ind.gaswoil;
        ind.gasall = double(ind.gasall);
        count.gasall = sum(ind.gasall.*wells);        
        ind.gasall = int16(ind.gasall);
        M.gasall = M.new(ind.gasall == 1,:);
        totalprod.gasall(1,1) = sum(M.gasall(:,1)) * (365.25/1000000); % convert to MMbbl/year;
        totalprod.gasall(1,2) = sum(M.gasall(:,2)) * (365.25/1000000); % convert to Bscf/year;
        averageprod.gasall(1,1) = mean(M.gasall(:,1));
        averageprod.gasall(1,2) = mean(M.gasall(:,2));
    
    %   CONCATENATING OF OIL IS DONE BELOW AFTER HANDLING OF CO-PRODUCED GAS  
        
        
    %   PRINT OUTPUTS FROM THIS SECTION
    
        % Header
        fprintf(1,'        # wells     Total oil (MMbbls)     Total gas (Bscf/yr)     Average oil (bbl/day well)     Average gas (Mscf/day well)\n');
        % Data
        fprintf(1,'G only  %0.0f        0                 %0.0f             0                           %4.2f\n' ,count.drygas,totalprod.drygas(1,2),averageprod.drygas(1,2));
        fprintf(1,'G w oil %0.0f        %0.0f             %0.0f             %4.2f                       %4.2f\n' ,count.gaswoil,totalprod.gaswoil(1,1),totalprod.gaswoil(1,2),averageprod.gaswoil(1,1),averageprod.gaswoil(1,2));
        fprintf(1,'O only  %0.0f        %0.0f             0                 %4.2f                       0\n'     ,count.oil,totalprod.oil(1,1),averageprod.oil(1,1));
        fprintf(1,'O w gas %0.0f        %0.0f             %0.0f             %4.2f                       %4.2f\n' ,count.oilwgas,totalprod.oilwgas(1,1),totalprod.oilwgas(1,2),averageprod.oilwgas(1,1),averageprod.oilwgas(1,2));
        fprintf(1,'G total %0.0f        %0.0f             %0.0f             %4.2f                       %4.2f\n' ,count.gasall,totalprod.gasall(1,1),totalprod.gasall(1,2),averageprod.gasall(1,1),averageprod.gasall(1,2));
     
%% HOW TO HANDLE CO-PRODUCED GAS FROM OIL WELLS

% Adding coproduced gas to oil wells with no reported gas production
% Begin by loading data generated in 'api_grab_matlab.m'

load('GOR_data.mat'); %GOR in units of scf/bbl
size_oil = sum(ind.oil);
coprodgas = zeros(size_oil,3);
coprodgas(:,1) = M.oil(:,1); % oil with no gas production

for i = 1:size_oil
    RandomIndex = ceil(rand*size(GOR_sort,1));
    
    % Pull a random GOR 
    coprodgas(i,2) = GOR_sort(RandomIndex);
    coprodgas(i,3) = coprodgas(i,1)*coprodgas(i,2); % calculate gas production in units of scf/day
end

% Concatenating oil sections
M.oil(:,2) = coprodgas(:,3)/1000;
M.oilall = vertcat(M.oilwgas, M.oil);

% paste summary of co-produced gas and total oil
% co produced gas from oil-only
        totalprod.oil(1,2) = sum(M.oil(:,2)) * (365.25/1000000);
        averageprod.oil(1,2) = mean(M.oil(:,2));
% Total gas from oil wells
        count.oilall = count.oilwgas + count.oil;       
        totalprod.oilall(1,1) = sum(M.oilall(:,1)) * (365.25/1000000); % convert to MMbbl/year;
        totalprod.oilall(1,2) = sum(M.oilall(:,2)) * (365.25/1000000); % convert to Bscf/year;
        averageprod.oilall(1,1) = mean(M.oilall(:,1));
        averageprod.oilall(1,2) = mean(M.oilall(:,2));
   
        fprintf(1,'O only+ %0.0f        %0.0f             %0.0f             %4.2f                       %4.2f\n' ,count.oil,totalprod.oil(1,1),totalprod.oil(1,2),averageprod.oil(1,1),averageprod.oil(1,2));
        fprintf(1,'O total %0.0f        %0.0f             %0.0f             %4.2f                       %4.2f\n' ,count.oilall,totalprod.oilall(1,1),totalprod.oilall(1,2),averageprod.oilall(1,1),averageprod.oilall(1,2));
          
%% BINNING - DRY GAS WELLS
        
%(i) Determine bin indices and bin means
    edges_gas_set = [0, 1, 5, 10, 20, 50, 100, 500, 1000, 10000,500000000];
    [counts_gas, edges_gas, ind_gas] = histcounts(M.drygas(:,2), edges_gas_set);
    
%(ii) Determine bin means
    bin_ave_gas = accumarray(ind_gas, M.drygas(:,2),[],@mean);
    bin_sum_gas = accumarray(ind_gas, M.drygas(:,2),[],@sum);
    bin_sum_oilwg = accumarray(ind_gas, M.drygas(:,1),[],@sum);

    bins_exp = zeros((length(edges_gas_set)-1),4);
    
    bins_exp(:,1) = counts_gas';
    bins_exp(:,2) = bin_ave_gas';
    bins_exp(:,3) = bin_sum_gas';
    bins_exp(:,4) = bin_sum_oilwg';
    
%(iii) Print outputs to a text file
    
%       csvwrite('gasdry_bins_v2015_no_offshore.csv',bins_exp)  

%% BINNING - ASSOC GAS WELLS
      
%(i) Determine bin indices and bin means
    edges_gas_set = [0, 1, 5, 10, 20, 50, 100, 500, 1000, 10000,500000000];
    [counts_gas, edges_gas, ind_gas] = histcounts(M.gaswoil(:,2), edges_gas_set);
    
%(ii) Determine bin means
    bin_ave_gas = accumarray(ind_gas, M.gaswoil(:,2),[],@mean);
    bin_sum_gas = accumarray(ind_gas, M.gaswoil(:,2),[],@sum);
    bin_sum_oilwg = accumarray(ind_gas, M.gaswoil(:,1),[],@sum);

    bins_exp = zeros((length(edges_gas_set)-1),4);
    
    bins_exp(:,1) = counts_gas';
    bins_exp(:,2) = bin_ave_gas';
    bins_exp(:,3) = bin_sum_gas';
    bins_exp(:,4) = bin_sum_oilwg';
    
%(iii) Print outputs to a text file
    
%       csvwrite('gasassoc_bins_v2015_no_offshore.csv',bins_exp)  
      
%% BINNING - OIL WELLS
        
%(ii) Determine bin indices and bin means

    edges_oil_set = [0, 1, 5, 10, 20, 50, 100, 500, 1000, 10000,1500000];
    [counts_oil, edges_oil, ind_oil] = histcounts(M.oilwgas(:,2), edges_oil_set);
    
% %(iii) Determine bin means

    bin_ave_gas = accumarray(ind_oil, M.oilwgas(:,2),[],@mean);
    bin_sum_gas = accumarray(ind_oil, M.oilwgas(:,2),[],@sum);
    bin_sum_oilwg = accumarray(ind_oil, M.oilwgas(:,1),[],@sum);

    bins_exp = zeros((length(edges_oil_set)-1),4);
    
    bins_exp(:,1) = counts_oil';
    bins_exp(:,2) = bin_ave_gas';
    bins_exp(:,3) = bin_sum_gas';
    bins_exp(:,4) = bin_sum_oilwg';
    
%(iii) Print outputs to a text file
    
%       csvwrite('oil_bins_v2015_no_offshore.csv',bins_exp)

%% BINNING - WET WELLS

%(ii) Determine bin indices and bin means

    edges_oil_set = [0, 0.5, 1, 10,1500000];
    [counts_oil, edges_oil, ind_oil] = histcounts(M.oil(:,2), edges_oil_set);
    
% %(iii) Determine bin means

    bin_ave_gas = accumarray(ind_oil, M.oil(:,2),[],@mean);
    bin_sum_gas = accumarray(ind_oil, M.oil(:,2),[],@sum);
    bin_sum_oilwg = accumarray(ind_oil, M.oil(:,1),[],@sum);

    bins_exp = zeros((length(edges_oil_set)-1),4);
    
    bins_exp(:,1) = counts_oil';
    bins_exp(:,2) = bin_ave_gas';
    bins_exp(:,3) = bin_sum_gas';
    bins_exp(:,4) = bin_sum_oilwg';
    
%(iii) Print outputs to a text file
    
%       csvwrite('oilwet_bins_v2015_no_offshore.csv',bins_exp)
     
%% PLOTTING

edges_plots = [0,10,100,1000,500000000];
bin_plot.gas = zeros(4,1);
bin_plot.assoc = zeros(4,1);
bin_plot.oil = zeros(4,1);

%determine bin counts for histogram
    [counts_gas, edges_gas, ind_gas] = histcounts(M.gasall(:,2), edges_plots);
    bin_plot.gas = accumarray(ind_gas, M.gasall(:,2),[],@sum);
    
    [counts_assoc, edges_assoc, ind_assoc] = histcounts(M.oilwgas(:,2), edges_plots);
    bin_plot.assoc = accumarray(ind_assoc, M.oilwgas(:,2),[],@sum);    
  
    [counts_oil, edges_oil, ind_oil] = histcounts(M.oil(:,2), edges_plots);
    bin_plot.oil = accumarray(ind_oil, M.oil(:,2),[],@sum);    
    
% concatenate for plotting

    bin_plot.fig1 = [counts_gas; counts_assoc; counts_oil];
    bin_plot.oil(4,1) = 0;
    bin_plot.fig2 = [bin_plot.gas, bin_plot.assoc, bin_plot.oil];
    x = {'<10','10-100','100-1,000','>10,000'};
%     x = reordercats(x,{'<10','10-100','100-1,000','>10,000'});    
% Plotting

figure(3)
subplot(2,1,1)
    H1 = bar(bin_plot.fig1','stack');
    
    set(H1(1),'facecolor',StanfordRed)
    set(H1(2),'facecolor',StanfordDGreen)
    set(H1(3),'facecolor',LightGrey)
    
    AX1=legend(H1, {'Gas','Assoc.','Oil'}, 'Location','Best','FontSize',8);

    set(gca,'XTick',1:4,'XTickLabel',x);
    
    bin_sums = sum(bin_plot.fig1);
    total_sum = sum(bin_sums);
    frac = bin_sums/total_sum;
    xt=[1:4];
    yt = sum(bin_plot.fig1) + 2500;
    
    for i = 1:4
        text(xt(i),yt(i),num2str(frac(i)*100,'%0.1f%%'),'vert','bottom','horiz','center','fontsize',12,'fontweight','bold');
    end
    
    set(gca,'FontSize',12)
    set(gca,'FontName','Arial')
    %ylim([0 5*10^7])
    ylabel('Well counts');
    
subplot(2,1,2)  
    H2 = bar(bin_plot.fig2,'stack');
    
    set(H2(1),'facecolor',StanfordRed)
    set(H2(2),'facecolor',StanfordDGreen)
    set(H2(3),'facecolor',LightGrey)
    
    %AX2=legend(H2, {'Gas','Assoc.','Oil'}, 'Location','Best','FontSize',8);
    
    set(gca,'XTick',1:4,'XTickLabel',x);
    
    bin_plot.fig2 = bin_plot.fig2';
    bin_sums = sum(bin_plot.fig2);
    total_sum = sum(bin_sums);
    frac = bin_sums/total_sum;
    xt=[1:4];
    yt = sum(bin_plot.fig2) + 400000;
    
    for i = 1:4
        text(xt(i),yt(i),num2str(frac(i)*100,'%0.1f%%'),'vert','bottom','horiz','center','fontsize',12,'fontweight','bold');
    end
    
    set(gca,'FontSize',12)
    set(gca,'FontName','Arial')
    ylim([0 6*10^7])
    ylabel('Gas production [Mscf/d]');
    xlabel('Well productivity [Mscf/well/d]');
    
%     print('-djpeg','-r600','Cohort_stats.jpg');