%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HISTOGRAM OF COMPONENTS - DISAGGREGATED
% Jeff Rutherford
% last updated July 31, 2020
%
% The purpose of this code is to generate disaggregated histograms of all
% component-level emissions factors.
% 
% Input data:
%   (i) Component-level survey data: 
%           LGemitters.mat - exported from Methane_Data_Gathering on
%           October 31, 2020
%           SMemitters.mat - exported from Methane_Data_Gathering on
%           October 31, 2020
%   (ii) EPA data - Western dataset only, not based on 1995 bagged data
%   frmo the Protocol document
%           West - Components_API.mat
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear; clc;

% Define colors to use in plots
StanfordRed = [140/255,21/255,21/255]; %Stanford red
StanfordOrange = [233/255,131/255,0/255];% Stanford orange
StanfordYellow = [234/255,171/255,0/255];% Stanford yello
LightGrey = [0/255,155/255,118/255];% Stanford light green
StanfordDGreen = [23/255,94/255,84/255];% Stanford dark green
Sandstone = [0/255,152/255,219/255];% Stanford blue
StanfordPurple = [83/255,40/255,79/255];% Stanford purple
Sandstone = [210/255,194/255,149/255];
LightGrey = [0.66, 0.66, 0.66];

%% LOAD DATA

% Components

load 'LGemitters'; 
StudyEmissions = EmissionsKgD;

    OTH = StudyEmissions(find(ismember(Component,'OTH')));
    OTH = OTH(isfinite(OTH));
    REG = StudyEmissions(find(ismember(Component,'REG')));
    allstudies_hi.REG = REG(isfinite(REG));
    VL = StudyEmissions(find(ismember(Component,'VL')));
    allstudies_hi.VL = VL(isfinite(VL));
    TC = StudyEmissions(find(ismember(Component,'TC')+ismember(Component,'F')));
    allstudies_hi.TC = TC(isfinite(TC));
    OEL = StudyEmissions(find(ismember(Component,'OEL')));
    allstudies_hi.OEL = OEL(isfinite(OEL));
    PRV = StudyEmissions(find(ismember(Component,'PRV')));
    allstudies_hi.PRV = PRV(isfinite(PRV));
    PC = StudyEmissions(find(ismember(Component,'PC')));
    allstudies_hi.PC = PC(isfinite(PC));
    CIP = StudyEmissions(find(ismember(Component,'CIP')));
    allstudies_hi.CIP = CIP(isfinite(CIP));
    TK = StudyEmissions(find(ismember(Component,'TH')+ismember(Component,'TP')+ismember(Component,'TV')));
    allstudies_hi.TK = TK(isfinite(TK));

load 'SMemitters'; 
StudyEmissions = EmissionsKgD;

    OTH = StudyEmissions(find(ismember(Component,'OTH')));
    OTH = OTH(isfinite(OTH));
    REG = StudyEmissions(find(ismember(Component,'REG')));
    allstudies_lo.REG = REG(isfinite(REG));
    VL = StudyEmissions(find(ismember(Component,'VL')));
    allstudies_lo.VL = VL(isfinite(VL));
    TC = StudyEmissions(find(ismember(Component,'TC')+ismember(Component,'F')));
    allstudies_lo.TC = TC(isfinite(TC));
    OEL = StudyEmissions(find(ismember(Component,'OEL')));
    allstudies_lo.OEL = OEL(isfinite(OEL));
    PRV = StudyEmissions(find(ismember(Component,'PRV')));
    allstudies_lo.PRV = PRV(isfinite(PRV));
    PC = StudyEmissions(find(ismember(Component,'PC')));
    allstudies_lo.PC = PC(isfinite(PC));
    CIP = StudyEmissions(find(ismember(Component,'CIP')));
    allstudies_lo.CIP = CIP(isfinite(CIP));
    TK = StudyEmissions(find(ismember(Component,'TH')+ismember(Component,'TP')+ismember(Component,'TV')));
    allstudies_lo.TK = TK(isfinite(TK));
    
    load 'Components_API'; 

    API.TC = TC;
    API.VL = VL;
    API.OEL = OEL;
    API.PRV = PRV;


%% PLOTTING HISTOGRAMS

%TC
%VL
%OEL
%PRV
%REG   (no API)
%PC    (no API)
%CIP   (no API)
%TK    (no API)

fig = figure(1);
h = tight_subplot(3,3,[.07 .1],[.07 .03],[.1 .05]);
set(fig,'defaultAxesColorOrder',[StanfordDGreen; LightGrey]);
% Set up bins
N = 40;
start = 10^-5;
stop = 10^5;
b = 10.^linspace(log10(start),log10(stop),N+1);

% Connectors
axes(h(1));

    histogram(h(1),allstudies_hi.TC,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',StanfordRed,'FaceAlpha',1);
    hold on
    histogram(h(1),allstudies_hi.TC,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');

    histogram(h(1),allstudies_lo.TC,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',LightGrey,'FaceAlpha',1);
    histogram(h(1),allstudies_lo.TC,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');
    
    %     ylabel('Probability');

        set(h(1), 'TickDir', 'out')
        set(h(1),'TickLength',[0.03 0.035])
        grid(h(1),'on')
        set(h(1),'XMinorGrid','off');
        set(h(1),'XMinorTick','off','YMinorTick','off')
        axis_a = h(1);
        % set box property to off and remove background color
        set(axis_a,'box','off','color','none')
        % create new, empty axes with box but without ticks
        axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
        % set original axes as active
        axes(axis_a)
        % link axes in case of zooming
        linkaxes([axis_a axis_b])
        set(axis_a, 'YLim',[0 0.4]);
     
    yyaxis right
    histogram(h(1),API.TC,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',2,'EdgeColor','none','FaceColor',Sandstone,'FaceAlpha',1);
    hold on
    histogram(h(1),API.TC,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');

    set(h(1),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
    set(h(1),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
    set(h(1), 'YLim',[0 0.6]);
    set(h(1),'XLim',[0.000099 10000])
    set(h(1),'XMinorTick','off','YMinorTick','off')
%     SE = TC_SE;
%     line([SE SE],[0 1],'Color','k','LineStyle','--');
    
% Valves
axes(h(2));

    histogram(allstudies_hi.VL,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',StanfordRed,'FaceAlpha',1);
    hold on
    histogram(allstudies_hi.VL,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');

    histogram(allstudies_lo.VL,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',LightGrey,'FaceAlpha',1);
    histogram(allstudies_lo.VL,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');
  
    set(h(2),'XMinorTick','off','YMinorTick','off')
        set(h(2), 'TickDir', 'out')
        set(h(2),'TickLength',[0.03 0.035])
        grid(h(2),'on')
        set(h(2),'XMinorGrid','off');
        axis_a = gca;
        % set box property to off and remove background color
        set(axis_a,'box','off','color','none')
        % create new, empty axes with box but without ticks
        axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
        % set original axes as active
        axes(axis_a)
        % link axes in case of zooming
        linkaxes([axis_a axis_b])
        set(axis_a, 'YLim',[0 0.4]);
        
yyaxis right
    histogram(API.VL,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',2,'EdgeColor','none','FaceColor',Sandstone,'FaceAlpha',1);
    hold on
    histogram(API.VL,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');

    set(h(2),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
    set(h(2),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
    set(h(2),'XLim',[0.000099 10000])
    set(h(2), 'YLim',[0 0.8]);  
%     SE = VL_SE;
%     line([SE SE],[0 1],'Color','k','LineStyle','--');
    
% Open ended lines
axes(h(3));

    histogram(allstudies_hi.OEL,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',StanfordRed,'FaceAlpha',1);
    hold on
    histogram(allstudies_hi.OEL,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');

    histogram(allstudies_lo.OEL,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',LightGrey,'FaceAlpha',1);
    hold on
    histogram(allstudies_lo.OEL,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');
    
    ylim(h(3),[0 0.35])
        set(h(3),'XMinorTick','off','YMinorTick','off')
        set(h(3), 'TickDir', 'out')
        set(h(3),'TickLength',[0.03 0.035])
        grid(h(3),'on')
        set(h(3),'XMinorGrid','off');
        axis_a = gca;
        % set box property to off and remove background color
        set(axis_a,'box','off','color','none')
        % create new, empty axes with box but without ticks
        axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
        % set original axes as active
        axes(axis_a)
        % link axes in case of zooming
        linkaxes([axis_a axis_b])
        set(axis_a, 'YLim',[0 0.4]);
        
    yyaxis right
    histogram(API.OEL,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',2,'EdgeColor','none','FaceColor',Sandstone,'FaceAlpha',1);
    hold on
    histogram(API.OEL,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');

    set(h(3),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
    set(h(3),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
    set(h(3),'XLim',[0.000099 10000])
    set(h(3), 'YLim',[0 0.6]);  
%     SE = OEL_SE;
%     line([SE SE],[0 1],'Color','k','LineStyle','--');
%     
% Pressure relief valves
axes(h(4));
    histogram(allstudies_hi.PRV,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',StanfordRed,'FaceAlpha',1);
    hold on
    histogram(allstudies_hi.PRV,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');

    histogram(allstudies_lo.PRV,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',LightGrey,'FaceAlpha',1);
    histogram(allstudies_lo.PRV,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k'); 
    
    set(h(4),'XMinorTick','off','YMinorTick','off')
        set(h(4), 'TickDir', 'out')
        set(h(4),'TickLength',[0.03 0.035])
        grid(h(4),'on')
        set(h(4),'XMinorGrid','off');
        axis_a = gca;
        % set box property to off and remove background color
        set(axis_a,'box','off','color','none')
        % create new, empty axes with box but without ticks
        axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
        % set original axes as active
        axes(axis_a)
        % link axes in case of zooming
        linkaxes([axis_a axis_b])
        set(axis_a, 'YLim',[0 0.8]);
        
    yyaxis right
    histogram(API.PRV,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',2,'EdgeColor','none','FaceColor',Sandstone,'FaceAlpha',1);
    hold on
    histogram(API.PRV,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');

    set(h(4),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
    set(h(4),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
    ylim(h(4),[0 0.75])
    set(h(4),'XLim',[0.000099 10000])
    set(h(4), 'YLim',[0 0.6]);  
%     SE = PRV_SE;
%     line([SE SE],[0 1],'Color','k','LineStyle','--');
%     
% Regulator
axes(h(5));
    histogram(allstudies_hi.REG,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',StanfordRed,'FaceAlpha',1);
    hold on
    histogram(allstudies_hi.REG,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');

    histogram(allstudies_lo.REG,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',LightGrey,'FaceAlpha',1);
    histogram(allstudies_lo.REG,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');
    
    set(h(5),'XMinorTick','off','YMinorTick','off')
        set(h(5), 'TickDir', 'out')
        set(h(5),'TickLength',[0.03 0.035])
        grid(h(5),'on')
        set(h(5),'XMinorGrid','off');
        axis_a = gca;
        % set box property to off and remove background color
        set(axis_a,'box','off','color','none')
        % create new, empty axes with box but without ticks
        axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
        % set original axes as active
        axes(axis_a)
        % link axes in case of zooming
        linkaxes([axis_a axis_b])
        set(axis_a, 'YLim',[0 0.8]);
        
    set(h(5),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
    set(h(5),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
    set(h(5),'XLim',[0.000099 10000])
%     SE = REG_SE;
%     line([SE SE],[0 1],'Color','k','LineStyle','--');

% Chemical injection pumps
axes(h(6));
    histogram(allstudies_hi.CIP,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',StanfordRed,'FaceAlpha',1);
    hold on
    histogram(allstudies_hi.CIP,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');
% 
%     histogram(allstudies_lo.CIP,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',LightGrey,'FaceAlpha',1);
%     histogram(allstudies_lo.CIP,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');
    
    set(h(6),'XMinorTick','off','YMinorTick','off')
        set(h(6), 'TickDir', 'out')
        set(h(6),'TickLength',[0.03 0.035])
        grid(h(6),'on')
        set(h(6),'XMinorGrid','off');
        axis_a = gca;
        % set box property to off and remove background color
        set(axis_a,'box','off','color','none')
        % create new, empty axes with box but without ticks
        axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
        % set original axes as active
        axes(axis_a)
        % link axes in case of zooming
        linkaxes([axis_a axis_b])
        set(axis_a, 'YLim',[0 0.4]);
        
    set(h(6),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
    set(h(6),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
    set(h(6),'XLim',[0.000099 10000])
%     SE = CIP_SE;
%     line([SE SE],[0 1],'Color','k','LineStyle','--');
    
% Pneumatic Controllers
axes(h(7));

    histogram(allstudies_hi.PC,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',StanfordRed,'FaceAlpha',1);
    hold on
    histogram(allstudies_hi.PC,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');

%     histogram(allstudies_lo.PC,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',LightGrey,'FaceAlpha',1);
%     histogram(allstudies_lo.PC,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');
% 
%     
    set(h(7),'XMinorTick','off','YMinorTick','off')
        set(h(7), 'TickDir', 'out')
        set(h(7),'TickLength',[0.03 0.035])
        grid(h(7),'on')
        set(h(7),'XMinorGrid','off');
        axis_a = gca;
        % set box property to off and remove background color
        set(axis_a,'box','off','color','none')
        % create new, empty axes with box but without ticks
        axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
        % set original axes as active
        axes(axis_a)
        % link axes in case of zooming
        linkaxes([axis_a axis_b])
   
    set(h(7),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
    set(h(7),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
    xlabel('Emissions [kg CH_{4}/d]');
    ylim(h(7),[0 0.2])
    set(h(7),'XLim',[0.000099 10000])
%     SE = PC_SE;
%     line([SE SE],[0 1],'Color','k','LineStyle','--');
    
% Tanks
axes(h(8));

    histogram(allstudies_hi.TK,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',StanfordRed,'FaceAlpha',1);
    hold on
    histogram(allstudies_hi.TK,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');
    
    histogram(allstudies_lo.TK,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',LightGrey,'FaceAlpha',1);
    histogram(allstudies_lo.TK,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor','k');

    
    set(h(8),'XMinorTick','off','YMinorTick','off')
        set(h(8), 'TickDir', 'out')
        set(h(8),'TickLength',[0.03 0.035])
        grid(h(8),'on')
        set(h(8),'XMinorGrid','off');
        axis_a = gca;
        % set box property to off and remove background color
        set(axis_a,'box','off','color','none')
        % create new, empty axes with box but without ticks
        axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
        % set original axes as active
        axes(axis_a)
        % link axes in case of zooming
        linkaxes([axis_a axis_b])
        set(axis_a, 'YLim',[0 0.3]);
        
    set(h(8),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
    set(h(8),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
    xlabel('Emissions [kg CH_{4}/d]');
    set(h(8),'XLim',[0.000099 10000])
%     SE = TK_SE;
%     line([SE SE],[0 1],'Color','k','LineStyle','--');
    
    set(h,'xscale','log')
    set(h,'FontSize',8)
    set(h,'FontName','Arial')
    set(h,'XMinorTick','off','YMinorTick','off')


figure(2)

% Set up bins
N = 40;
start = 10^-5;
stop = 10^5;
b = 10.^linspace(log10(start),log10(stop),N+1);

    histogram(allstudies_hi.TC,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',Sandstone);
%     hold on
%     histogram(allstudies_hi.VL,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor',Sandstone);
%     histogram(allstudies_hi.OEL,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor',Sandstone);
%     histogram(allstudies_hi.PRV,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor',Sandstone);
%     histogram(allstudies_hi.REG,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor',Sandstone);
%     histogram(allstudies_hi.CIP,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor',Sandstone);
%     histogram(allstudies_hi.PC,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor',Sandstone);
%     histogram(allstudies_hi.TK,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.5,'EdgeColor',Sandstone);

            set(gca, 'XScale', 'log');
            set(gca,'FontSize',20)
            set(gca,'FontName','Arial')
            set(gca,'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
            set(gca,'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
            set(gca,'XMinorTick','off','YMinorTick','off')
            set(gca, 'TickDir', 'out')
            set(gca,'TickLength',[0.03 0.035])
            set(gca,'XLim',[0.000099 10000])
            xlabel('Emissions [kg CH_{4}/d]');
            grid(gca,'on')
            grid off
            
            axis_a = gca;
            % set box property to off and remove background color
            set(axis_a,'box','off','color','none')
            % create new, empty axes with box but without ticks
            axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
            % set original axes as active
            axes(axis_a)
            % link axes in case of zooming
            linkaxes([axis_a axis_b])
            set(axis_a,'YLim',[0 0.2]) 
            pbaspect(axis_a, [1 1 1])
            pbaspect(axis_b, [1 1 1])
%             set(axis_a, {'XColor', 'YColor'}, {Sandstone, Sandstone});
%             set(axis_b, {'XColor', 'YColor'}, {Sandstone, Sandstone});
