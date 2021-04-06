function [s, t, results_tab, gasvectot, oilvectot] = Equip_Plotting_Main(gasvec, oilvec, k, s, t, n, gasvectot, oilvectot, all_equip, tanks_only, figure_all, EF_assess)
                                                    
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

results_tab = [];

% Set up bins
N = 80;
start = 10^-5;
stop = 10^5;
b = 10.^linspace(log10(start),log10(stop),N+1);

N = 40;
start = 10^-5;
stop = 10^5;
c = 10.^linspace(log10(start),log10(stop),N+1);

%% Plotting all equipment emission factor distributions

if all_equip == 1

	s = All_Plotting(gasvec, oilvec, s, n, k);

end

%% Plotting figure for methods section
      
if figure_all == 1

		plot_for_methods(gasvec, oilvec)
		
end


if EF_assess == 1       
    if k == 1
        gasvectot = gasvec;
        oilvectot = oilvec;
    elseif k > 1 && k < n.trial
        gasvectot = vertcat(gasvectot,gasvec);
        oilvectot = vertcat(oilvectot,oilvec);

    else
        loc = gasvectot(:,17) < 10 | (gasvectot(:,17) > 30 & gasvectot(:,17) < 40);
        gasvecmarg = gasvectot(loc,:);
        gasvechi = gasvectot(~loc,:);

        AF = [1;0;0.1321;0.7102;0.8399;0.40570;0.40570;0.0814;0.02987;0.2023; 1.8743; 0.175; 0; 0; 0.40570; 0.0320];

        for jj = 1:16
            vec_marg = gasvecmarg(:,jj);
            vec_marg(any(isnan(vec_marg),2),:) = [];

            if jj == 16
                vec_marg(vec_marg == 0) = [];
            end

            tot_emissions_marg = length(vec_marg);
            tot_equip_marg = length(gasvecmarg(:,1))*AF(jj);

            multiplier(jj,1) = tot_emissions_marg/tot_equip_marg;
            ave_em(jj,1) = mean(vec_marg) * multiplier(jj,1);

            vec_hi = gasvechi(:,jj);
            vec_hi(any(isnan(vec_hi),2),:) = [];
            tot_emissions_hi = length(vec_hi);
            tot_equip_hi = length(gasvechi(:,1))*AF(jj);

            multiplier(jj,2) = tot_emissions_hi/tot_equip_hi;
            ave_em(jj,2) = mean(vec_hi) * multiplier(jj,2);  
            
            vec_tot = gasvectot(:,jj);
            vec_tot(any(isnan(vec_tot),2),:) = [];
            tot_emissions_tot = length(vec_tot);
            tot_equip_tot = length(gasvectot(:,1))*AF(jj);           
            
            multiplier(jj,3) = (tot_emissions_marg + tot_emissions_hi)/(tot_equip_marg + tot_equip_hi);
            multiplier(jj,4) = (tot_emissions_tot/tot_equip_tot);
            
            Prciles_tot = prctile(vec_tot,[2.5 50 97.5]);
            ave_em(jj,3) = mean(vec_tot) * multiplier(jj,4);
            lo_em(jj,1) = Prciles_tot(1) * multiplier(jj,4);
            hi_em(jj,1) = Prciles_tot(3) * multiplier(jj,4);
        end

        loc = (oilvectot(:,17) > 60 & oilvectot(:,17) < 64)  | (oilvectot(:,17) > 70 & oilvectot(:,17) < 74);
        oilvecmarg = oilvectot(loc,:);
        oilvechi = oilvectot(~loc,:);

        AF = [1;0.2234;0.1859;0.3689;0;0.815404;0.815404;0;0;0.08612;1.1051; 0; 0; 0;0.815404; 0.06052];

        for jj = 1:16
            vec_marg = oilvecmarg(:,jj);
            vec_marg(any(isnan(vec_marg),2),:) = [];

            if jj == 16
                vec_marg(vec_marg == 0) = [];
            end

            tot_emissions_marg = length(vec_marg);
            tot_equip_marg = length(oilvecmarg(:,1))*AF(jj);

            multiplier(jj,5) = tot_emissions_marg/tot_equip_marg;
            ave_em(jj,4) = mean(vec_marg) * multiplier(jj,5);

            vec_hi = oilvechi(:,jj);
            vec_hi(any(isnan(vec_hi),2),:) = [];
            tot_emissions_hi = length(vec_hi);
            tot_equip_hi = length(oilvechi(:,1))*AF(jj);

            multiplier(jj,6) = tot_emissions_hi/tot_equip_hi;
            ave_em(jj,5) = mean(vec_hi) * multiplier(jj,6);   
            
            vec_tot = oilvectot(:,jj);
            vec_tot(any(isnan(vec_tot),2),:) = [];
            tot_emissions_tot = length(vec_tot);
            tot_equip_tot = length(oilvectot(:,1))*AF(jj);           
            
            multiplier(jj,7) = (tot_emissions_marg + tot_emissions_hi)/(tot_equip_marg + tot_equip_hi);
            multiplier(jj,8) = (tot_emissions_tot/tot_equip_tot);
            
            ave_em(jj,6) = mean(vec_tot) * multiplier(jj,8);
            Prciles_tot = prctile(vec_tot,[2.5 50 97.5]);
            lo_em(jj,2) = Prciles_tot(1) * multiplier(jj,4);
            hi_em(jj,2) = Prciles_tot(3) * multiplier(jj,4);            

        end
        % Final table
        Tab_Exp = [multiplier(:,4) ave_em(:,[1,2,3]) lo_em(:,1) hi_em(:,1) multiplier(:,8) ave_em(:,[4,5,6]) lo_em(:,2) hi_em(:,2)];
        %Export = [ave_em(:,3), ave_em(:,6)];
        csvwrite('EFS_ave_set20_test.csv', Tab_Exp)
        x = 1;
    end
end


%% TANKS PANELS

if k == n.trial

	Tanks_Plots(gasvec, oilvec, multiplier, Tab_Exp)

end
