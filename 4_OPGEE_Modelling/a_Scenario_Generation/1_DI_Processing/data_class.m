function [M_out,count,totalprod,averageprod] = data_class(M_in, cutoff)

M_in(M_in <= 0) = 99E-8;
[size_mat,~] = size(M_in);

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
M_in(:,3) = M_in(:,2)./M_in(:,1);

% Assigning logind variable
logind = zeros(size_mat,7);

    % Identify rows with zero oil or gas production
    logind(:,7) = (M_in(:,2) == 99E-8  & M_in(:,1) == 99E-8);

    % Classify rows according to gas and oil production
    logind(:,1) = (M_in(:,3) > cutoff  & M_in(:,1) == 99E-8 & logind(:,7) ~= 1); % gas only
    logind(:,2) = (M_in(:,3) < cutoff  & M_in(:,2) == 99E-8 & logind(:,7) ~= 1); % oil only
    logind(:,3) = (M_in(:,3) > cutoff  & M_in(:,1) ~= 99E-8 & logind(:,7) ~= 1); % gas with oil
    logind(:,4) = (M_in(:,3) < cutoff  & M_in(:,2) ~= 99E-8 & logind(:,7) ~= 1); % gas with oil
    logind(:,5) = (M_in(:,3) > cutoff  & M_in(:,2) == 99E-8 & logind(:,7) ~= 1); % should be zero
    logind(:,6) = (M_in(:,3) < cutoff  & M_in(:,1) == 99E-8 & logind(:,7) ~= 1); % should be zero
    
%(i) Separate by categories
    
    %   Dry gas from gas wells
        ind.drygas = logind(:,1);
        count.drygas = sum(ind.drygas);
        ind.drygas = int16(ind.drygas);
        M_out.drygas = M_in(ind.drygas == 1,:);
        totalprod.drygas(1,2) = sum(M_out.drygas(:,2)) * (365.25/1000000); % convert to Bscf/year
        averageprod.drygas(1,1) = mean(M_out.drygas(:,1));
        averageprod.drygas(1,2) = mean(M_out.drygas(:,2));
    
    %   Gas with associated oil
        ind.gaswoil = logind(:,3);
        count.gaswoil = sum(ind.gaswoil);
        ind.gaswoil = int16(ind.gaswoil);
        M_out.gaswoil = M_in(ind.gaswoil == 1,:);
        totalprod.gaswoil(1,1) = sum(M_out.gaswoil(:,1)) * (365.25/1000000); % convert to MMbbl/year;
        totalprod.gaswoil(1,2) = sum(M_out.gaswoil(:,2)) * (365.25/1000000); % convert to Bscf/year;
        averageprod.gaswoil(1,1) = mean(M_out.gaswoil(:,1));
        averageprod.gaswoil(1,2) = mean(M_out.gaswoil(:,2));
    
    %   Oil only
        ind.oil = logind(:,2);
        count.oil = sum(ind.oil);
        ind.oil = int16(ind.oil);
        M_out.oil = M_in(ind.oil == 1,:);    
        averageprod.oil = mean(M_out.oil(:,1));
        totalprod.oil(1,1) = sum(M_out.oil(:,1)) * (365.25/1000000); % convert to MMbbl/year;
        %totalprod.oil(1,2) = sum(M_out.oil(:,2));
        averageprod.oil(1,1) = mean(M_out.oil(:,1));
        %averageprod.oil(1,2) = mean(M_out.oil(:,2));
    
    %   Oil with gas
        ind.oilwgas = logind(:,4);
        count.oilwgas = sum(ind.oilwgas);
        ind.oilwgas = int16(ind.oilwgas);
        M_out.oilwgas = M_in(ind.oilwgas == 1,:);      
        totalprod.oilwgas(1,1) = sum(M_out.oilwgas(:,1)) * (365.25/1000000); % convert to MMbbl/year;
        totalprod.oilwgas(1,2) = sum(M_out.oilwgas(:,2)) * (365.25/1000000); % convert to Bscf/year;
        averageprod.oilwgas(1,1) = mean(M_out.oilwgas(:,1));
        averageprod.oilwgas(1,2) = mean(M_out.oilwgas(:,2));
        GORoil = (M_out.oilwgas(:,2) * 1000) ./ M_out.oilwgas(:,1);
        
    %   Concatenating gas
        ind.gasall = ind.drygas + ind.gaswoil;
        ind.gasall = double(ind.gasall);
        count.gasall = sum(ind.gasall);        
        ind.gasall = int16(ind.gasall);
        M_out.gasall = M_in(ind.gasall == 1,:);
        totalprod.gasall(1,1) = sum(M_out.gasall(:,1)) * (365.25/1000000); % convert to MMbbl/year;
        totalprod.gasall(1,2) = sum(M_out.gasall(:,2)) * (365.25/1000000); % convert to Bscf/year;
        averageprod.gasall(1,1) = mean(M_out.gasall(:,1));
        averageprod.gasall(1,2) = mean(M_out.gasall(:,2));
       

%% HOW TO HANDLE CO-PRODUCED GAS FROM OIL WELLS

% Adding coproduced gas to oil wells with no reported gas production
% Begin by loading data generated in 'api_grab_matlab.m'

load('GOR_data.mat'); %GOR in units of scf/bbl
size_oil = sum(ind.oil);
coprodgas = zeros(size_oil,3);
coprodgas(:,1) = M_out.oil(:,1); % oil with no gas production

for i = 1:size_oil
    RandomIndex = ceil(rand*size(GOR_sort,1));
    
    % Pull a random GOR 
    coprodgas(i,2) = GOR_sort(RandomIndex);
    coprodgas(i,3) = coprodgas(i,1)*coprodgas(i,2); % calculate gas production in units of scf/day
end

% Concatenating oil sections
M_out.oil(:,2) = coprodgas(:,3)/1000;
M_out.oilall = vertcat(M_out.oilwgas, M_out.oil);

% paste summary of co-produced gas and total oil
% co produced gas from oil-only
        totalprod.oil(1,2) = sum(M_out.oil(:,2)) * (365.25/1000000);
        averageprod.oil(1,2) = mean(M_out.oil(:,2));
% Total gas from oil wells
        count.oilall = count.oilwgas + count.oil;       
        totalprod.oilall(1,1) = sum(M_out.oilall(:,1)) * (365.25/1000000); % convert to MMbbl/year;
        totalprod.oilall(1,2) = sum(M_out.oilall(:,2)) * (365.25/1000000); % convert to Bscf/year;
        averageprod.oilall(1,1) = mean(M_out.oilall(:,1));
        averageprod.oilall(1,2) = mean(M_out.oilall(:,2));
   
