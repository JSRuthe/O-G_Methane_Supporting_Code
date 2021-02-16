clear;
clc;
%% Inputs

% Tranches are as follows:

% 1 = Plunger < 100 events/year
% 2 = Plunger > 100 events/year
% 3 = NoPlunger < 10 events/year
% 4 = NoPlunger 10 < events/year < 50
% 5 = NoPlunger 50 < events/year < 200
% 6 = NoPlunger > 200 events/year

Plunger.TotalReals = 10000;
Plunger.Frac1 = 0.830;
Plunger.Frac2 = 0.170 + 0.830;

NoPlunger.TotalReals = 10000;
NoPlunger.Frac3 = 0.853;
NoPlunger.Frac4 = 0.136 + 0.853;
NoPlunger.Frac5 = 0.010 + 0.136 + 0.853;
NoPlunger.Frac6 = 0.001 + 0.010 + 0.136 + 0.853;

%% Import data

% Col 1 = Measured Methane Emitted Per Event (scf/event)
% Col 2 = Annual Venting Events Reported by Operator (events/year)

mat = importdata('Plunger.csv');
data.Plunger = mat;
mat = importdata('NoPlunger.csv');
data.NoPlunger = mat;

% Average events per year are based on surveys by Allen et al 2013
% Plunger events/well based on Table S5-7
Plunger.events1 = 206500/26754;
Plunger.events2 = 6563200/5471;

% Nonplunger events/well based on Table S5-2
NoPlunger.events3 = 18691/6378;
NoPlunger.events4 = 20593/1016;
NoPlunger.events5 = 5969/79;
NoPlunger.events6 = 2705/8;


%% Bin data

% Assign indices

    Plunger.ind1 = (data.Plunger(:,2) < 100);
    Plunger.ind2 = (data.Plunger(:,2) > 100);
    NoPlunger.ind3 = (data.NoPlunger(:,2) < 10);
    NoPlunger.ind4 = (data.NoPlunger(:,2) > 10  & data.NoPlunger(:,2) < 50); 
    NoPlunger.ind5 = (data.NoPlunger(:,2) > 50  & data.NoPlunger(:,2) < 200); 
    NoPlunger.ind6 = (data.NoPlunger(:,2) > 200);
   
% Separate by categories

    Plunger.mat1 = data.Plunger(Plunger.ind1 == 1,1);
    Plunger.mat2 = data.Plunger(Plunger.ind2 == 1,1);
    NoPlunger.mat3 = data.NoPlunger(NoPlunger.ind3 == 1,1);
    NoPlunger.mat4 = data.NoPlunger(NoPlunger.ind4 == 1,1);
    NoPlunger.mat5 = data.NoPlunger(NoPlunger.ind5 == 1,1);
    NoPlunger.mat6 = 35000;
    
% Multiply by events data to convert to scf/well

    Plunger.mat1 = Plunger.mat1 * Plunger.events1;
    Plunger.mat2 = Plunger.mat2 * Plunger.events2;
    NoPlunger.mat3 = NoPlunger.mat3 * NoPlunger.events3;
    NoPlunger.mat4 = NoPlunger.mat4 * NoPlunger.events4;
    NoPlunger.mat5 = NoPlunger.mat5 * NoPlunger.events5;
    NoPlunger.mat6 = NoPlunger.mat6 * NoPlunger.events6;
    
%% Monte Carlo realizations for Plunger lift

Plunger.EmissionsTable = zeros(Plunger.TotalReals,1);

for i = 1:Plunger.TotalReals
    RandFrac = rand;
    if RandFrac <= Plunger.Frac1
        RandomIndex = ceil(rand*size(Plunger.mat1,1));
        Plunger.EmissionsTable(i,1) = Plunger.mat1(RandomIndex);
    else
        RandomIndex = ceil(rand*size(Plunger.mat2,1));
        Plunger.EmissionsTable(i,1) = Plunger.mat2(RandomIndex);
    end
end

%% Montel Carlo realizations for No Plunger lift

NoPlunger.EmissionsTable = zeros(NoPlunger.TotalReals,1);

for i = 1:NoPlunger.TotalReals
    RandFrac = rand;
    if RandFrac <= NoPlunger.Frac3
        RandomIndex = ceil(rand*size(NoPlunger.mat3,1));
        NoPlunger.EmissionsTable(i,1) = NoPlunger.mat3(RandomIndex);
    elseif RandFrac > NoPlunger.Frac3 && RandFrac <= NoPlunger.Frac4
        RandomIndex = ceil(rand*size(NoPlunger.mat4,1));
        NoPlunger.EmissionsTable(i,1) = NoPlunger.mat4(RandomIndex);
    elseif RandFrac > NoPlunger.Frac4 && RandFrac <= NoPlunger.Frac5
        RandomIndex = ceil(rand*size(NoPlunger.mat5,1));
        NoPlunger.EmissionsTable(i,1) = NoPlunger.mat5(RandomIndex);
    else
        RandomIndex = ceil(rand*size(NoPlunger.mat6,1));
        NoPlunger.EmissionsTable(i,1) = NoPlunger.mat6(RandomIndex);
    end
end

NoPlunger.EmissionsTable = NoPlunger.EmissionsTable * 19.23 / (1000*365); % kg/day
Plunger.EmissionsTable = Plunger.EmissionsTable * 19.23 / (1000*365); % kg/day

% Create a percentile distribution
NoPlunger.Percentile = prctile(NoPlunger.EmissionsTable,[0.1:0.1:100]);
Plunger.Percentile = prctile(Plunger.EmissionsTable,[0.1:0.1:100]);

figure(1)
hold on
semilogy(NoPlunger.Percentile)
semilogy(Plunger.Percentile)
