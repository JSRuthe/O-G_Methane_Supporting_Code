clear;
clc;
%% Inputs

% Define colors to use in plots
StanfordRed = [140/255,21/255,21/255]; %Stanford red
StanfordOrange = [233/255,131/255,0/255];% Stanford orange
StanfordYellow = [234/255,171/255,0/255];% Stanford yello
StanfordLGreen = [0/255,155/255,118/255];% Stanford light green
StanfordDGreen = [23/255,94/255,84/255];% Stanford dark green
StanfordBlue = [0/255,152/255,219/255];% Stanford blue
StanfordPurple = [83/255,40/255,79/255];% Stanford purple
Sandstone = [210/255,194/255,149/255];
LightGrey = [0.66, 0.66, 0.66];


Plunger.TotalReals = 43649;
NoPlunger.TotalReals = 30026;

%% Import data

% Col 1 = Measured Methane Emitted Per Event (scf/event)
% Col 2 = Annual Venting Events Reported by Operator (events/year)

mat = importdata('Plunger_Auto.csv');
data.PlungerAuto = mat;
mat = importdata('Plunger_Manual.csv');
data.PlungerManual = mat;
mat = importdata('NonPlunger.csv');
data.NoPlunger = mat;

Frac_Manual = 27373/(27373+1763);
    
%% Table for plot legend

    Table(1,1) = mean(data.PlungerAuto(:,1));        % Plunger auto
    Table(1,2) = mean(data.PlungerAuto(:,2));
    Table(2,1) = mean(data.PlungerManual(:,1));      % Plunger manual
    Table(2,2) = mean(data.PlungerManual(:,2));
    Table(3,1) = mean(data.NoPlunger(:,1));      % Non-plunger
    Table(3,2) = mean(data.NoPlunger(:,2));


%% Monte Carlo realizations for Plunger lift

Plunger.EmissionsTable = zeros(Plunger.TotalReals,1);

for i = 1:Plunger.TotalReals
    RandFrac = rand;
    if RandFrac <= Frac_Manual
        RandomEF = ceil(rand*size(data.PlungerManual,1));
        RandomAF = ceil(rand*size(data.PlungerManual,1));
        Plunger.EmissionsTable(i,1) = data.PlungerManual(RandomEF,1)*data.PlungerManual(RandomAF,2);
    else
        RandomEF = ceil(rand*size(data.PlungerAuto,1));
        RandomAF = ceil(rand*size(data.PlungerAuto,1));
        Plunger.EmissionsTable(i,1) = data.PlungerAuto(RandomEF,1)*data.PlungerAuto(RandomAF,2);
    end
end

%% Montel Carlo realizations for No Plunger lift

NoPlunger.EmissionsTable = zeros(NoPlunger.TotalReals,1);

for i = 1:NoPlunger.TotalReals
    
        RandomEF = ceil(rand*size(data.NoPlunger,1));
        RandomAF = ceil(rand*size(data.NoPlunger,1));
        NoPlunger.EmissionsTable(i,1) = data.NoPlunger(RandomEF,1)*data.NoPlunger(RandomAF,2);

end

NoPlunger.EmissionsTable = NoPlunger.EmissionsTable * 19.23 / (1000*365); % kg/day
Plunger.EmissionsTable = Plunger.EmissionsTable * 19.23 / (1000*365); % kg/day

% Create a percentile distribution
NoPlunger.Percentile = prctile(NoPlunger.EmissionsTable,[0.1:0.1:100]);
Plunger.Percentile = prctile(Plunger.EmissionsTable,[0.1:0.1:100]);

figure(1)
subplot(1,2,1)

hold on
[~,edges] = histcounts(log10(data.PlungerManual(:,1)));
histogram(data.PlungerManual(:,1),10.^edges,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',3,'EdgeColor',StanfordRed);

[~,edges] = histcounts(log10(data.PlungerAuto(:,1)));
histogram(data.PlungerAuto(:,1),10.^edges,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',3,'EdgeColor',StanfordBlue);

[~,edges] = histcounts(log10(data.NoPlunger(:,1)));
histogram(data.NoPlunger(:,1),10.^edges,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',3,'EdgeColor',Sandstone);

ylim([0 0.8])
set(gca,'xscale','log')
set(gca,'FontSize',12)
xlabel('Emission factor [scf/event]');
ylabel('Probability density');
set(gca,'FontName','Arial')
xlim([10^2 10^6])

subplot(1,2,2)

hold on
[~,edges] = histcounts(log10(data.PlungerManual(:,2)));
histogram(data.PlungerManual(:,2),10.^edges,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',3,'EdgeColor',StanfordRed);

[~,edges] = histcounts(log10(data.PlungerAuto(:,2)));
histogram(data.PlungerAuto(:,2),10.^edges,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',3,'EdgeColor',StanfordBlue);

[~,edges] = histcounts(log10(data.NoPlunger(:,2)));
histogram(data.NoPlunger(:,2),10.^edges,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',3,'EdgeColor',Sandstone);


ylim([0 0.8])
set(gca,'xscale','log')
set(gca,'FontSize',12)
xlabel('Frequency [events/well]')
set(gca,'FontName','Arial')
xlim([10^1 10^4])


figure(2)
hold on
semilogy(NoPlunger.Percentile)
semilogy(Plunger.Percentile)

Total = sum(Plunger.EmissionsTable)+sum(NoPlunger.EmissionsTable)
Total = Total * 365 / 10^9 % Tg/year
