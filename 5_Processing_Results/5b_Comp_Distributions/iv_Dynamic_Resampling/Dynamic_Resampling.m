%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DYNAMIC RESAMPLING
% Jeff Rutherford
% last updated July 31, 2020
%
% The purpose of this code is to visualize dependence of our
% component-level emissions factors on sample size. We also see if sample
% size is related to differences between our emissions factors and
% emissions factors from EPA data
% 
% Input data:
%   (i) Component-level survey data: 
%           LGemitters.mat - exported from Methane_Data_Gathering on
%           October 31, 2020
%           
%   (ii) EPA data - 
%           Eastern high flow (source Star Environmental 1995 Eastern Wells, 
%               Table 13)
%           Western EPA bagged data (source EPA 1995 protocol document,
%               Table C-2-2)
%               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear; clc;

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

%% LOAD DATA

% EPA data
    % Eastern high flow (source Star Environmental 1995 Eastern Wells, Table 13)
    n.East_Conn = 65;
    n.East_Valve = 24;
    n.East_OEL = 10;
    
    Q.East_Conn = 0.073;
    Q.East_Valve = 0.544;
    Q.East_OEL = 0.115;
    % Western EPA bagged data (source EPA 1995 protocol document, Table
    % C-2-2)
    n.West_Conn = 74;
    n.West_Valve = 223;
    n.West_OEL = 87;
    
    Q.West_Conn = 0.462;
    Q.West_Valve = 1.055;
    Q.West_OEL = 0.495;   


% This study
load 'LGemitters'; 

Component = cellstr(Component);
Equipment = cellstr(Equipment);
Study = cellstr(Study);

% Extract data from datafile
StudyName = Study;
StudyEmissions = EmissionsKgD;

% Extract TC, VL, OEL

TC = StudyEmissions(find(ismember(Component,'TC')+ismember(Component,'F')));
TC = TC(isfinite(TC));

VL = StudyEmissions(find(ismember(Component,'VL')));
VL = VL(isfinite(VL));

OEL = StudyEmissions(find(ismember(Component,'OEL')));
OEL = OEL(isfinite(OEL));

%% PLOTTING

figure(1)
    
% Connectors
    
    h = subplot(2,2,1);
    hold on
    
    vec = zeros(1,1);
    mu = zeros(1,1);
    meanarray = zeros(500,500);
    
    for i = 1:500
         vec = zeros(1,1);
         mu = zeros(1,1);
        for j = 1:500
            RandomIndex = ceil(rand*size(TC(:,1),1));
            vec(1,j) = TC(RandomIndex,1);
            mu(1,j) = mean(vec(1,:));
        end
        meanarray(i,:) = mu;
        p = plot(mu,'LineWidth',0.05,'Color',StanfordRed);
        p.Color(4) = 0.1;
    end

    Y = prctile(meanarray,[5 25 50 75 95],1);

    plot(Y(2,:),'LineWidth',2,'Color','k','LineStyle','--');
    plot(Y(4,:),'LineWidth',2,'Color','k','LineStyle','--');
    plot(Y(1,:),'LineWidth',2,'Color','k','LineStyle',':');
    plot(Y(5,:),'LineWidth',2,'Color','k','LineStyle',':');
    plot(Y(3,:),'LineWidth',2,'Color','k');

    ln = plot(n.East_Conn,Q.East_Conn,'d');
    ln.MarkerEdgeColor = 'k';
    ln.MarkerFaceColor = StanfordOrange;
    ln.MarkerSize = 6;

    ln = plot(n.West_Conn,Q.West_Conn,'s');
    ln.MarkerEdgeColor = 'k';
    ln.MarkerFaceColor = StanfordOrange;
    ln.MarkerSize = 6;
    
%     ln = plot(24,0.624,'o');
%     ln.MarkerEdgeColor = 'k';
%     ln.MarkerFaceColor = StanfordOrange;
%     ln.MarkerSize = 6;
    
    ylim([0 15])
    xlim([0 500])
    ylabel({'Sample mean emissions';'rate [kg CH_{4}/d]'});
    %xlabel('Samples');
    set(h,'FontSize',8)
    set(h,'FontName','Arial')
    set(gca,'XMinorTick','on','YMinorTick','on')
    set(gca, 'TickDir', 'out')
    axis_a = gca;
    % set box property to off and remove background color
    set(axis_a,'box','off','color','none')
    % create new, empty axes with box but without ticks
    axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
    % set original axes as active
    axes(axis_a)

    
% Valves
    
    h = subplot(2,2,2);
    hold on
    
    vec = zeros(1,1);
    mu = zeros(1,1);
    meanarray = zeros(500,500);
    
    for i = 1:500
         vec = zeros(1,1);
         mu = zeros(1,1);
        for j = 1:500
            RandomIndex = ceil(rand*size(VL(:,1),1));
            vec(1,j) = VL(RandomIndex,1);
            mu(1,j) = mean(vec(1,:));
        end
        meanarray(i,:) = mu;
        p = plot(mu,'LineWidth',0.05,'Color',StanfordBlue);
        p.Color(4) = 0.1;
    end

    Y = prctile(meanarray,[5 25 50 75 95],1);

    plot(Y(2,:),'LineWidth',2,'Color','k','LineStyle','--');
    plot(Y(4,:),'LineWidth',2,'Color','k','LineStyle','--');
    plot(Y(1,:),'LineWidth',2,'Color','k','LineStyle',':');
    plot(Y(5,:),'LineWidth',2,'Color','k','LineStyle',':');
    plot(Y(3,:),'LineWidth',2,'Color','k');

    ln =  plot(n.East_Valve,Q.East_Valve,'d');
    ln.MarkerEdgeColor = 'k';
    ln.MarkerFaceColor = StanfordOrange;
    ln.MarkerSize = 6;

    ln = plot(n.West_Valve,Q.West_Valve,'s');  
    ln.MarkerEdgeColor = 'k';
    ln.MarkerFaceColor = StanfordOrange;
    ln.MarkerSize = 6;
    
%     ln = plot(84,2.352,'o');
%     ln.MarkerEdgeColor = 'k';
%     ln.MarkerFaceColor = StanfordOrange;
%     ln.MarkerSize = 6;
    
    ylim([0 15])
    xlim([0 500])
    %ylabel('Sample mean emissions rate [kg CH4/d]');
    xlabel('Samples');
    set(h,'FontSize',8)   
    set(h,'FontName','Arial')
    set(gca,'XMinorTick','on','YMinorTick','on')
    set(gca, 'TickDir', 'out')
    axis_a = gca;
    % set box property to off and remove background color
    set(axis_a,'box','off','color','none')
    % create new, empty axes with box but without ticks
    axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
    % set original axes as active
    axes(axis_a)

    
% OELs
    
    h = subplot(2,2,3);
    hold on
    
    vec = zeros(1,1);
    mu = zeros(1,1);
    meanarray = zeros(500,500);
    
    for i = 1:500
         vec = zeros(1,1);
         mu = zeros(1,1);
        for j = 1:500
            RandomIndex = ceil(rand*size(OEL(:,1),1));
            vec(1,j) = OEL(RandomIndex,1);
            mu(1,j) = mean(vec(1,:));
        end
        meanarray(i,:) = mu;
        p = plot(mu,'LineWidth',0.05,'Color',LightGrey);
        p.Color(4) = 0.1;
    end

    Y = prctile(meanarray,[5 25 50 75 95],1);

    plot(Y(2,:),'LineWidth',2,'Color','k','LineStyle','--');
    plot(Y(4,:),'LineWidth',2,'Color','k','LineStyle','--');
    plot(Y(1,:),'LineWidth',2,'Color','k','LineStyle',':');
    plot(Y(5,:),'LineWidth',2,'Color','k','LineStyle',':');
    plot(Y(3,:),'LineWidth',2,'Color','k');

    ln = plot(n.East_OEL,Q.East_OEL,'d');
    ln.MarkerEdgeColor = 'k';
    ln.MarkerFaceColor = StanfordOrange;
    ln.MarkerSize = 6;

    ln = plot(n.West_OEL,Q.West_OEL,'s');
    ln.MarkerEdgeColor = 'k';
    ln.MarkerFaceColor = StanfordOrange;
    ln.MarkerSize = 6;
    
%     ln = plot(48,1.32,'o');
%     ln.MarkerEdgeColor = 'k';
%     ln.MarkerFaceColor = StanfordOrange;
%     ln.MarkerSize = 6;
%     
    ylim([0 15])
    xlim([0 500])
    ylabel({'Sample mean emissions';'rate [kg CH_{4}/d]'});
    xlabel('Samples');
    set(h,'FontSize',8)
    set(h,'FontName','Arial')
    set(gca,'XMinorTick','on','YMinorTick','on')
    set(gca, 'TickDir', 'out')
    axis_a = gca;
    % set box property to off and remove background color
    set(axis_a,'box','off','color','none')
    % create new, empty axes with box but without ticks
    axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
    % set original axes as active
    axes(axis_a)

        
    h = subplot(2,2,4);
    hold on    

    h1 = plot(nan,nan,'LineWidth',2,'Color','k','LineStyle',':');
    h2 = plot(nan,nan,'LineWidth',2,'Color','k','LineStyle','--');
    h3 = plot(nan,nan,'LineWidth',2,'Color','k');
    h4 = plot(nan,nan,'LineWidth',2,'Color','k','LineStyle','--');
    h5 = plot(nan,nan,'LineWidth',2,'Color','k','LineStyle',':');    
    ln = plot(nan,nan,'d');
    ln.MarkerEdgeColor = 'k';
    ln.MarkerFaceColor = StanfordOrange;
    ln.MarkerSize = 6;
    ln = plot(nan,nan,'s');
    ln.MarkerEdgeColor = 'k';
    ln.MarkerFaceColor = StanfordOrange;
    ln.MarkerSize = 6;
    
    set(h,'Visible','Off')
%     set(h1,'Visible','Off')
%     set(h2,'Visible','Off')
%     set(h3,'Visible','Off')
%     set(ln,'Visible','Off')
    
    hlegend = legend(...
        '5%ile',...
        '25%ile',...
        'Median',...
        '75%ile',...
        '95%ile',...
        'Eastern Hi Flow',...
        'EPA 1995 pegged');
    hlegend.FontSize = 8;
    
% print Resampling_v6.png -dpng -r600 -painters