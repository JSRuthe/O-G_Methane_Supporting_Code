clear; clc;

%% Import data

data = importdata('ERG2011_Engines.csv');
horsepower = data(:,1);

% Average horsepower is 256 HP

% Total number of compressors is based off of EPA
%   Total gas wells = 433430
%   Compressors/well = 0.08144

n_comp = 35298;

% EP distribution
% Average is based upon Zavala Araiza 2017 (25% higher than NSPS spec).
% Standard distribution is based upon a 95% CI of 50% around the mean
% mu = 0.00125; % kg/hp*hr
% sigma = (0.001875 - 0.00125)/1.96 = 0.000319

EF = zeros(n_comp,1);

for i = 1:n_comp
    RandomIndex = ceil(rand*size(horsepower,1));
    EP = normrnd(0.00125,0.000319);
    HP = horsepower(RandomIndex);
    EF(i) = EP * HP * 24; % kg/day
end

save('EF_Comp_v2.mat','EF');

Total = sum(EF)*365/10^9

figure(1)

% Set up bins
N = 80;
start = 10^-5;
stop = 10^5;
b = 10.^linspace(log10(start),log10(stop),N+1);

histogram(EF,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor','k');
set(gca,'YLim',[0 0.4])

set(gca, 'XScale', 'log');
set(gca,'FontSize',12)
set(gca,'FontName','Arial')
set(gca,'XTick',[10^-2 10^0 10^2 10^4]);
set(gca,'XTickLabel',{'10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
set(gca,'XMinorTick','off','YMinorTick','off')
set(gca, 'TickDir', 'out')
axis_a = gca;
% set box property to off and remove background color
set(axis_a,'box','off','color','none')
% create new, empty axes with box but without ticks
axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
% set original axes as active
axes(axis_a)
% link axes in case of zooming
linkaxes([axis_a axis_b])
set(gca,'YLim',[0 0.4])
set(gca,'XLim',[0.01 10000])
xlabel('Emissions [kg CH_{4}/d]');

mean(EF)