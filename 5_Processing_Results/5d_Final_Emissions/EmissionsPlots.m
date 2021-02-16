function [] = EmissionsPlots(EmissionsGas, EmissionsOil, Superemitters, sitedata_All_2, sitedata_All_2_tr, omara_data, n)

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

MyMap = [StanfordRed; StanfordOrange; StanfordYellow; StanfordLGreen; StanfordDGreen];

data=importdata('EPA_import.csv');

EPA.Gas = data(:,1)./1000;
EPA.Oil = data(:,2)./1000;

EPA.All = [EPA.Gas, EPA.Oil];
EPA.All = sum(EPA.All,2);

Study = EmissionsGas + EmissionsOil;

GatherData.All = ...
    [Study(6,:) + Study(7,:)+ Study(16,:);...
     sum(Study(1:5,:))+sum(Study(8:9,:));...
     sum(Study(10:11,:));...
     Study(12,:);...
     sum(Study(13:14,:));...
     Study(15,:);...
     Study(17,:)];
  
EPAData = ...
    [EPA.All(3);...
     EPA.All(1);...
     EPA.All(2);...
     EPA.All(5);...
     sum(EPA.All(4));...
     EPA.All(6);...
     EPA.All(7)];

GatherData.Ave = mean(GatherData.All,2);
GatherData.Prc = prctile(GatherData.All,[2.5 97.5],2);
GatherData.Hi = GatherData.Prc(:,2);
GatherData.Lo = GatherData.Prc(:,1);

SuperemittersAve = mean(Superemitters,2);

GatherData.Hi = GatherData.Hi - GatherData.Ave;
GatherData.Lo = GatherData.Ave - GatherData.Lo;

PlotData.Ave = [GatherData.Ave EPAData];

figure(1)

subplot(2,2,[1 3])

    GatherData.Tot1 = ...
        [sum(GatherData.Ave) - SuperemittersAve , SuperemittersAve];
    GatherData.Tot3 = 7.22;
    GatherData.Tot4 = 3.57;
    
    GatherData.SumTot = sum(GatherData.All,1);
    GatherData.Prc = prctile(GatherData.SumTot,[2.5 97.5],2);
    GatherData.TotHi = GatherData.Prc(2);
    GatherData.TotLo = GatherData.Prc(1);
     
    GatherData.TotHi = GatherData.TotHi - sum(GatherData.Ave);
    GatherData.TotLo = sum(GatherData.Ave) - GatherData.TotLo;
    
%     GatherData.TotHi = [GatherData.TotHi; 3.24];
%     GatherData.TotLo = [GatherData.TotLo; 2.63];

     GatherData.TotHi = GatherData.TotHi;
     GatherData.TotLo = GatherData.TotLo;

%     X = categorical({'Study','Omara','GHGI'});
%     X = reordercats(X,{'Study','Omara','GHGI'});
    
    b1 = bar([1;nan], [GatherData.Tot1; nan(1,2)],'stacked','BarWidth',0.5);
    
    b1(1).FaceColor = LightGrey;
    b1(2).FaceColor = StanfordRed;

    hold on
    
    b3 = bar(2, GatherData.Tot3,'BarWidth',0.5);
    b3.FaceColor = StanfordBlue;   
    
    b4 = bar(3, GatherData.Tot4,'BarWidth',0.5);
    b4.FaceColor = Sandstone;
    
    er = errorbar(1,sum(GatherData.Tot1,2), GatherData.TotLo, GatherData.TotHi);
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';   

    er = errorbar(2,sum(GatherData.Tot3,2), 1.6, 1.9);
    er.Color = [0 0 0];                            
    er.LineStyle = 'none'; 

    er = errorbar(3,sum(GatherData.Tot4,2), 0.67, 1.27);
    er.Color = [0 0 0];                            
    er.LineStyle = 'none'; 
    
    Labels = {'Study', 'Alvarez', 'GHGI'};
    set(gca, 'xtick',1:3, 'XTickLabel', Labels,'XTickLabelRotation',25); 
    set(gca,'FontSize',8)
    set(gca,'FontName','Arial')
    ylabel({'US 2015 CH_{4} from production-segment';'[Tg CH_{4}/yr]'});
    ylim([0 10])
    set(gca,'YMinorTick','on')
    set(gca, 'TickDir', 'out')
     box on
    axis_a = gca;
    % set box property to off and remove background color
    set(axis_a,'box','off','color','none')
    % create new, empty axes with box but without ticks
    axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
    % set original axes as active
    axes(axis_a)

% Full CDF
subplot(2,2,2)    

hold on

    for i = 1:n  

            study_data = sitedata_All_2(:,1,i)/24;

        if i == 1
            h = cdfplot(study_data);
            set( h, 'LineStyle', '-','LineWidth',0.4,'Color', StanfordRed,'DisplayName','This study');
            oplot = cdfplot(omara_data(:,2));
            set( oplot, 'LineStyle', '--','LineWidth',3,'Color', StanfordBlue,'DisplayName','Omara');
%             line([26 26],[0 1.1],'Color','k','LineStyle','--','DisplayName','26 kg/h');
            lgd = legend('show','location','NorthWest');
            lgd.FontSize = 8;
            set(0,'DefaultLegendAutoUpdate','off')
        else
            h = cdfplot(study_data);
            set( h, 'LineStyle', '-','LineWidth',0.4,'Color', StanfordRed);
        end
    end
    uistack(oplot,'top')
    set(gca,'xscale','log')
    grid off
    set(gca,'FontSize',8)
    set(gca,'XTick',[10^-3 10^-2 10^-1 10^0 10^1 10^2]);
    set(gca,'XTickLabel',{'10^{-3}', '10^{-2}', '10^{-1}', '10^{0}', '10^{1}', '10^{2}'});
    set(gca,'FontName','Arial')
    title('');
     xlabel('CH_{4} Emissions per site [kg/h, log scale]');
    ylabel('Cumulative density');

    xlim([0.0005 100])
    ylim([0 1.1])   
    set(gca,'XMinorTick','on','YMinorTick','on')
    set(gca, 'TickDir', 'out')
    box on
    axis_a = gca;
    % set box property to off and remove background color
    set(axis_a,'box','off','color','none')
    % create new, empty axes with box but without ticks
    axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
    % set original axes as active
    axes(axis_a)

% Full PDF
subplot(2,2,4)

hold on
    
    [~,edges] = histcounts(log10(omara_data(:,2)));
    histogram(omara_data(:,2),10.^edges,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',3,'EdgeColor',StanfordBlue);

    for i = 1:n

        study_data = sitedata_All_2(:,1,i)/24;
        study_data(study_data<=0) = NaN;
        ind = isnan(study_data);
        study_data(any(isnan(study_data),1),:) = [];
        sitedata_All_2_tr(any(isnan(study_data),1),:) = [];
        
        [~,edges] = histcounts(log10(study_data));
        histogram(study_data,10.^edges,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.4,'EdgeColor',StanfordRed);
        

    end
    
    [M, Prciles, Meen] = prcile_sub_v3(study_data, sitedata_All_2_tr);
    
    er = errorbar(Prciles.all(2),0.032, (Prciles.all(2) - Prciles.all(1)), (Prciles.all(3) - Prciles.all(2)),'horizontal');
            er.Color = StanfordRed;
            er.LineWidth = 1;
            set(get(get(er,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            hold on
            ln = plot(Prciles.all(2),0.032,'x');
            ln.MarkerEdgeColor = StanfordRed;
            ln.MarkerSize = 6;

            ln = plot(Meen.all,0.032,'s');
            ln.MarkerEdgeColor = StanfordRed;
            ln.MarkerFaceColor = StanfordRed;
            ln.MarkerSize = 6;    label = num2str(Meen.all,'%3.2f'); c = cellstr(label);
            
    dy = 0.005;
    text(double(Meen.all), 0.032+dy, c,'Color',StanfordRed, 'FontSize', 7, 'HorizontalAlignment', 'center');

    Prciles.omara = prctile(omara_data(:,2),[2.5 50 97.5]);
    Meen_omara = mean(omara_data(:,2));
    
	er = errorbar(Prciles.omara(2),0.042, (Prciles.omara(2) - Prciles.omara(1)), (Prciles.omara(3) - Prciles.omara(2)),'horizontal');
        er.Color = StanfordBlue;
        er.LineWidth = 1;
        set(get(get(er,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        hold on
        ln = plot(Prciles.omara(2),0.042,'x');
        ln.MarkerEdgeColor = StanfordBlue;
        ln.MarkerSize = 6;
        
        ln = plot(Meen_omara,0.042,'s');
        ln.MarkerEdgeColor = StanfordBlue;
        ln.MarkerFaceColor = StanfordBlue;
        ln.MarkerSize = 6;        
        
        label = num2str(Meen_omara,'%3.2f'); c = cellstr(label);
        dy = 0.005;
        text(Meen_omara, 0.042+dy, c,'Color',StanfordBlue, 'FontSize', 7, 'HorizontalAlignment', 'center');

    
    ylim([0 0.05]) 
    set(gca,'xscale','log')
    set(gca,'FontSize',8)
    set(gca,'XTick',[10^-3 10^-2 10^-1 10^0 10^1 10^2]);
    set(gca,'XTickLabel',{'10^{-3}', '10^{-2}', '10^{-1}', '10^{0}', '10^{1}', '10^{2}'});
    xlabel('CH_{4} Emissions per site [kg/h, log scale]');
    ylabel('Probability density');
    set(gca,'FontName','Arial')
    xlim([0.0005 100])
    
    ax = gca;
    ax.YAxis(1).Color = 'k';
    set(gca,'XMinorTick','on','YMinorTick','on')
    set(gca, 'TickDir', 'out')
    box on
    axis_a = gca;
    % set box property to off and remove background color
    set(axis_a,'box','off','color','none')
    % create new, empty axes with box but without ticks
    axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
    % set original axes as active
    axes(axis_a)
 
%       set(figure(1),'PaperUnits','inches','PaperPosition',[0 0 10 7.5])
%       figure('Renderer', 'Painters')
%       saveas(figure(1),'Fig_1.emf','meta');

      print('-painters','-dmeta','Fig_main1.emf');
      
figure(2)
    h = histogram(sum(GatherData.All),'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',Sandstone);
    h.NumBins = 8;
    set(gca,'FontSize',20)
    set(gca,'FontName','Arial')
    ylim([0 0.5])
    xlim([4 9])
    xlabel('Emissions [Tg CH_{4}/yr]');
%     ylabel('Freq.');
    set(gca,'YMinorTick','on')
    set(gca, 'TickDir', 'out')
    axis_a = gca;
    % set box property to off and remove background color
    set(axis_a,'box','off','color','none')
    % create new, empty axes with box but without ticks
    axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
    % set original axes as active
    axes(axis_a)
    pbaspect(axis_a, [1 1 1])
   pbaspect(axis_b, [1 1 1])
   
%       set(figure(2),'PaperUnits','inches','PaperPosition',[0 0 10 7.5])
%       figure('Renderer', 'Painters')
%       saveas(figure(2),'Fig_2.emf','meta');
      print('-painters','-dmeta','Fig_main2.emf');    
   
figure(3)
    
    b = bar(1:7,PlotData.Ave);
    hold on
    er = errorbar(0.86:1:6.86,GatherData.Ave, GatherData.Lo, GatherData.Hi);
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';  
    
    b(1).FaceColor = StanfordRed;
    b(2).FaceColor = Sandstone;
    xtickangle(25);

    legend(b, {'This study','GHGI'}, 'Location','Best','FontSize',8);
    
    xlim([0.5 7.5]);    
    Labels = {'Tanks','Equipment Leaks','Pneumatic Devices','Liquids Unloadings','Completions & Workovers','Methane slip','Flare methane'};
    set(gca, 'xtick',1:7, 'XTickLabel', Labels,'XTickLabelRotation',25); 
    
    set(gca,'FontSize',8)
    set(gca,'FontName','Arial')
    ylim([0 3.25])

    ylabel('Emissions [Tg CH_{4}/yr]');
    set(gca,'YMinorTick','on')
    set(gca, 'TickDir', 'out')
    axis_a = gca;
    % set box property to off and remove background color
    set(axis_a,'box','off','color','none')
    % create new, empty axes with box but without ticks
    axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
    % set original axes as active
    axes(axis_a)
   
%       set(figure(3),'PaperUnits','inches','PaperPosition',[0 0 10 7.5])
%       figure('Renderer', 'Painters')
%       saveas(figure(3),'Fig_3.emf','meta');
      print('-painters','-dmeta','Fig_main3.emf');
      
figure(4)
hold on
    for i = 1:n  

            study_data = sitedata_All_2(:,1,i)/24;

        if i == 1
            h = cdfplot(study_data);
            set( h, 'LineStyle', '-','LineWidth',0.4,'Color', StanfordRed,'DisplayName','Study');
            oplot = cdfplot(omara_data(:,2));
            set( oplot, 'LineStyle', '--','LineWidth',3,'Color', StanfordBlue,'DisplayName','Omara');
%             line([26 26],[0 1.1],'Color','k','LineStyle','--','DisplayName','26 kg/h');
            lgd = legend('show','location','NorthWest');
            lgd.FontSize = 8;
            set(0,'DefaultLegendAutoUpdate','off')
        else
            h = cdfplot(study_data);
            set( h, 'LineStyle', '-','LineWidth',0.4,'Color', StanfordRed);
        end
    end

uistack(oplot,'top')
    grid off
    set(gca,'xscale','log')
    set(gca,'FontSize',8)
    set(gca,'XTick',[10^0 10^1]);
    set(gca,'XTickLabel',{'10^{0}', '10^{1}'});
    xlabel('CH_{4} Emissions [kg/h, log scale]');
    ylabel('Probability');
    set(gca,'FontName','Arial')
    xlim([1 100])
    ylim([0.95 1.01])
    title('');
    
% Full PDF
figure(5)

hold on
    
    for i = 1:n

            study_data = sitedata_All_2(:,1,i)/24;
            study_data(study_data<=0) = NaN;
            ind = isnan(study_data);
            study_data(any(isnan(study_data),1),:) = [];
            [M, Prciles, Meen] = prcile_sub_v3(study_data, sitedata_All_2_tr);

            yyaxis left

            [~,edges] = histcounts(log10(M.drygas));
            histogram(M.drygas,10.^edges,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.2,'EdgeColor',StanfordRed);

            [~,edges] = histcounts(log10(M.gaswoil));
            histogram(M.gaswoil,10.^edges,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.2,'EdgeColor',Sandstone);

            yyaxis right
            
             [~,edges] = histcounts(log10(M.oilwgas));
             histogram(M.oilwgas,10.^edges,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.2,'EdgeColor',LightGrey);

     
    end
    
    ylim([0 0.21])
    yyaxis left 
    
    er = errorbar(Prciles.drygas(2),0.06, (Prciles.drygas(2) - Prciles.drygas(1)), (Prciles.drygas(3) - Prciles.drygas(2)),'horizontal');
            er.Color = StanfordRed;
            er.LineWidth = 1;
            set(get(get(er,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            hold on
            ln = plot(Prciles.drygas(2),0.06,'x');
            ln.MarkerEdgeColor = StanfordRed;
            ln.MarkerSize = 6;

            ln_s(3) = plot(Meen.drygas,0.06,'s','DisplayName','Gas Only');
            ln_s(3).MarkerEdgeColor = StanfordRed;
            ln_s(3).MarkerFaceColor = StanfordRed;
            ln_s(3).MarkerSize = 6;    label = num2str(Meen.drygas,'%3.2f'); c = cellstr(label);
            
    dy = 0.003;
    text(double(Meen.drygas), 0.06+dy, c,'Color',StanfordRed, 'FontSize', 7, 'HorizontalAlignment', 'center');

	er = errorbar(Prciles.gaswoil(2),0.066, (Prciles.gaswoil(2) - Prciles.gaswoil(1)), (Prciles.gaswoil(3) - Prciles.gaswoil(2)),'horizontal');
            er.Color = Sandstone;
            er.LineWidth = 1;
            set(get(get(er,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            hold on
            ln = plot(Prciles.gaswoil(2),0.066,'x');
            ln.MarkerEdgeColor = Sandstone;
            ln.MarkerSize = 6;

            ln_s(2) = plot(Meen.gaswoil,0.066,'s','DisplayName','Gas + Oil');
            ln_s(2).MarkerEdgeColor = Sandstone;
            ln_s(2).MarkerFaceColor = Sandstone;
            ln_s(2).MarkerSize = 6;    label = num2str(Meen.gaswoil,'%3.2f'); c = cellstr(label);
            
        dy = 0.003;
        text(double(Meen.gaswoil), 0.066+dy, c,'Color',Sandstone, 'FontSize', 7, 'HorizontalAlignment', 'center');

	er = errorbar(Prciles.oilwgas(2),0.072, (Prciles.oilwgas(2) - Prciles.oilwgas(1)), (Prciles.oilwgas(3) - Prciles.oilwgas(2)),'horizontal');
            er.Color = LightGrey;
            er.LineWidth = 1;
            set(get(get(er,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            hold on
            ln = plot(Prciles.oilwgas(2),0.072,'x');
            ln.MarkerEdgeColor = LightGrey;
            ln.MarkerSize = 6;

            ln_s(1) = plot(Meen.oilwgas,0.072,'s','DisplayName','Oil + Gas');
            ln_s(1).MarkerEdgeColor = LightGrey;
            ln_s(1).MarkerFaceColor = LightGrey;
            ln_s(1).MarkerSize = 6;    label = num2str(Meen.oilwgas,'%3.2f'); c = cellstr(label);
           
        dy = 0.003;
        text(double(Meen.oilwgas), 0.072+dy, c,'Color',LightGrey, 'FontSize', 7, 'HorizontalAlignment', 'center');


    lgd = legend(ln_s,'location','NorthWest');
    lgd.FontSize = 8;
    set(0,'DefaultLegendAutoUpdate','off')
            
    ylim([0 0.09]) 
    set(gca,'xscale','log')
    set(gca,'FontSize',8)
    set(gca,'XTick',[10^-4 10^-2 10^0 10^2]);
    set(gca,'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}'});
    xlabel('CH_{4} Emissions [kg/h, log scale]');
    ylabel('Probability');
    set(gca,'FontName','Arial')
    xlim([0.0001 1000])
    
    ax = gca;
    ax.YAxis(1).Color = 'k';
    ax.YAxis(2).Color = 'k';
    set(gca,'XMinorTick','on','YMinorTick','on')
    set(gca, 'TickDir', 'out')
    axis_a = gca;
    % set box property to off and remove background color
    set(axis_a,'box','off','color','none')
    % create new, empty axes with box but without ticks
    axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
    % set original axes as active
    axes(axis_a)
    
%% Plotting Omara Figure

figure(6)
hold on

% Plot Omara data points 
omara_data = importdata('Omara_data.csv');

h = scatter(omara_data(:,1),omara_data(:,2),12,'MarkerEdgeColor',Sandstone,'DisplayName','Omara Data');
%     h.MarkerFaceAlpha = 0.5;
    
% Omara quadratic fit
    C1 = 0.072;
    C2 = -1.1;
    C3 = 1.96;

% Best fit of my data
for i = 1:n

    study_data = sitedata_All_2(:,:,i);

    study_omara = study_data(:,3);
    study_omara_x = study_data(:,2);
    study_all = [study_omara_x, study_omara];
    ind = (study_omara == 0);
    study_all = study_all(~ind,:);
    
    x_fit = linspace(0.1,100000,100000);       
    Y = log10(study_all(:,2));
    X = [log10(study_all(:,1)), log10(study_all(:,1)).^2];
    fit = robustfit(X,Y);
    B1 = fit(3);
    B2 = fit(2);
    B3 = fit(1);
    YBL = 10.^(B1.*log10(x_fit).^2 + B2.*log10(x_fit) + B3);
    if i == 1
        loglog(x_fit,YBL,'-.','Color',StanfordRed,'LineWidth',0.2,'DisplayName','Data - best fit');
        y_fit2 = 10.^(C1.*log10(x_fit).^2 + C2.*log10(x_fit) + C3);
        y_fit2 = y_fit2/100;
        oplot = loglog(x_fit,y_fit2,'--','Color',StanfordBlue,'LineWidth',3,'DisplayName','Omara - quad');
        legend('show','location','SouthWest');
        set(0,'DefaultLegendAutoUpdate','off')
    else
        loglog(x_fit,YBL,'-.','Color',StanfordRed,'LineWidth',0.2);
    end
    
end
uistack(oplot,'top')
ylim([0.00001 2])
xlim([0.1 100000])
xlabel('Wellpad throughput [mscf/d, log scale]');
ylabel('Prod. normalized CH_{4} [log scale]');

yticks([0.0001 0.001 0.01 0.1 1])
yticklabels({'10^{-4}','10^{-3}','10^{-2}','10^{-1}','10^{0}'})
xticks([0.1 1 10 100 1000 10000 100000])
xticklabels({'10^{-1}','10^{0}','10^{1}','10^{2}','10^{3}','10^{4}','10^{5}'})

set(gca,'FontSize',8) 
set(gca, 'XScale', 'log', 'YScale', 'log');
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca, 'TickDir', 'out')
axis_a = gca;
% set box property to off and remove background color
set(axis_a,'box','off','color','none')
% create new, empty axes with box but without ticks
axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
% set original axes as active
axes(axis_a)

for i = 2:100

         totals_vec(i - 1) = GatherData.SumTot(i);
         
         mu_total(i) = mean(totals_vec);
         std_total(i) = std(totals_vec);
         
         abs_err(i) = (1.645*std_total(i))/sqrt(i);
end

figure(7)
subplot(1,2,1)
hold on
plot(mu_total,'Color',StanfordRed,'LineWidth',2);

x = 1:99;
scatter(x,totals_vec,10, 'k');

xlabel('Monte Carlo Realizations');
ylabel({'\mu_{CH_{4}} [Tg CH_{4}/yr]'});
set(gca,'FontSize',10)
set(gca,'FontName','Arial')
ylim([4 9]);

subplot(1,2,2)
hold on
plot(abs_err,'Color',StanfordRed,'LineWidth',2);

xlabel('Monte Carlo Realizations');
ylabel({'90% confidence interval for','\mu_{CH_{4}} [Tg CH_{4}/yr]'});
set(gca,'FontSize',10)
set(gca,'FontName','Arial')

 data_shuffle = datasample(GatherData.SumTot,100,'Replace',false);
%  
%  for i = 2:100
% 
%          totals_vec2(i - 1) = data_shuffle(i);
%          
%          mu_total2(i) = mean(totals_vec2);
%          std_total2(i) = std(totals_vec2);
%          
%          abs_err2(i) = (1.645*std_total2(i))/sqrt(i);
% end
% 
% figure(9)
% hold on
%  
% plot(mu_total2);
% 
% xlabel('n');
% ylabel({'US 2015 CH_{4} [Tg CH_{4}/yr]'});
% legend('show','location','NorthEast');
% 
% set(gca,'FontSize',12)
% set(gca,'FontName','Arial')
% 
% figure(10)
% hold on
% plot(abs_err2);
% 
% xlabel('n');
% ylabel({'US 2015 CH_{4} [Tg CH_{4}/yr]'});
% set(gca,'FontSize',12)
% set(gca,'FontName','Arial')
