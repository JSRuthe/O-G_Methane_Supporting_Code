function plot_for_methods(gasvec, oilvec)

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

            figure(2)
            N = 100;
            start = 10^-5;
            stop = 10^5;
            b = 10.^linspace(log10(start),log10(stop),N+1);

            N = 50;
            start = 10^-5;
            stop = 10^5;
            c = 10.^linspace(log10(start),log10(stop),N+1);

            % gas
             histogram(gasvec(:,1),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',StanfordLGreen);
%             hold on
%             histogram(gasvec(:,2),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',StanfordLGreen);
%             histogram(gasvec(:,3),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',StanfordLGreen);
%             histogram(gasvec(:,4),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',StanfordLGreen);
%             histogram(gasvec(:,5),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',StanfordLGreen);
%             histogram(gasvec(:,6),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',StanfordLGreen);
%             histogram(gasvec(:,9),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',StanfordLGreen);
%             histogram(gasvec(:,10),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',StanfordLGreen);
%             histogram(gasvec(:,11),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',StanfordLGreen);
%              histogram(gasvec(:,12),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',StanfordLGreen);
%             histogram(gasvec(:,15),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',StanfordLGreen);
            
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
            set(axis_a,'YLim',[0 0.06]) 
%             set(axis_a, {'XColor', 'YColor'}, {StanfordLGreen, StanfordLGreen});
%             set(axis_b, {'XColor', 'YColor'}, {StanfordLGreen, StanfordLGreen});
            pbaspect(axis_a, [1 1 1])
            pbaspect(axis_b, [1 1 1])

            %print('-djpeg','-r600','Equip_methods_1_v2.jpg');
            print('-painters','-dmeta','Fig1_equip_gas.emf');
             figure(3)
            N = 80;
            start = 10^-5;
            stop = 10^5;
            b = 10.^linspace(log10(start),log10(stop),N+1);

            N = 40;
            start = 10^-5;
            stop = 10^5;
            c = 10.^linspace(log10(start),log10(stop),N+1);

            % oil
             histogram(oilvec(:,1),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',2,'EdgeColor',StanfordRed);
%             hold on
%             histogram(oilvec(:,2),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed);
%             histogram(oilvec(:,6),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed);
%              histogram(oilvec(:,7),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed);
%             histogram(oilvec(:,9),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed);
%             histogram(oilvec(:,10),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed);
%             histogram(oilvec(:,11),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed);
%             histogram(oilvec(:,15),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed);
            
            set(gca, 'XScale', 'log');
            set(gca,'FontSize',20)
            set(gca,'FontName','Arial')
            set(gca,'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
            set(gca,'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
            set(gca,'XMinorTick','off','YMinorTick','off')
            set(gca, 'TickDir', 'out')
            set(gca,'TickLength',[0.03 0.035])
             xlabel('Emissions [kg CH_{4}/d]');
            set(gca,'XLim',[0.000099 10000])
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
            set(axis_a,'YLim',[0 0.06]) 
%             set(axis_a, {'XColor', 'YColor'}, {StanfordRed, StanfordRed});
%             set(axis_b, {'XColor', 'YColor'}, {StanfordRed, StanfordRed});
            pbaspect(axis_a, [1 1 1])
            pbaspect(axis_b, [1 1 1])
            print('-painters','-dmeta','Fig1_equip_oil.emf');
%            print('-djpeg','-r600','Equip_methods_2_v2.jpg');
             x = 1;