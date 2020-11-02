%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HISTOGRAM OF ALL COMPONENTS
% Jeff Rutherford
% last updated July 31, 2020
%
% The purpose of this code is to generate aggregated histograms of all
% component-level emissions factors.
% 
% Input data:
%   (i) Component-level survey data: 
%           LGemitters.mat - exported from Methane_Data_Gathering on
%           October 31, 2020
%           SMemitters.mat - exported from Methane_Data_Gathering on
%           October 31, 2020
%   (ii) EPA Bagged (quantified) Data
%           West - EPA_1995_BagPeg.csv
%           East - Star_Quantification.csv
%   (iii) EPA correlation equation data
%           West - API_Correlation.csv
%           East - Star_Correlation.csv
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Clean up workspace
clc
clear
close all

% Define x and y vectors from 0 to 1
identX = (0:0.01:1);
identY = (0:0.01:1);

%% Inputs

% How many trials to perform?
Trials = 10000;

%% Data processing

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


%% Import data using external .m file
load 'LGemitters'; 
StudyEmissions = EmissionsKgD;

    OTH = StudyEmissions(find(ismember(Component,'OTH')));
    OTH = OTH(isfinite(OTH));
    REG = StudyEmissions(find(ismember(Component,'REG')));
    REG = REG(isfinite(REG));
    VL = StudyEmissions(find(ismember(Component,'VL')));
    VL = VL(isfinite(VL));
    TC = StudyEmissions(find(ismember(Component,'TC')+ismember(Component,'F')));
    TC = TC(isfinite(TC));
    OEL = StudyEmissions(find(ismember(Component,'OEL')));
    OEL = OEL(isfinite(OEL));
    PRV = StudyEmissions(find(ismember(Component,'PRV')));
    PRV = PRV(isfinite(PRV));
    PC = StudyEmissions(find(ismember(Component,'PC')));
    PC = PC(isfinite(PC));
    CIP = StudyEmissions(find(ismember(Component,'CIP')));
    CIP = CIP(isfinite(CIP));
    TK = StudyEmissions(find(ismember(Component,'TH')+ismember(Component,'TP')+ismember(Component,'TV')));
    TK = TK(isfinite(TK));

    ALL = [OTH; REG; VL; TC; OEL; PRV; PC; CIP; TK];
    StudyEmissions = ALL;

    StudyEmissions(StudyEmissions==0) = NaN;
    StudyEmissions(StudyEmissions < 0) = NaN;
    ind = isnan(StudyEmissions);
    ThisStudy.Pegged= StudyEmissions(~ind);

    Prciles.StudyPegged = prctile(ThisStudy.Pegged,[2.5 50 97.5]);
    Hi.StudyPegged = Prciles.StudyPegged(:,3);
    Med.StudyPegged = Prciles.StudyPegged(:,2);
    Lo.StudyPegged = Prciles.StudyPegged(:,1);
    Hi.StudyPegged = Hi.StudyPegged - Med.StudyPegged;
    Lo.StudyPegged = Med.StudyPegged - Lo.StudyPegged;
    Meen.StudyPegged = mean(ThisStudy.Pegged);

load 'SMemitters'; 
StudyEmissions = EmissionsKgD;

    OTH = StudyEmissions(find(ismember(Component,'OTH')));
    OTH = OTH(isfinite(OTH));
    REG = StudyEmissions(find(ismember(Component,'REG')));
    REG = REG(isfinite(REG));
    VL = StudyEmissions(find(ismember(Component,'VL')));
    VL = VL(isfinite(VL));
    TC = StudyEmissions(find(ismember(Component,'TC')+ismember(Component,'F')));
    TC = TC(isfinite(TC));
    OEL = StudyEmissions(find(ismember(Component,'OEL')));
    OEL = OEL(isfinite(OEL));
    PRV = StudyEmissions(find(ismember(Component,'PRV')));
    PRV = PRV(isfinite(PRV));
    PC = StudyEmissions(find(ismember(Component,'PC')));
    PC = PC(isfinite(PC));
    CIP = StudyEmissions(find(ismember(Component,'CIP')));
    CIP = CIP(isfinite(CIP));
    TK = StudyEmissions(find(ismember(Component,'TH')+ismember(Component,'TP')+ismember(Component,'TV')));
    TK = TK(isfinite(TK));

    ALL = [OTH; REG; VL; TC; OEL; PRV; PC; CIP; TK];
    StudyEmissions = ALL;

    StudyEmissions(StudyEmissions==0) = NaN;
    StudyEmissions(StudyEmissions < 0) = NaN;
    ind = isnan(StudyEmissions);
    ThisStudy.LoEmitters= StudyEmissions(~ind);

    Prciles.LoEmitters = prctile(ThisStudy.LoEmitters,[2.5 50 97.5]);
    Hi.LoEmitters = Prciles.LoEmitters(:,3);
    Med.LoEmitters = Prciles.LoEmitters(:,2);
    Lo.LoEmitters = Prciles.LoEmitters(:,1);
    Hi.LoEmitters = Hi.LoEmitters - Med.LoEmitters;
    Lo.LoEmitters = Med.LoEmitters - Lo.LoEmitters;
    Meen.LoEmitters = mean(ThisStudy.LoEmitters);
    
StarCorr=importdata('Star_Correlation.csv');

    Prciles.StarC = prctile(StarCorr,[2.5 50 97.5]);
    Hi.StarC = Prciles.StarC(:,3);
    Med.StarC = Prciles.StarC(:,2);
    Lo.StarC = Prciles.StarC(:,1);
    Hi.StarC = Hi.StarC - Med.StarC;
    Lo.StarC = Med.StarC - Lo.StarC;
    Meen.StarC = mean(StarCorr);

StarQuant=importdata('Star_Quantification.csv'); 

    Prciles.StarQ = prctile(StarQuant,[2.5 50 97.5]);
    Hi.StarQ = Prciles.StarQ(:,3);
    Med.StarQ = Prciles.StarQ(:,2);
    Lo.StarQ = Prciles.StarQ(:,1);
    Hi.StarQ = Hi.StarQ - Med.StarQ;
    Lo.StarQ = Med.StarQ - Lo.StarQ;
    Meen.StarQ = mean(StarQuant);
    
APICorr = importdata('API_Correlation.csv');
% APIQuant=importdata('API_Pegged.csv'); 
data = importdata('EPA_1995_BagPeg.csv');
APIQuant = data.data;

    Prciles.APIC = prctile(APICorr,[2.5 50 97.5]);
    Hi.APIC = Prciles.APIC(:,3);
    Med.APIC = Prciles.APIC(:,2);
    Lo.APIC = Prciles.APIC(:,1);
    Hi.APIC = Hi.APIC - Med.APIC;
    Lo.APIC = Med.APIC - Lo.APIC;
    Meen.APIC = mean(APICorr);
    
    Prciles.APIQ = prctile(APIQuant,[2.5 50 97.5]);
    Hi.APIQ = Prciles.APIQ(:,3);
    Med.APIQ = Prciles.APIQ(:,2);
    Lo.APIQ = Prciles.APIQ(:,1);
    Hi.APIQ = Hi.APIQ - Med.APIQ;
    Lo.APIQ = Med.APIQ - Lo.APIQ;
    Meen.APIQ = mean(APIQuant);
    
N = 40;
start = 10^-5;
stop = 10^5;
b = 10.^linspace(log10(start),log10(stop),N+1);

ha = tight_subplot(4,1,[.01 .02],[.15 .05],[.1 .1]);

axes(ha(3));

    er = errorbar(Med.StudyPegged,0.3, Lo.StudyPegged, Hi.StudyPegged,'horizontal');
    er.Color = StanfordRed;
    er.LineWidth = 1;
        set(get(get(er,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        hold on
        ln = plot(Med.StudyPegged,0.3,'o');
        ln.MarkerEdgeColor = StanfordRed;
        ln.MarkerFaceColor = StanfordRed;
        ln.MarkerSize = 6;
        ln = plot(Meen.StudyPegged,0.3,'s');
        ln.MarkerEdgeColor = StanfordRed;
        label = num2str(Meen.StudyPegged,'%4.3f'); c = cellstr(label);
        dy = 0.07; 
        text(Meen.StudyPegged, 0.3+dy, c,'Color',StanfordRed, 'FontSize', 8, 'HorizontalAlignment', 'center');
        set(get(get(ln,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    
    er = errorbar(Med.StarQ,0.2, Lo.StarQ, Hi.StarQ,'horizontal');
    er.Color = StanfordBlue;
    er.LineWidth = 1;
        set(get(get(er,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        ln = plot(Med.StarQ,0.2,'o');
        ln.MarkerEdgeColor = StanfordBlue;
        ln.MarkerFaceColor = StanfordBlue;
        ln.MarkerSize = 6;
        ln = plot(Meen.StarQ,0.2,'s');
        ln.MarkerEdgeColor = StanfordBlue;
        set(get(get(ln,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        label = num2str(Meen.StarQ,'%4.3f'); c = cellstr(label);
        dy = 0.07; 
        text(Meen.StarQ, 0.2+dy, c,'Color',StanfordBlue, 'FontSize', 8, 'HorizontalAlignment', 'center');
           
    histogram(ThisStudy.Pegged,b,'Normalization','probability','FaceColor',StanfordRed,'EdgeColor','k','FaceAlpha',1);
        ylabel('Probability');
%         set(gca,'YTickLabel',[]);
        set(gca,'XMinorTick','on','YMinorTick','on')
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
        ylim([0 0.5]);    

    hold on;

    yyaxis right

    histogram(StarQuant,b,'Normalization','probability','FaceColor',StanfordBlue,'EdgeColor','k','FaceAlpha',1);

    set(gca,'xscale','log')
%     hlegend = legend(...
%         'Study',...
%         'Eastern Hi Flow',...
%         'Location','best');
%         hlegend.FontSize = 8;

        xlabel('Emissions [kg CH_{4}/d]');
        ylabel('Probability');
%         set(gca,'YTickLabel',[]);


        set(gca,'FontSize',8)
        set(gca,'FontName','Arial')
        set(gca,'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
        set(gca,'XTickLabel',{'10^{-4}','10^{-2}', '10^{0}','10^{2}','10^{4}'});

        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        axis_a = gca;
        % set box property to off and remove background color
        set(axis_a,'box','off','color','none')
        % create new, empty axes with box but without ticks
        axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
        % set original axes as active
        axes(axis_a)
        % link axes in case of zooming
        linkaxes([axis_a axis_b])
        ylim([0 0.8]); 

axes(ha(4));

    er = errorbar(Med.LoEmitters,0.4, Lo.LoEmitters, Hi.LoEmitters,'horizontal');
    er.Color = LightGrey;
    er.LineWidth = 1;
        set(get(get(er,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        hold on
        ln = plot(Med.LoEmitters,0.4,'o');
        ln.MarkerEdgeColor = LightGrey;
        ln.MarkerFaceColor = LightGrey;
        ln.MarkerSize = 6;
        ln = plot(Meen.LoEmitters,0.4,'s');
        ln.MarkerEdgeColor = LightGrey;
        label = num2str(Meen.LoEmitters,'%4.3f'); c = cellstr(label);
        dy = 0.07; 
        text(Meen.LoEmitters, 0.4+dy, c,'Color',LightGrey, 'FontSize', 8, 'HorizontalAlignment', 'center');
        set(get(get(ln,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        
    er = errorbar(Med.StarC,0.3, Lo.StarC, Hi.StarC,'horizontal');
    er.Color = StanfordBlue;
    er.LineWidth = 1;
        set(get(get(er,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        ln = plot(Med.StarC,0.3,'o');
        ln.MarkerEdgeColor = StanfordBlue;
        ln.MarkerFaceColor = StanfordBlue;
        ln.MarkerSize = 6;
        ln = plot(Meen.StarC,0.3,'s');
        ln.MarkerEdgeColor = StanfordBlue;
        set(get(get(ln,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        label = num2str(Meen.StarC,'%4.3f'); c = cellstr(label);
        dy = 0.07; 
        text(Meen.StarC, 0.3+dy, c,'Color',StanfordBlue, 'FontSize', 8, 'HorizontalAlignment', 'center');
     
    histogram(ThisStudy.LoEmitters,b,'Normalization','probability','FaceColor',LightGrey,'EdgeColor','k','FaceAlpha',1);
        ylabel('Probability');
%         set(gca,'YTickLabel',[]);
        set(gca,'XMinorTick','on','YMinorTick','on')
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
        ylim([0 0.5]);    
   
    hold on;

    yyaxis right

    histogram(StarCorr,b,'Normalization','probability','FaceColor',StanfordBlue,'EdgeColor','k','FaceAlpha',1);

    set(gca,'xscale','log')
%     hlegend = legend(...
%         'Study',...
%         'Eastern Corr.',...
%         'Location','best');
%         hlegend.FontSize = 8;

        xlabel('Emissions [kg CH_{4}/d]');
        ylabel('Probability');
%         set(gca,'YTickLabel',[]);


        set(gca,'FontSize',8)
        set(gca,'FontName','Arial')
        set(gca,'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
        set(gca,'XTickLabel',{'10^{-4}','10^{-2}', '10^{0}','10^{2}','10^{4}'});

        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        axis_a = gca;
        % set box property to off and remove background color
        set(axis_a,'box','off','color','none')
        % create new, empty axes with box but without ticks
        axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
        % set original axes as active
        axes(axis_a)
        % link axes in case of zooming
        linkaxes([axis_a axis_b])
        ylim([0 0.8]); 
        
        
axes(ha(1));

    er = errorbar(Med.StudyPegged,0.4, Lo.StudyPegged, Hi.StudyPegged,'horizontal');
    er.Color = StanfordRed;
    er.LineWidth = 1;
        set(get(get(er,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        hold on
        ln = plot(Med.StudyPegged,0.4,'o');
        ln.MarkerEdgeColor = StanfordRed;
        ln.MarkerFaceColor = StanfordRed;
        ln.MarkerSize = 6;
        ln = plot(Meen.StudyPegged,0.4,'s');
        ln.MarkerEdgeColor = StanfordRed;
        label = num2str(Meen.StudyPegged,'%4.3f'); c = cellstr(label);
        dy = 0.07; 
        text(Meen.StudyPegged, 0.4+dy, c,'Color',StanfordRed, 'FontSize', 8, 'HorizontalAlignment', 'center');
        set(get(get(ln,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        
    er = errorbar(Med.APIQ,0.2, Lo.APIQ, Hi.APIQ,'horizontal');
    er.Color = Sandstone;
    er.LineWidth = 1;
        set(get(get(er,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        ln = plot(Med.APIQ,0.2,'o');
        ln.MarkerEdgeColor = Sandstone;
        ln.MarkerFaceColor = Sandstone;
        ln.MarkerSize = 6;
        ln = plot(Meen.APIQ,0.2,'s');
        ln.MarkerEdgeColor = Sandstone;
        set(get(get(ln,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        label = num2str(Meen.APIQ,'%4.3f'); c = cellstr(label);
        dy = 0.07; 
        text(Meen.APIQ, 0.2+dy, c,'Color',Sandstone, 'FontSize', 8, 'HorizontalAlignment', 'center');
                   
     histogram(ThisStudy.Pegged,b,'Normalization','probability','FaceColor',StanfordRed,'EdgeColor','k','FaceAlpha',1);
        ylabel('Probability');
%         set(gca,'YTickLabel',[]);
        set(gca,'XMinorTick','on','YMinorTick','on')
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
        ylim([0 0.5]);    

    
    hold on;

    yyaxis right

    histogram(APIQuant,b,'Normalization','probability','FaceColor',Sandstone,'EdgeColor','k','FaceAlpha',1);

    set(gca,'xscale','log')
%     hlegend = legend(...
%         'Study',...
%         'Western Pegged',...
%         'Location','best');

        hlegend.FontSize = 8;

        xlabel('Emissions [kg CH_{4}/d]');
        ylabel('');
%         set(gca,'YTickLabel',[]);

        set(gca,'FontSize',8)
        set(gca,'FontName','Arial')
        set(gca,'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
        set(gca,'XTickLabel',{'10^{-4}','10^{-2}', '10^{0}','10^{2}','10^{4}'});

        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        
        axis_a = gca;
        % set box property to off and remove background color
        set(axis_a,'box','off','color','none')
        % create new, empty axes with box but without ticks
        axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
        % set original axes as active
        axes(axis_a)
        % link axes in case of zooming
        linkaxes([axis_a axis_b])
        ylim([0 0.8])

axes(ha(2));

    er = errorbar(Med.LoEmitters,0.4, Lo.LoEmitters, Hi.LoEmitters,'horizontal');
    er.Color = LightGrey;
    er.LineWidth = 1;
        set(get(get(er,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        hold on
        ln = plot(Med.LoEmitters,0.4,'o');
        ln.MarkerEdgeColor = LightGrey;
        ln.MarkerFaceColor = LightGrey;
        ln.MarkerSize = 6;
        ln = plot(Meen.LoEmitters,0.4,'s');
        ln.MarkerEdgeColor = LightGrey;
        label = num2str(Meen.LoEmitters,'%4.3f'); c = cellstr(label);
        dy = 0.07; 
        text(Meen.LoEmitters, 0.4+dy, c,'Color',LightGrey, 'FontSize', 8, 'HorizontalAlignment', 'center');
        set(get(get(ln,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
         
    er = errorbar(Med.APIC,0.3, Lo.APIC, Hi.APIC,'horizontal');
    er.Color = Sandstone;
    er.LineWidth = 1;
        set(get(get(er,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        ln = plot(Med.APIC,0.3,'o');
        ln.MarkerEdgeColor = Sandstone;
        ln.MarkerFaceColor = Sandstone;
        ln.MarkerSize = 6;
        ln = plot(Meen.APIC,0.3,'s');
        ln.MarkerEdgeColor = Sandstone;
        set(get(get(ln,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        label = num2str(Meen.APIC,'%4.3f'); c = cellstr(label);
        dy = 0.07; 
        text(Meen.APIC, 0.3+dy, c,'Color',Sandstone, 'FontSize', 8, 'HorizontalAlignment', 'center');
            
    histogram(ThisStudy.LoEmitters,b,'Normalization','probability','FaceColor',LightGrey,'EdgeColor','k','FaceAlpha',1);
        ylabel('Probability');
%         set(gca,'YTickLabel',[]);
        set(gca,'XMinorTick','on','YMinorTick','on')
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
        ylim([0 0.5]); 
    
    hold on;

    yyaxis right

    histogram(APICorr,b,'Normalization','probability','FaceColor',Sandstone,'EdgeColor','k','FaceAlpha',1);

    set(gca,'xscale','log')
%     hlegend = legend(...
%         'Study',...
%         'Western Corr.',...
%         'Western Pegged',...
%         'Location','best');
% 
%         hlegend.FontSize = 8;

%         xlabel('Emissions [kg CH_{4}/d]');
%         ylabel('');
%         set(gca,'YTickLabel',[]);

        set(gca,'FontSize',8)
        set(gca,'FontName','Arial')
%         set(gca,'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
%         set(gca,'XTickLabel',{'10^{-4}','10^{-2}', '10^{0}','10^{2}','10^{4}'});
        set(gca,'XTickLabel',[]);
        
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        
        axis_a = gca;
        % set box property to off and remove background color
        set(axis_a,'box','off','color','none')
        % create new, empty axes with box but without ticks
        axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
        % set original axes as active
        axes(axis_a)
        % link axes in case of zooming
        linkaxes([axis_a axis_b])
        ylim([0 0.8])
        
% print('-djpeg','-r600','EPA_observations_v2.jpg');
    