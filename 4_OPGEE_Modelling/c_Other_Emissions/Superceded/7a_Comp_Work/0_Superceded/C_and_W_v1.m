clear;
clc;
%% Inputs

% Tranches are as follows:

% Gas
% 1	Non-HF / vented
% 2	Non-HF / flared
% 3	HF / Non-REC / Venting
% 4	HF / Non-REC / Flaring
% 5	HF / REC / Venting
% 6	HF / REC / Flaring
% 
% Oil
% 1	Non-HF / vented
% 2	HF / Non-REC / Venting
% 3	HF / Non-REC / Flaring
% 4	HF / REC / Venting
% 5	HF / REC / Flaring

% Gas workovers
tot(1,1) = 7038;
tot(1,2) = 328;
tot(1,3) = 286;
tot(1,4) = 95;
tot(1,5) = 1642;
tot(1,6) = 487;

% Gas completions
tot(2,1) = 612;
tot(2,2) = 177;
tot(2,3) = 105;
tot(2,4) = 331;
tot(2,5) = 3048;
tot(2,6) = 1793;

% Oil workovers
tot(3,1) = 0;
tot(3,2) = 0;
tot(3,3) = 0;
tot(3,4) = 120;
tot(3,5) = 0;
tot(3,6) = 571;

% Oil completions
tot(4,1) = 3617;
tot(4,2) = 0;
tot(4,3) = 1495;
tot(4,4) = 1519;
tot(4,5) = 3733;
tot(4,6) = 5389;

TotalSum = zeros(4,6);
%% Import data

% Workovers are first, completions are second

mat = importdata('data_cw_2017.csv');
data.workovers = mat(1:6,:);
data.completions = mat(7:12,:);

%% Gas workovers

TotalEmissions.GasWork = zeros(6,7038);

for i = 1:6
    for j = 1:tot(1,i)
        RandomIndex = ceil(rand*size(data.workovers,2));
        TotalEmissions.GasWork(i,j) = data.workovers(i,RandomIndex);
    end
end

TotalSum(1,:) = sum(TotalEmissions.GasWork,2);

%% Gas completions

TotalEmissions.GasComp = zeros(6,3048);

for i = 1:6
    for j = 1:tot(2,i)
        RandomIndex = ceil(rand*size(data.completions,2));
        TotalEmissions.GasComp(i,j) = data.completions(i,RandomIndex);
    end
end

TotalSum(2,:) = sum(TotalEmissions.GasComp,2);

%% Oil workovers

TotalEmissions.OilWork = zeros(6,571);

for i = 1:6
    for j = 1:tot(3,i)
        RandomIndex = ceil(rand*size(data.workovers,2));
        TotalEmissions.OilWork(i,j) = data.workovers(i,RandomIndex);
    end
end

TotalSum(3,:) = sum(TotalEmissions.OilWork,2);

%% Oil completions

TotalEmissions.OilComp = zeros(6,5389);

for i = 1:6
    for j = 1:tot(4,i)
        RandomIndex = ceil(rand*size(data.completions,2));
        TotalEmissions.OilComp(i,j) = data.completions(i,RandomIndex);
    end
end

TotalSum(4,:) = sum(TotalEmissions.OilComp,2);

%% Print outputs
% Units are tonnes CH4/year
fprintf(1,'Gas Workovers: , %6.1f \n' ,sum(TotalSum(1,:),2));
fprintf(1,'Gas Completions: , %6.1f \n' ,sum(TotalSum(2,:),2));
fprintf(1,'Oil Workovers: , %6.1f \n' ,sum(TotalSum(3,:),2));
fprintf(1,'Oil Completions: , %6.1f \n' ,sum(TotalSum(4,:),2));