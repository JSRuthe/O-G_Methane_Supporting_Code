function Leakage_Plotting(StudyHi,EPA_Comp,i, z)

%% Load data

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

	% Study fraction leaking

		data=importdata('FractionLeaking.csv');
        FL.LL_500 = data(3,:);                  
        FL.UL_500 = data(4,:);
        FL.LL_10k = data(1,:);
        FL.UL_10k = data(2,:);
		temp = cat(1,FL.LL_500, FL.UL_500);
		FL.ave_500 = mean(temp);
		temp = cat(1,FL.LL_10k, FL.UL_10k);
		FL.ave_10k = mean(temp);		

	% Study component counts
	
		data=importdata('Counts_Lower_Oil.csv');
		CQ.LLoil = data;
		data=importdata('Counts_Upper_Oil.csv');
		CQ.ULoil = data;
        
        temp = cat(3,CQ.LLoil,CQ.ULoil);
        CQ.AveOil = mean(temp,3);
        
		data=importdata('Counts_Lower_Gas.csv');
		CQ.LLgas = data;
		data=importdata('Counts_Upper_Gas.csv');
		CQ.ULgas = data;

        temp = cat(3,CQ.LLgas,CQ.ULgas);
        CQ.AveGas = mean(temp,3);
        
	% Study equipment data

    
        load 'Equipvecs_Set21';
        EF_Ave = importdata('EFS_ave_set21.csv');
        
        if z == 1
            x = {'Oil wells'};
        elseif z == 2
            x = {'Oil separator'};
        else
            x = {'Oil meter'};
        end
        
        if z == 1
            x = {'Oil wells'};
        elseif z == 2
            x = {'Oil separator'};
        else
            x = {'Oil meter'};
        end


%% Load figure

figure(i)

ha = tight_subplot(1,4,0.01,[.2 .03],[.08 .02]);

%% Leaker Values

axes(ha(1));

	for j = 1:3
		plot_color = StanfordRed;
        if j == 1
            LeakerHi = StudyHi.TC;
            leaker = EPA_Comp.Conn(i,1);
        elseif j == 2
            LeakerHi = StudyHi.VL;
            leaker = EPA_Comp.Valve(i,1);
        else
            LeakerHi = StudyHi.OEL;
            leaker = EPA_Comp.OEL(i,1);
        end

		Prciles = prctile(LeakerHi,[2.5 50 97.5]);
		Hi = Prciles(:,3);
		Med = Prciles(:,2);
		Lo = Prciles(:,1);
		Hi = Hi - Med;
		Lo = Med - Lo;
		Meen = mean(LeakerHi);
		
		er = errorbar(j - 0.25,Med, Lo, Hi);
        hold on
		er.Color = plot_color;
		er.LineWidth = 1;
        ln = plot(j - 0.25,Meen,'s');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
           
%         dy = 1.5;
%         label = num2str(Meen,'%3.2f'); c = cellstr(label);
%         text(j, double(Meen)*dy, c,'Color',plot_color,'FontSize', 6, 'HorizontalAlignment', 'center');
%         
        ln = plot(j + 0.25,leaker,'^');
        ln.MarkerEdgeColor = 'k';
        ln.MarkerFaceColor = 'k';
        ln.MarkerSize = 6;
       
%         dy = 1.5;
%         label = num2str(leaker,'%3.2f'); c = cellstr(label);
%         text(j + 0.5, double(leaker)*dy, c,'Color','k', 'FontSize', 6, 'HorizontalAlignment', 'center');
%             
    end
   

     set(gca,'yscale','log')
    ylim([0.0005 500]);
    x = {'Connector','Valve', 'Open-ended line'}; 
    set(gca,'XTick',1:3,'XTickLabel',x,'XTickLabelRotation',25);
%     h=gca; h.XAxis.TickLength = [0 0];
    xlim([0.5 3.5]);
    set(gca,'FontSize',10)
    set(gca,'FontName','Arial')

     set(gca,'YTick',[10^-2 10^-1 10^0 10^1 10^2]);
     set(gca,'YTickLabel',{'0.01', '0.1', '1','10', '100'});
    set(gca,'YMinorTick','on')
    set(gca, 'TickDir', 'out')
    
%% Fraction leaking
    
axes(ha(2));

	for j = 1:3
	  	plot_color = StanfordRed;	
        if j == 1
            FL_EPA = EPA_Comp.Conn(i,2)*100;
%             plot_color = 'k';
        elseif j == 2
            FL_EPA = EPA_Comp.Valve(i,2)*100;
%             plot_color = Sandstone;
        else
            FL_EPA = EPA_Comp.OEL(i,2)*100;
%             plot_color = StanfordDGreen;
        end

		Hi = FL.UL_10k(j)*100;
		Med = FL.ave_10k(j)*100;
		Lo = FL.LL_10k(j)*100;
		Hi = Hi - Med;
		Lo = Med - Lo;
		
		er = errorbar(j - 0.25,Med, Lo, Hi);
        hold on
		er.Color = plot_color;
		er.LineWidth = 1;
        ln = plot(j - 0.25,Med,'s');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
        ln.MarkerSize = 6;
           
%         dy = 1.25;
%         label = num2str(Med,'%2.1f'); c = cellstr(label);
%         text(j, double(Med)*dy, c,'Color',plot_color,'FontSize', 6, 'HorizontalAlignment', 'center');

        ln = plot(j + 0.25,FL_EPA,'^');
        ln.MarkerEdgeColor = 'k';
        ln.MarkerFaceColor = 'k';
        ln.MarkerSize = 6;
        
%         dy = 1.25;
%         label = num2str(FL_EPA,'%2.1f'); c = cellstr(label);
%         text(j + 0.5, double(FL_EPA)*dy, c,'Color','k', 'FontSize', 6, 'HorizontalAlignment', 'center');
%         
    end
    
     set(gca,'yscale','log')
    ylim([0.0005 500]);
    x = {'Connector','Valve', 'Open-ended line'}; 
    set(gca,'XTick',1:3,'XTickLabel',x,'XTickLabelRotation',25);
%     h=gca; h.XAxis.TickLength = [0 0];
    xlim([0.5 3.5]);
    set(gca,'FontSize',10)
    set(gca,'FontName','Arial')

%      set(gca,'YTick',[10^-3 10^-2 10^-1]);
%      set(gca,'YTickLabel',{'10^{-3}', '10^{-2}','10^{-1}'});
    set(gca,'YMinorTick','on')
    set(gca,'yticklabel',{[]})
    
%% Component counts
    
axes(ha(3));

	for j = 1:3
        plot_color = StanfordRed;  
        if j == 1
            CQ_EPA = EPA_Comp.Conn(i,z+2);
        elseif j == 2
            CQ_EPA = EPA_Comp.Valve(i,z+2);
        else
            CQ_EPA = EPA_Comp.OEL(i,z+2);
        end
        
        if i < 3
            Hi = CQ.ULgas(z,j);
            Lo = CQ.LLgas(z,j);
            Med = CQ.AveGas(z,j);
            Hi = Hi - Med;
            Lo = Med - Lo;
        else
            Hi = CQ.ULoil(z,j);
            Lo = CQ.LLoil(z,j);
            Med = CQ.AveOil(z,j);
            Hi = Hi - Med;
            Lo = Med - Lo;            
        end    
            
		er = errorbar(j - 0.25,Med, Lo, Hi);
        hold on
		er.Color = plot_color;
		er.LineWidth = 1;
        ln = plot(j - 0.25,Med,'s');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
        ln.MarkerSize = 6;
           
%         dy = 1.25;
%         label = num2str(Med,'%3.0f'); c = cellstr(label);
%         text(j - 0.05, double(Med)*dy, c,'Color',plot_color,'FontSize', 6, 'HorizontalAlignment', 'center');

        ln = plot(j + 0.25,CQ_EPA,'^');
        ln.MarkerEdgeColor = 'k';
        ln.MarkerFaceColor = 'k';
        ln.MarkerSize = 6;
        
%         dy = 1.25;
%         label = num2str(CQ_EPA,'%3.0f'); c = cellstr(label);
%         text(j + 0.45, double(CQ_EPA)*dy, c,'Color','k', 'FontSize', 6, 'HorizontalAlignment', 'center');

    end
    
    set(gca,'yscale','log')
    ylim([0.0005 500]);
    x = {'Connector','Valve', 'Open-ended line'}; 
    set(gca,'XTick',1:3,'XTickLabel',x,'XTickLabelRotation',25);
%     h=gca; h.XAxis.TickLength = [0 0];
    xlim([0.5 3.5]);
    set(gca,'FontSize',10)
    set(gca,'FontName','Arial')

%     set(gca,'YTick',[10^-2 10^2]);
%     set(gca,'YTickLabel',{'10^{0}','10^{2}'});
    set(gca,'YMinorTick','on')
    set(gca,'yticklabel',{[]})

%% Equipment emissions factors

axes(ha(4));

% Wellhead
    
    EF_EPA = EPA_Comp.Conn(i,z+5);
    
    if i < 3
        
        if z == 1
            equip_tot = study_well.gas;
            Average_EF = EF_Ave(1,4);
            x = {'Gas wellhead'};
        elseif z == 2
            equip_tot = study_sep.gas;
            Average_EF = EF_Ave(4,4);
            x = {'Gas separator'};
        else
            equip_tot = study_meter.gas;
            Average_EF = EF_Ave(5,4);
            x = {'Gas meter'};
        end
        
        equip_tot(equip_tot == 0) = [];
        equip_tot(any(isnan(equip_tot),2),:) = [];
        Prciles_tot = prctile(equip_tot,[2.5 50 97.5]);
        
    else
        
        if z == 1
            equip_tot = study_well.oil;
            Average_EF = EF_Ave(1,8);
            x = {'Oil wellhead'};
        elseif z == 2
            equip_tot = study_sep.oil;
            Average_EF = EF_Ave(4,8);
            x = {'Oil separator'};
        else
            equip_tot = study_meter.oil;
            Average_EF = EF_Ave(5,8);
            x = {'Oil meter'};
        end

        equip_tot(equip_tot == 0) = [];
        equip_tot(any(isnan(equip_tot),2),:) = [];
        Prciles_tot = prctile(equip_tot,[2.5 50 97.5]);
        
    end

    Hi = Prciles_tot(:,3);
    Med = Prciles_tot(:,2);
    Lo = Prciles_tot(:,1);
    Hi = Hi - Med;
    Lo = Med - Lo;
    Meen = mean(equip_tot);
    
    er = errorbar(1 - 0.25,Med, Lo, Hi);
    hold on
    er.Color = StanfordRed;
    er.LineWidth = 1;
    ln = plot(1 - 0.25,Meen,'s');
    ln.MarkerEdgeColor = StanfordRed;
    ln.MarkerFaceColor = StanfordRed;
    
%     dy = 1.75;
%     label = num2str(Average_EF,'%3.2f'); c = cellstr(label);
%     text(1 - 0.15, double(Meen)*dy, c,'Color',plot_color,'FontSize', 6, 'HorizontalAlignment', 'center');
%     
    ln = plot(1 + 0.25,EF_EPA,'^');
    ln.MarkerEdgeColor = 'k';
    ln.MarkerFaceColor = 'k';
    ln.MarkerSize = 6;    
    
%     dy = 1.75;
%     label = num2str(EF_EPA,'%3.2f'); c = cellstr(label);
%     text(1 + 0.35, double(EF_EPA)*dy, c,'Color','k', 'FontSize', 6, 'HorizontalAlignment', 'center');
%     
     set(gca,'yscale','log')
        
    ylim([0.0005 500]);
     
    set(gca,'XTick',1,'XTickLabel',x,'XTickLabelRotation',25);
%     h=gca; h.XAxis.TickLength = [0 0];
    xlim([0.4 1.6]);
    set(gca,'FontSize',10)
    set(gca,'FontName','Arial')
    
%      set(gca,'YTick',[10^-2 10^0 10^2]);
%      set(gca,'YTickLabel',{'10^{-2}', '10^{0}','10^{2}'});
    set(gca,'YMinorTick','on')
    set(gca,'yticklabel',{[]})


end
