function Tanks_Plots(gasvec, oilvec)


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
BrightRed = [177/255, 4/255, 14/255];

    % Load data - this study

    % Gas, tank vents + flashing

        study_vent.gas = gasvec(:,7);
        study_flash.gas = gasvec(:,15);
        study_vent.gas(any(isnan(study_vent.gas),2),:) = [];
        study_flash.gas(any(isnan(study_flash.gas),2),:) = [];
        
        % We are comparing population factors (including the contribution
        % of "zero" flash events in our plot against EPA, therefore we need
        % to multiply the flash vector by the "multiplier" from above,
        % which is basically a fraction emitting value
        %
        % study_flash.gas [kg/emitting tank]
        % multiplier [emitting tank/tank]
        % frac_uncontrolled [uncontrolled tank/tank]
        %
        % Becuase the multiplier already inlcudes the effect of control, we
        % need to back-calculate this out (since we'll be multiplying by it
        % again in the dashboard
        
        control_rate_flash.gas = 0.44;        
        study_flash.gas = study_flash.gas .* (multiplier(15,4)/(1 - control_rate_flash.gas));
        
        % However, for thief hatch venting, [kg/emitting tank] is the value
        % we want in the dashboard. Therefore, no need to multiply
        
        frac_loss_vent.gas = multiplier(7,4);
        
    % Oil, tank vents + flashing

        study_vent.oil = oilvec(:,7);
        study_flash.oil = oilvec(:,15);
        study_vent.oil(any(isnan(study_vent.oil),2),:) = [];
        study_flash.oil(any(isnan(study_flash.oil),2),:) = [];
 
        control_rate_flash.oil = 0.44;
        study_flash.oil = study_flash.oil .* (multiplier(15,8)/(1 - control_rate_flash.oil));

        frac_loss_vent.oil = multiplier(7,8);
        
% Load data - EPA

    x_divide = 0;

    load('GHGRP_LgTanks_v4.mat')
      ind = OG == "Gas";

        N_TK_Lg_Gas = N_TK_Lg(ind,1);
        N_DUMP_Gas = N_DUMP(ind,1);
        TB_VENT_lg.Gas = TB_VENT(ind,1);
        TB_VENT_lg.Gas = Tank_Mat_Extend_v2(TB_VENT_lg.Gas, N_TK_Lg_Gas, x_divide);
        
        TB_FLARE1.Gas = TB_FLARE(ind,1);
        TB_FLARE_lg.Gas = Tank_Mat_Extend_v2(TB_FLARE1.Gas, N_TK_Lg_Gas, x_divide);         
        TB_VRU1.Gas = TB_VRU(ind,1);
        TB_VRU_lg.Gas = Tank_Mat_Extend_v2(TB_VRU1.Gas, N_TK_Lg_Gas, x_divide);         

        TB_DUMP1.Gas = TB_DUMP(ind,1);     
        EPA_Dump.Gas = Tank_Mat_Extend_v2(TB_DUMP1.Gas, N_DUMP_Gas, x_divide);   
 
        N_TK_Lg_Oil = N_TK_Lg(~ind,1); 
        N_DUMP_Oil = N_DUMP(~ind,1);
        TB_VENT_lg.Oil = TB_VENT(~ind,1);
        TB_VENT_lg.Oil = Tank_Mat_Extend_v2(TB_VENT_lg.Oil, N_TK_Lg_Oil, x_divide);        
        
        TB_FLARE1.Oil = TB_FLARE(~ind,1);
        TB_FLARE_lg.Oil = Tank_Mat_Extend_v2(TB_FLARE1.Oil, N_TK_Lg_Oil, x_divide);         
        TB_VRU1.Oil = TB_VRU(~ind,1);
        TB_VRU_lg.Oil = Tank_Mat_Extend_v2(TB_VRU1.Oil, N_TK_Lg_Oil, x_divide);         

        TB_DUMP1.Oil = TB_DUMP(~ind,1);
        EPA_Dump.Oil = Tank_Mat_Extend_v2(TB_DUMP1.Oil, N_DUMP_Oil, x_divide);   
            
    load('GHGRP_SmTanks_v2.mat')
      ind = OG == "Gas";

        N_TK_Sm_Gas = N_TK_Sm(ind,1);
        TB_VENT_sm.Gas = TB_SMALL_VENT(ind,1);
        TB_VENT_sm.Gas = Tank_Mat_Extend_v2(TB_VENT_sm.Gas, N_TK_Sm_Gas, x_divide);

        TB_FLARE1.Gas = TB_SMALL_FLARE(ind,1);
        TB_FLARE_sm.Gas = Tank_Mat_Extend_v2(TB_FLARE1.Gas, N_TK_Sm_Gas, x_divide);        
        
        N_TK_Sm_Oil = N_TK_Sm(~ind,1);   
        TB_VENT_sm.Oil = TB_SMALL_VENT(~ind,1);
        TB_VENT_sm.Oil = Tank_Mat_Extend_v2(TB_VENT_sm.Oil, N_TK_Sm_Oil, x_divide);

        TB_FLARE1.Oil = TB_SMALL_FLARE(~ind,1);
        TB_FLARE_sm.Oil = Tank_Mat_Extend_v2(TB_FLARE1.Oil, N_TK_Sm_Oil, x_divide); 
        
% Combine
        
        EPA_Dump.Gas = EPA_Dump.Gas .* 1.775;
        EPA_Dump.Oil = EPA_Dump.Oil .* 0.48;
        EPA_VENT.Gas = vertcat(TB_VENT_lg.Gas, TB_VENT_sm.Gas);
        EPA_VENT.Oil = vertcat(TB_VENT_lg.Oil, TB_VENT_sm.Oil);
        
        EPA_Control.Gas = vertcat(TB_FLARE_lg.Gas, TB_VRU_lg.Gas, TB_FLARE_sm.Gas);
        EPA_Control.Oil = vertcat(TB_FLARE_lg.Oil, TB_VRU_lg.Oil, TB_FLARE_sm.Oil);
        
        EPA_control_rate_flash.oil = 0.56;
        EPA_frac_loss_vent.oil = 0.024;

        EPA_control_rate_flash.gas = 0.27;
        EPA_frac_loss_vent.gas = 0.0028;
%% Tank per well

load('tank_per_well_lg.mat')
ind = OG == "Gas";

x_divide = 1;

N_TANK_lg.Gas = N_TANK(ind,1);
N_WELL_lg.Gas = N_WELL(ind,1);
N_TANK_lg.Gas = Tank_Mat_Extend_v2(N_TANK_lg.Gas, N_WELL_lg.Gas, x_divide);

N_TANK_lg.Oil = N_TANK(~ind,1);
N_WELL_lg.Oil = N_WELL(~ind,1);
N_TANK_lg.Oil = Tank_Mat_Extend_v2(N_TANK_lg.Oil, N_WELL_lg.Oil, x_divide);
        
load('tank_per_well_sm.mat')
ind = OG == "Gas";

N_TANK_sm.Gas = N_TANK(ind,1);
N_WELL_sm.Gas = N_WELL(ind,1);
N_TANK_sm.Gas = Tank_Mat_Extend_v2(N_TANK_sm.Gas, N_WELL_sm.Gas, x_divide);

N_TANK_sm.Oil = N_TANK(~ind,1);
N_WELL_sm.Oil = N_WELL(~ind,1);
N_TANK_sm.Oil = Tank_Mat_Extend_v2(N_TANK_sm.Oil, N_WELL_sm.Oil, x_divide);

zero_tanks_count.Gas = 307737 - length(N_TANK_lg.Gas) - length(N_TANK_sm.Gas);
zero_tanks_count.Oil = 219433 - length(N_TANK_lg.Oil) - length(N_TANK_sm.Oil);

zero_tanks.Gas = zeros(zero_tanks_count.Gas,1);
zero_tanks.Oil = zeros(zero_tanks_count.Oil,1);

N_TANK_all.Gas = vertcat(N_TANK_lg.Gas, N_TANK_sm.Gas, zero_tanks.Gas);
N_TANK_all.Oil = vertcat(N_TANK_lg.Oil, N_TANK_sm.Oil, zero_tanks.Oil);

%(i) Determine bin indices and bin means
    edges_gas_set = [0, 0.001, 0.5, 1, 10000];
    [counts_gas, edges_gas, ind_gas] = histcounts(N_TANK_all.Gas, edges_gas_set);

    edges_oil_set = [0, 0.001, 0.5, 1, 10000];
    [counts_oil, edges_oil, ind_oil] = histcounts(N_TANK_all.Oil, edges_oil_set);
   
    
%(ii) Determine bin means
    bin_ave_gas = accumarray(ind_gas, N_TANK_all.Gas,[],@mean);
    bin_ave_oil = accumarray(ind_oil, N_TANK_all.Oil,[],@mean);
    
    x = 1;
    
%% PLOTTING

figure(1)

% Tank counts in the GHGRP are extrapolated as described in the spreadsheet
% "GHGRP Tanks Analysis"

N_TANK_all.Oil = sum(N_TANK_all.Oil)/0.384;
N_TANK_all.Gas = sum(N_TANK_all.Gas)/0.710;


ha = tight_subplot(1,4,0.08,[.2 .03],[.1 .02]);

% PANEL 1 - Activity

axes(ha(1));

b3 = bar(0.75, 428819,'BarWidth',0.1);
b3.FaceColor = StanfordRed;

dy = 20000;
c = num2str(428819);
text(0.75, double(428819)+dy, c,'Color','k', 'FontSize', 6, 'HorizontalAlignment', 'center');

hold on

b4 = bar(1.25, N_TANK_all.Oil,'BarWidth',0.1);
b4.FaceColor = 'k';

dy = 20000;
c = num2str(N_TANK_all.Oil,'%3.0f');
text(1.25, double(N_TANK_all.Oil)+dy, c,'Color',BrightRed, 'FontSize', 6, 'HorizontalAlignment', 'center');

        ylim([0 500000]);
        xlim([0 2]);
        x = {'Tank count'};
        set(gca,'XTick',1,'XTickLabel',x,'XTickLabelRotation',25);

        set(gca,'FontSize',10)
        set(gca,'FontName','Arial')
        
        set(gca,'YTick',[100000 300000 500000]);
        set(gca,'YTickLabel',{'100k', '300k', '500k'});
        set(gca,'YMinorTick','on')
        set(gca, 'TickDir', 'out')  

% PANEL 2 - FLASH EMISSIONS

axes(ha(2));

    % flash emissions

    plot_color = StanfordRed;
    
		Prciles = prctile(study_flash.oil,[2.5 50 97.5]);
		Hi = Prciles(:,3);
		Med = Prciles(:,2);
		Lo = Prciles(:,1);
        if Lo == 0
            Lo = min(study_flash.oil(study_flash.oil>0));
        end
		Hi = Hi - Med;
		Lo = Med - Lo;
		Meen = mean(study_flash.oil);
		
		er = errorbar(0.75,Med, Lo, Hi);
        hold on
		er.Color = plot_color;
		er.LineWidth = 1;
        ln = plot(0.75,Meen,'s');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
           
        dy = 8;
        label = num2str(Meen,'%3.2f'); c = cellstr(label);
        text(0.75, double(Meen)*dy, c,'Color','k','FontSize', 6, 'HorizontalAlignment', 'center');
        
    plot_color = 'k';        
    
		Prciles = prctile(EPA_VENT.Oil,[2.5 50 97.5]);
		Hi = Prciles(:,3);
		Med = Prciles(:,2);
		Lo = Prciles(:,1);
        if Lo == 0
            Lo = min(EPA_VENT.Oil(EPA_VENT.Oil>0));
        end
		Hi = Hi - Med;
		Lo = Med - Lo;
		Meen = mean(EPA_VENT.Oil);
		
		er = errorbar(1.25,Med, Lo, Hi);
        hold on
		er.Color = plot_color;
		er.LineWidth = 1;
        ln = plot(1.25,Meen,'s');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
           
        dy = 10;
        label = num2str(Meen,'%3.2f'); c = cellstr(label);
        text(1.25, double(Meen)*dy, c,'Color',BrightRed,'FontSize', 6, 'HorizontalAlignment', 'center');
       
% Flash Control rate

     plot_color = StanfordRed;   
     
        ln = plot(1.75,1 - control_rate_flash.oil,'^');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
        ln.MarkerSize = 6;
       
        dy = 2;
        label = num2str(1 - control_rate_flash.oil,'%3.2f'); c = num2str(1 - control_rate_flash.oil);
        text(1.75, double(1 - control_rate_flash.oil)*dy, c,'Color','k', 'FontSize', 6, 'HorizontalAlignment', 'center');

     plot_color = 'k';   
     
        ln = plot(2.25,1 - EPA_control_rate_flash.oil,'^');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
        ln.MarkerSize = 6;
       
        dy = 2;
        label = num2str(1 - EPA_control_rate_flash.oil,'%3.2f'); c = num2str(1 - EPA_control_rate_flash.oil);
        text(2.25, double(1 - EPA_control_rate_flash.oil)*dy, c,'Color',BrightRed, 'FontSize', 6, 'HorizontalAlignment', 'center');

        set(gca,'yscale','log')

        x = {'Emissions factor','Frac. uncontrolled'};
        set(gca,'XTick',1:2,'XTickLabel',x,'XTickLabelRotation',25);
        %     h=gca; h.XAxis.TickLength = [0 0];
        xlim([0.5 2.5]);

        ylim([0.0005 2000]);
        set(gca,'FontSize',10)
        set(gca,'FontName','Arial')
        
        set(gca,'YTick',[10^-2 10^-1 10^0 10^1 10^2 10^3]);
        set(gca,'YTickLabel',{'0.01', '0.1', '1', '10','100', '1000'});
        set(gca,'YMinorTick','on')
        set(gca, 'TickDir', 'out')
        
% PANEL 3 - VENT EMISSIONS

axes(ha(3));

    % vent emissions
     
    plot_color = StanfordRed;
    
		Prciles = prctile(study_vent.oil,[2.5 50 97.5]);
		Hi = Prciles(:,3);
		Med = Prciles(:,2);
		Lo = Prciles(:,1);
		Hi = Hi - Med;
		Lo = Med - Lo;
		Meen = mean(study_vent.oil);
		
		er = errorbar(0.75,Med, Lo, Hi);
        hold on
		er.Color = plot_color;
		er.LineWidth = 1;
        ln = plot(0.75,Meen,'s');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
           
        dy = 15;
        label = num2str(Meen,'%3.2f'); c = cellstr(label);
        text(0.75, double(Meen)*dy, c,'Color','k','FontSize', 6, 'HorizontalAlignment', 'center');
        
    plot_color = 'k';        
    
		Prciles = prctile(EPA_Dump.Oil,[2.5 50 97.5]);
		Hi = Prciles(:,3);
		Med = Prciles(:,2);
		Lo = Prciles(:,1);
        if Lo == 0
            Lo = min(EPA_Dump.Oil(EPA_Dump.Oil>0));
        end
		Hi = Hi - Med;
		Lo = Med - Lo;
		Meen = mean(EPA_Dump.Oil);
		
		er = errorbar(1.25,Med, Lo, Hi);
        hold on
		er.Color = plot_color;
		er.LineWidth = 1;
        ln = plot(1.25,Meen,'s');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
           
        dy = 20;
        label = num2str(Meen,'%3.2f'); c = cellstr(label);
        text(1.25, double(Meen)*dy, c,'Color',BrightRed,'FontSize', 6, 'HorizontalAlignment', 'center');
        
 % Fraction loss rate

     plot_color = StanfordRed;   
     
        Meen = frac_loss_vent.oil;
        ln = plot(1.75,Meen,'s');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
       
        dy = 2;
        c = num2str(Meen,'%3.2f');
        text(1.75, double(Meen)*dy, c,'Color','k', 'FontSize', 6, 'HorizontalAlignment', 'center');

     plot_color = 'k';   
     
        ln = plot(2.25,EPA_frac_loss_vent.oil,'^');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
        ln.MarkerSize = 6;
       
        dy = 2;
        c = num2str(EPA_frac_loss_vent.oil,'%3.2f');
        text(2.25, double(EPA_frac_loss_vent.oil)*dy, c,'Color',BrightRed, 'FontSize', 6, 'HorizontalAlignment', 'center');

        set(gca,'yscale','log')

        x = {'Emissions factor','Frac. emitting'};
        set(gca,'XTick',1:2,'XTickLabel',x,'XTickLabelRotation',25);
        %     h=gca; h.XAxis.TickLength = [0 0];
        xlim([0.5 2.5]);

        ylim([0.0005 2000]);
        set(gca,'FontSize',10)
        set(gca,'FontName','Arial')
        
        set(gca,'YTick',[10^-2 10^-1 10^0 10^1 10^2 10^3]);
        set(gca,'YTickLabel',{'0.01', '0.1', '1', '10','100', '1000'});
        set(gca,'YMinorTick','on')
        set(gca, 'TickDir', 'out')   


% PANEL 4 - Total emissions

axes(ha(4));

% Total Emissions Flash

Total_Emissions_study = 428819 * (1-control_rate_flash.oil) * mean(study_flash.oil);
Total_Emissions_study = Total_Emissions_study * (365/1000000);
Total_Emissions_EPA = N_TANK_all.Oil * (1-EPA_control_rate_flash.oil) * mean(EPA_VENT.Oil);
Total_Emissions_EPA = Total_Emissions_EPA * (365/1000000);

b1 = bar(0.75, Total_Emissions_study,'BarWidth',0.1);
b1.FaceColor = StanfordRed;


dy = 1.5;
label = num2str(Total_Emissions_study,'%3.1f'); c = cellstr(label);
text(0.75, double(Total_Emissions_study)*dy, c,'Color','k','FontSize', 6, 'HorizontalAlignment', 'center');

hold on

b2 = bar(1.25, Total_Emissions_EPA,'BarWidth',0.1);
b2.FaceColor = 'k';

dy = 1.5;
label = num2str(Total_Emissions_EPA,'%3.1f');  c = cellstr(label);
text(1.25, double(Total_Emissions_EPA)*dy, c,'Color',BrightRed,'FontSize', 6, 'HorizontalAlignment', 'center');

% Total Emissions Vent

Total_Emissions_study = 428819 * frac_loss_vent.oil * mean(study_vent.oil);
Total_Emissions_study = Total_Emissions_study * (365/1000000);
Total_Emissions_EPA = N_TANK_all.Oil * EPA_frac_loss_vent.oil * mean(EPA_Dump.Oil);
Total_Emissions_EPA = Total_Emissions_EPA * (365/1000000);

b3 = bar(1.75, Total_Emissions_study,'BarWidth',0.1);
b3.FaceColor = StanfordRed;

dy = 1.5;
label = num2str(Total_Emissions_study,'%3.1f');  c = cellstr(label);
text(1.75, double(Total_Emissions_study)*dy, c,'Color','k','FontSize', 6, 'HorizontalAlignment', 'center');

hold on

b4 = bar(2.25, Total_Emissions_EPA,'BarWidth',0.1);
b4.FaceColor = 'k';

dy = 1.5;
label = num2str(Total_Emissions_EPA,'%3.1f');  c = cellstr(label);
text(2.25, double(Total_Emissions_EPA)*dy, c,'Color',BrightRed,'FontSize', 6, 'HorizontalAlignment', 'center');

        xlim([0 3]);
        x = {'Flash emissions', 'Vent emissions'};
        set(gca,'XTick',1:2,'XTickLabel',x,'XTickLabelRotation',25);

        set(gca,'yscale','log')
        ylim([0.0005 2000]);
        set(gca,'FontSize',10)
        set(gca,'FontName','Arial')
        
        set(gca,'YTick',[10^-2 10^-1 10^0 10^1 10^2 10^3]);
        set(gca,'YTickLabel',{'0.01', '0.1', '1', '10','100', '1000'});
        set(gca,'YMinorTick','on')
        set(gca, 'TickDir', 'out')  
        
figure(2)

ha = tight_subplot(1,4,0.08,[.2 .03],[.1 .02]);

% PANEL 1 - Activity

axes(ha(1));

b3 = bar(0.75, 173106,'BarWidth',0.1);
b3.FaceColor = StanfordRed;

dy = 20000;
c = num2str(173106,'%3.0f');
text(0.75, double(173106)+dy, c,'Color','k', 'FontSize', 6, 'HorizontalAlignment', 'center');

hold on

b4 = bar(1.25, N_TANK_all.Gas,'BarWidth',0.1);
b4.FaceColor = 'k';

dy = 40000;
c = num2str(N_TANK_all.Gas,'%3.0f');
text(1.25, double(N_TANK_all.Gas)+dy, c,'Color',BrightRed, 'FontSize', 6, 'HorizontalAlignment', 'center');

        ylim([0 500000]);
        xlim([0 2]);
        x = {'Tank count'};
        set(gca,'XTick',1,'XTickLabel',x,'XTickLabelRotation',25);

        set(gca,'FontSize',10)
        set(gca,'FontName','Arial')
        
        set(gca,'YTick',[100000 300000 500000]);
        set(gca,'YTickLabel',{'100k', '300k', '500k'});
        set(gca,'YMinorTick','on')
        set(gca, 'TickDir', 'out')  

% PANEL 2 - FLASH EMISSIONS

axes(ha(2));

    % flash emissions

    plot_color = StanfordRed;
    
		Prciles = prctile(study_flash.gas,[2.5 50 97.5]);
		Hi = Prciles(:,3);
		Med = Prciles(:,2);
		Lo = Prciles(:,1);
		Hi = Hi - Med;
		Lo = Med - Lo;
		Meen = mean(study_flash.gas);
		
		er = errorbar(0.75,Med, Lo, Hi);
        hold on
		er.Color = plot_color;
		er.LineWidth = 1;
        ln = plot(0.75,Meen,'s');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
           
        dy = 5;
        label = num2str(Meen,'%3.2f'); c = cellstr(label);
        text(0.75, double(Meen)*dy, c,'Color','k','FontSize', 6, 'HorizontalAlignment', 'center');
        
    plot_color = 'k';        
    
		Prciles = prctile(EPA_VENT.Gas,[2.5 50 97.5]);
		Hi = Prciles(:,3);
		Med = Prciles(:,2);
		Lo = Prciles(:,1);
        if Lo == 0
            Lo = min(EPA_VENT.Gas(EPA_VENT.Gas>0));
        end
		Hi = Hi - Med;
		Lo = Med - Lo;
		Meen = mean(EPA_VENT.Gas);
		
		er = errorbar(1.25,Med, Lo, Hi);
        hold on
		er.Color = plot_color;
		er.LineWidth = 1;
        ln = plot(1.25,Meen,'s');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
           
        dy = 10;
        label = num2str(Meen,'%3.2f'); c = cellstr(label);
        text(1.25, double(Meen)*dy, c,'Color',BrightRed,'FontSize', 6, 'HorizontalAlignment', 'center');
       
% Flash Control rate

     plot_color = StanfordRed;   
     
        ln = plot(1.75,(1-control_rate_flash.gas),'^');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
        ln.MarkerSize = 6;
       
        dy = 2;
        label = num2str(1-control_rate_flash.gas,'%3.2f'); c = num2str(1-control_rate_flash.gas);
        text(1.75, double(1-control_rate_flash.gas)*dy, c,'Color','k', 'FontSize', 6, 'HorizontalAlignment', 'center');

     plot_color = 'k';   
     
        ln = plot(2.25,1-EPA_control_rate_flash.gas,'^');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
        ln.MarkerSize = 6;
       
        dy = 2;
        label = num2str(1-EPA_control_rate_flash.gas,'%3.2f'); c = num2str(1-EPA_control_rate_flash.gas);
        text(2.25, double(1-EPA_control_rate_flash.gas)*dy, c,'Color',BrightRed, 'FontSize', 6, 'HorizontalAlignment', 'center');

        set(gca,'yscale','log')

        x = {'Emissions factor','Non-control frac.'};
        set(gca,'XTick',1:2,'XTickLabel',x,'XTickLabelRotation',25);
        %     h=gca; h.XAxis.TickLength = [0 0];
        xlim([0.5 2.5]);

        ylim([0.0005 2000]);
        set(gca,'FontSize',10)
        set(gca,'FontName','Arial')
        
        set(gca,'YTick',[10^-2 10^-1 10^0 10^1 10^2 10^3]);
        set(gca,'YTickLabel',{'0.01', '0.1', '1', '10','100', '1000'});
        set(gca,'YMinorTick','on')
        set(gca, 'TickDir', 'out')
        
% PANEL 3 - VENT EMISSIONS

axes(ha(3));

    % vent emissions
     
    plot_color = StanfordRed;
    
		Prciles = prctile(study_vent.oil,[2.5 50 97.5]);
		Hi = Prciles(:,3);
		Med = Prciles(:,2);
		Lo = Prciles(:,1);
		Hi = Hi - Med;
		Lo = Med - Lo;
		Meen = mean(study_vent.gas);
		
		er = errorbar(0.75,Med, Lo, Hi);
        hold on
		er.Color = plot_color;
		er.LineWidth = 1;
        ln = plot(0.75,Meen,'s');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
           
        dy = 15;
        label = num2str(Meen,'%3.2f'); c = cellstr(label);
        text(0.75, double(Meen)*dy, c,'Color','k','FontSize', 6, 'HorizontalAlignment', 'center');
        
    plot_color = 'k';        
    
		Prciles = prctile(EPA_Dump.Gas,[2.5 50 97.5]);
		Hi = Prciles(:,3);
		Med = Prciles(:,2);
		Lo = Prciles(:,1);
        if Lo == 0
            Lo = min(EPA_Dump.Gas(EPA_Dump.Gas>0));
        end
		Hi = Hi - Med;
		Lo = Med - Lo;
		Meen = mean(EPA_Dump.Gas);
		
		er = errorbar(1.25,Med, Lo, Hi);
        hold on
		er.Color = plot_color;
		er.LineWidth = 1;
        ln = plot(1.25,Meen,'s');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
           
        dy = 20;
        label = num2str(Meen,'%3.2f'); c = cellstr(label);
        text(1.25, double(Meen)*dy, c,'Color',BrightRed,'FontSize', 6, 'HorizontalAlignment', 'center');
        
 % Fraction loss rate

     plot_color = StanfordRed;   
     
        Meen = frac_loss_vent.gas;
        ln = plot(1.75,Meen,'s');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
       
        dy = 2;
        c = num2str(Meen,'%3.2f');
        text(1.75, double(Meen)*dy, c,'Color','k', 'FontSize', 6, 'HorizontalAlignment', 'center');

     plot_color = 'k';   
     
        ln = plot(2.25,EPA_frac_loss_vent.gas,'^');
        ln.MarkerEdgeColor = plot_color;
        ln.MarkerFaceColor = plot_color;
        ln.MarkerSize = 6;
       
        dy = 2;
        c = num2str(EPA_frac_loss_vent.gas,'%3.3f');
        text(2.25, double(EPA_frac_loss_vent.gas)*dy, c,'Color',BrightRed, 'FontSize', 6, 'HorizontalAlignment', 'center');

        set(gca,'yscale','log')

        x = {'Emissions factor','Frac. emitting'};
        set(gca,'XTick',1:2,'XTickLabel',x,'XTickLabelRotation',25);
        %     h=gca; h.XAxis.TickLength = [0 0];
        xlim([0.5 2.5]);

        ylim([0.0005 2000]);
        set(gca,'FontSize',10)
        set(gca,'FontName','Arial')
        
        set(gca,'YTick',[10^-2 10^-1 10^0 10^1 10^2 10^3]);
        set(gca,'YTickLabel',{'0.01', '0.1', '1', '10','100', '1000'});
        set(gca,'YMinorTick','on')
        set(gca, 'TickDir', 'out')   


% PANEL 4 - Total emissions

axes(ha(4));

% Total Emissions Flash

Total_Emissions_study = 175106 * (1-control_rate_flash.gas) * mean(study_flash.gas);
Total_Emissions_study = Total_Emissions_study * (365/1000000);
Total_Emissions_EPA = N_TANK_all.Gas * (1-EPA_control_rate_flash.gas) * mean(EPA_VENT.Gas);
Total_Emissions_EPA = Total_Emissions_EPA * (365/1000000);

b1 = bar(0.75, Total_Emissions_study,'BarWidth',0.1);
b1.FaceColor = StanfordRed;


dy = 1.5;
label = num2str(Total_Emissions_study,'%3.1f'); c = cellstr(label);
text(0.75, double(Total_Emissions_study)*dy, c,'Color','k','FontSize', 6, 'HorizontalAlignment', 'center');

hold on

b2 = bar(1.25, Total_Emissions_EPA,'BarWidth',0.1);
b2.FaceColor = 'k';

dy = 1.5;
label = num2str(Total_Emissions_EPA,'%3.1f');  c = cellstr(label);
text(1.25, double(Total_Emissions_EPA)*dy, c,'Color',BrightRed,'FontSize', 6, 'HorizontalAlignment', 'center');

% Total Emissions Vent

Total_Emissions_study = 175106 * frac_loss_vent.gas * mean(study_vent.gas);
Total_Emissions_study = Total_Emissions_study * (365/1000000);
Total_Emissions_EPA = N_TANK_all.Gas * EPA_frac_loss_vent.gas * mean(EPA_Dump.Gas);
Total_Emissions_EPA = Total_Emissions_EPA * (365/1000000);

b3 = bar(1.75, Total_Emissions_study,'BarWidth',0.1);
b3.FaceColor = StanfordRed;

dy = 1.5;
label = num2str(Total_Emissions_study,'%3.1f');  c = cellstr(label);
text(1.75, double(Total_Emissions_study)*dy, c,'Color','k','FontSize', 6, 'HorizontalAlignment', 'center');

hold on

b4 = bar(2.25, Total_Emissions_EPA,'BarWidth',0.1);
b4.FaceColor = 'k';

dy = 1.5;
label = num2str(Total_Emissions_EPA,'%3.1f');  c = cellstr(label);
text(2.25, double(Total_Emissions_EPA)*dy, c,'Color',BrightRed,'FontSize', 6, 'HorizontalAlignment', 'center');

        xlim([0 3]);
        x = {'Flash emissions', 'Vent emissions'};
        set(gca,'XTick',1:2,'XTickLabel',x,'XTickLabelRotation',25);

        set(gca,'yscale','log')
        ylim([0.0005 2000]);
        set(gca,'FontSize',10)
        set(gca,'FontName','Arial')
        
        set(gca,'YTick',[10^-2 10^-1 10^0 10^1 10^2 10^3]);
        set(gca,'YTickLabel',{'0.01', '0.1', '1', '10','100', '1000'});
        set(gca,'YMinorTick','on')
        set(gca, 'TickDir', 'out')  

%% EPA Compare



figure(3)

t       = [];
counter = 1;
bottom = 0.58;
for jj = 1:2
    left = 0.1;
    
    for ii = 1:2
        t(counter) = axes('Position', [left, bottom, 0.4, 0.4], ...
            'NextPlot', 'add');
        left = left + 0.45;
        counter = counter + 1;
    end
    bottom = bottom - 0.45;
end


N = 65;
start = 10^-4;
stop = 10^4;
b = 10.^linspace(log10(start),log10(stop),N+1);

N = 20;
start = 10^-4;
stop = 10^4;
c = 10.^linspace(log10(start),log10(stop),N+1);


% Oil, tank vents

histogram(study_vent.oil,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.75,'EdgeColor',StanfordRed, 'Parent', t(1));
set(t(1),'YLim',[0 0.1])

% Oil, tank vents + flashing

vent = study_vent.oil;
flash = study_flash.oil;

plotvec = vertcat(vent,flash);

histogram(plotvec,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.75,'EdgeColor',StanfordRed, 'Parent', t(2));
set(t(2),'YLim',[0 0.1])


% Gas, tank vents

histogram(study_vent.gas,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.75,'EdgeColor',StanfordRed, 'Parent', t(3));
set(t(3),'YLim',[0 0.1])

% Gas, tank vents + flashing

vent = study_vent.gas;
flash = study_flash.gas;

plotvec = vertcat(vent,flash);

histogram(plotvec,b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',0.75,'EdgeColor',StanfordRed, 'Parent', t(4));
set(t(4),'YLim',[0 0.1])

            
            EPA_NoControl.Gas = vertcat(EPA_VENT.Gas, EPA_Dump.Gas);
            EPA_NoControl.Oil = vertcat(EPA_VENT.Oil, EPA_Dump.Oil);
            
        % Oil, Control
        
            ax1 = findall(t(1), 'type', 'axes');
            histogram(EPA_Control.Oil,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',LightGrey,'FaceAlpha',0.5, 'Parent', ax1);

            axes(ax1);
            set(ax1, 'XScale', 'log');
            set(t(1),'FontSize',7)
            set(t(1),'FontName','Arial')
%             set(t(1),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
%             set(t(1),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
            set(t(1),'XTickLabel',[]);
            set(t(1),'XMinorTick','on','YMinorTick','on')
            set(t(1),'TickDir', 'out')
            set(t(1),'TickLength',[0.03 0.035])
            set(t(1),'XLim',[0.000099 10000])
            grid(t(1),'off')
            set(t(1),'XMinorGrid','off');
            set(t(1),'box','on')
            
            set(ax1,'YLim',[0 0.1])
            ylabel('Probability density');
        % Oil, No Control
        
            ax2 = findall(t(2), 'type', 'axes');
            histogram(EPA_NoControl.Oil,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',LightGrey,'FaceAlpha',0.5, 'Parent', ax2);

            axes(ax2)
            set(ax2, 'XScale', 'log');
            set(t(2),'FontSize',7)
            set(t(2),'FontName','Arial')
%             set(t(2),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
%             set(t(2),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
            set(t(2),'XMinorTick','on','YMinorTick','on')
            set(ax2,'XTickLabel',[]);
            set(t(2),'TickDir', 'out')
            set(t(2),'TickLength',[0.03 0.035])
            set(t(2),'XLim',[0.000099 10000])
            grid(t(2),'off')
            set(t(2),'XMinorGrid','off');
            set(t(2),'box','on')
            
            set(ax2,'YTickLabel',[]);
            
        % Gas, Control
        
            ax3 = findall(t(3), 'type', 'axes');
            histogram(EPA_Control.Gas,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',LightGrey,'FaceAlpha',0.5, 'Parent', ax3);

            axes(ax3);
            set(ax3, 'XScale', 'log');
            set(t(3),'FontSize',7)
            set(t(3),'FontName','Arial')
            set(t(3),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
            set(t(3),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
            set(t(3),'XMinorTick','on','YMinorTick','on')
            set(t(3),'TickDir', 'out')
            set(t(3),'TickLength',[0.03 0.035])
            set(t(3),'XLim',[0.000099 10000])
            grid(t(3),'off')
            set(t(3),'XMinorGrid','off');
            set(t(3),'box','on')
            
            set(ax3,'YLim',[0 0.1])
            xlabel('Emissions [kg CH_{4}/d]');
            ylabel('Probability density');
        
        % Gas, No Control

            ax4 = findall(t(4), 'type', 'axes');     
            histogram(EPA_NoControl.Gas,b,'Normalization','probability','DisplayStyle','bar','LineStyle','-','LineWidth',0.5,'EdgeColor','none','FaceColor',LightGrey,'FaceAlpha',0.5, 'Parent', ax4);

            axes(ax4)
            set(ax4, 'XScale', 'log');
            set(t(4),'FontSize',7)
            set(t(4),'FontName','Arial')
            set(t(4),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
            set(t(4),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
            set(t(4),'XMinorTick','on','YMinorTick','on')
            set(t(4),'TickDir', 'out')
            set(t(4),'TickLength',[0.03 0.035])
            set(t(4),'XLim',[0.000099 10000])
            grid(t(4),'off')
            set(t(4),'XMinorGrid','off');
            set(t(4),'box','on')
            
            set(ax4,'YLim',[0 0.1])
            xlabel('Emissions [kg CH_{4}/d]');
            set(ax4,'YTickLabel',[]);
        
            %set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 2.75])
            %print('-djpeg','-r600','Fig_Tanks_v6_nlbl.jpg');
            
            %set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 3.50])
            %print('-djpeg','-r600','Fig_Tanks_v6_labld.jpg');
            
%% PREPARING EQUIP VECS FOR DECOMPOSITIONS
            
    % Gas, Wellheads (1), Separators (4), Meters(5)

        study_well.gas = gasvec(:,1);
        study_sep.gas = gasvec(:,4);
        study_meter.gas = gasvec(:,5);
        
        study_well.gas(any(isnan(study_well.gas),2),:) = [];
        study_sep.gas(any(isnan(study_sep.gas),2),:) = [];
        study_meter.gas(any(isnan(study_meter.gas),2),:) = [];
        
        study_well.gas = study_well.gas .* multiplier(1,4);
        study_sep.gas = study_sep.gas .* multiplier(4,4);
        study_meter.gas = study_meter.gas .* multiplier(5,4);
        
    % Oil, Wellheads (1), Separators (4), Meters(5)

        study_well.oil = oilvec(:,1);
        study_sep.oil = oilvec(:,4);
        study_meter.oil = oilvec(:,5);
        
        study_well.oil(any(isnan(study_well.oil),2),:) = [];
        study_sep.oil(any(isnan(study_sep.oil),2),:) = [];
        study_meter.oil(any(isnan(study_meter.oil),2),:) = [];
        
        study_well.oil = study_well.oil .* multiplier(1,8);
        study_sep.oil = study_sep.oil .* multiplier(4,8);
        study_meter.oil = study_meter.oil .* multiplier(5,8);        
            
        
        x = 1;