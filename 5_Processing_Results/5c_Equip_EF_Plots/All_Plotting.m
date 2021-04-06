function s = All_Plotting(gasvec, oilvec, s, n, k)

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

% Set up bins
N = 80;
start = 10^-5;
stop = 10^5;
b = 10.^linspace(log10(start),log10(stop),N+1);

N = 40;
start = 10^-5;
stop = 10^5;
c = 10.^linspace(log10(start),log10(stop),N+1);

		
if k == 1
	s       = [];
	counter = 1;
	bottom = 0.75;
	for jj = 1:4
		left = 0.07;

		if jj == 4
				   s(counter) = axes('Position', [left, bottom, 0.18, 0.17], ...
				  'NextPlot', 'add');
				   left = left + 0.24;
				   counter = counter + 1;
				   break;
		end

		for ii = 1:4
				  s(counter) = axes('Position', [left, bottom, 0.18, 0.17], ...
				  'NextPlot', 'add');
				   left = left + 0.24;
				   counter = counter + 1;
		end
				bottom = bottom - 0.23;
	end
end


% Wells

	histogram(gasvec(:,1),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordLGreen, 'Parent', s(1));
	set(s(1),'YLim',[0 0.1])
	histogram(oilvec(:,1),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed, 'Parent', s(1));
	set(s(1),'YLim',[0 0.1])

	if k == n.trial
		set(s(1), 'XScale', 'log');
		set(s(1),'FontSize',7)
		set(s(1),'FontName','Arial')
		set(s(1),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
		set(s(1),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
		set(s(1),'XMinorTick','off','YMinorTick','off')
		set(s(1), 'TickDir', 'out')
		set(s(1),'TickLength',[0.03 0.035])
		set(s(1),'XLim',[0.000099 10000])
		grid(s(1),'on')
		set(s(1),'XMinorGrid','off');
		axis_a = s(1);
		% set box property to off and remove background color
		set(axis_a,'box','off','color','none')
		% create new, empty axes with box but without ticks
		axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
		% set original axes as active
		axes(axis_a)
		% link axes in case of zooming
		linkaxes([axis_a axis_b])
		set(s(1),'YLim',[0 0.1])
	end

 % Separators

	histogram(gasvec(:,4),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordLGreen, 'Parent', s(2));
	set(s(2),'YLim',[0 0.08])

	histogram(oilvec(:,4),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed, 'Parent', s(2));
	set(s(2),'YLim',[0 0.08])

%     set(s(2),'YTickLabel',[]);
	if k == n.trial
		set(s(2), 'XScale', 'log');
		set(s(2),'FontSize',7)
		set(s(2),'FontName','Arial')
		set(s(2),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
		set(s(2),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
		set(s(2),'XMinorTick','off','YMinorTick','off')
		set(s(2), 'TickDir', 'out')
		set(s(2),'TickLength',[0.03 0.035])
		set(s(2),'XLim',[0.000099 10000])
		grid(s(2),'on')
		set(s(2),'XMinorGrid','off');
		axis_a = s(2);
		% set box property to off and remove background color
		set(axis_a,'box','off','color','none')
		% create new, empty axes with box but without ticks
		axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
		% set original axes as active
		axes(axis_a)
		% link axes in case of zooming
		linkaxes([axis_a axis_b])
		set(s(2),'YLim',[0 0.08])
	end

% Dehydrator

	histogram(gasvec(:,9),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordLGreen, 'Parent', s(3));
	set(s(3),'YLim',[0 0.01])

	% No dehydrators in oil system
%      histogram(oilvec(:,3),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1,'EdgeColor',StanfordRed, 'Parent', s(3));
%     set(s(1),'YLim',[0 0.05]])

%     set(s(3),'YTickLabel',[]);
	if k == n.trial
		set(s(3), 'XScale', 'log');
		set(s(3),'FontSize',7)
		set(s(3),'FontName','Arial')
		set(s(3),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
		set(s(3),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
		set(s(3),'XMinorTick','on','YMinorTick','on')
		set(s(3), 'TickDir', 'out')
		set(s(3),'TickLength',[0.03 0.035])
		set(s(3),'XLim',[0.000099 10000])
		grid(s(3),'on')
		set(s(3),'XMinorGrid','off');
		axis_a = s(3);
		% set box property to off and remove background color
		set(axis_a,'box','off','color','none')
		% create new, empty axes with box but without ticks
		axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
		% set original axes as active
		axes(axis_a)
		% link axes in case of zooming
		linkaxes([axis_a axis_b])
		set(s(3),'YLim',[0 0.01])
	end

% % Meter

	histogram(gasvec(:,5),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordLGreen, 'Parent', s(4));
	set(s(4),'YLim',[0 0.06])

	% No meters in oil system
%      histogram(oilvec(:,1),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1,'EdgeColor',StanfordRed, 'Parent', s(1));
%     set(s(1),'YLim',[0 0.05]])

%     set(s(4),'YTickLabel',[]);
	if k == n.trial
		set(s(4), 'XScale', 'log'); 
		set(s(4),'FontSize',7)
		set(s(4),'FontName','Arial')
		set(s(4),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
		set(s(4),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
		set(s(4),'XMinorTick','on','YMinorTick','on')
		set(s(4), 'TickDir', 'out')
		set(s(4),'TickLength',[0.03 0.035])
		set(s(4),'XLim',[0.000099 10000])
		grid(s(4),'on')
		set(s(4),'XMinorGrid','off');
		axis_a = s(4);
		% set box property to off and remove background color
		set(axis_a,'box','off','color','none')
		% create new, empty axes with box but without ticks
		axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
		% set original axes as active
		axes(axis_a)
		% link axes in case of zooming
		linkaxes([axis_a axis_b])
		set(s(4),'YLim',[0 0.06])
	end

% % Reciprocating Compressor

	histogram(gasvec(:,8),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordLGreen, 'Parent', s(5));
	set(s(5),'YLim',[0 0.02])

	% No recips in oil system
%      histogram(oilvec(:,1),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1,'EdgeColor',StanfordRed, 'Parent', s(1));
%     set(s(1),'YLim',[0 0.05]])

%     set(s(5),'YTickLabel',[]);
	if k == n.trial
	set(s(5), 'XScale', 'log');
		set(s(5),'FontSize',7)
		set(s(5),'FontName','Arial')
		set(s(5),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
		set(s(5),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
		set(s(5),'XMinorTick','on','YMinorTick','on')
		set(s(5), 'TickDir', 'out')
		set(s(5),'TickLength',[0.03 0.035])
		set(s(5),'XLim',[0.000099 10000])
		grid(s(5),'on')
		set(s(5),'XMinorGrid','off');
		axis_a = s(6);
		% set box property to off and remove background color
		set(axis_a,'box','off','color','none')
		% create new, empty axes with box but without ticks
		axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
		% set original axes as active
		axes(axis_a)
		% link axes in case of zooming
		linkaxes([axis_a axis_b])
		set(s(6),'YLim',[0 0.02])
	end

% % Heater

	histogram(gasvec(:,3),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordLGreen, 'Parent', s(6));
	set(s(6),'YLim',[0 0.03])

	 histogram(oilvec(:,3),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed, 'Parent', s(6));
	set(s(6),'YLim',[0 0.03])

%     set(s(6),'YTickLabel',[]);
	if k == n.trial
		set(s(6), 'XScale', 'log');
		set(s(6),'FontSize',7)
		set(s(6),'FontName','Arial')
		set(s(6),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
		set(s(6),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
		set(s(6),'XMinorTick','on','YMinorTick','on')
		set(s(6), 'TickDir', 'out')
		set(s(6),'TickLength',[0.03 0.035])
		set(s(6),'XLim',[0.000099 10000])
		grid(s(6),'on')
		set(s(6),'XMinorGrid','off');
		axis_a = s(6);
		% set box property to off and remove background color
		set(axis_a,'box','off','color','none')
		% create new, empty axes with box but without ticks
		axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
		% set original axes as active
		axes(axis_a)
		% link axes in case of zooming
		linkaxes([axis_a axis_b])
		set(s(6),'YLim',[0 0.03])
	end
 % % Header

%  No header in gas system
%     histogram(gasvec(:,1),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1,'EdgeColor',StanfordLGreen, 'Parent', s(1));
%     set(s(1),'YLim',[0 0.05]])

	 histogram(oilvec(:,2),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed, 'Parent', s(7));
	set(s(7),'YLim',[0 0.05])

%     set(s(7),'YTickLabel',[]);
	if k == n.trial
		set(s(7), 'XScale', 'log');
		set(s(7),'FontSize',7)
		set(s(7),'FontName','Arial')
		set(s(7),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
		set(s(7),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
		set(s(7),'XMinorTick','on','YMinorTick','on')
		set(s(7),'TickDir', 'out')
		set(s(7),'TickLength',[0.03 0.035])
		set(s(7),'XLim',[0.000099 10000])
		grid(s(7),'on')
		set(s(7),'XMinorGrid','off');
		axis_a = s(7);
		% set box property to off and remove background color
		set(axis_a,'box','off','color','none')
		% create new, empty axes with box but without ticks
		axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
		% set original axes as active
		axes(axis_a)
		% link axes in case of zooming
		linkaxes([axis_a axis_b])
		set(s(7),'YLim',[0 0.05])
	end

%  % % Chemical injection pumps
% 
%     histogram(gasvec(:,8),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordLGreen, 'Parent', s(8));
%     set(s(8),'YLim',[0 0.01])
% 
%      histogram(oilvec(:,8),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed, 'Parent', s(8));
%     set(s(8),'YLim',[0 0.01])
% 
% %     set(s(8),'YTickLabel',[]);
%     if k == n.trial
%         set(s(8), 'XScale', 'log');
%         set(s(8),'FontSize',7)
%         set(s(8),'FontName','Arial')
%         set(s(8),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
%         set(s(8),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
%         set(s(8),'XMinorTick','on','YMinorTick','on')
%         set(s(8),'TickDir', 'out')
%         set(s(8),'TickLength',[0.03 0.035])
%         set(s(8),'XLim',[0.000099 10000])
%         grid(s(8),'on')
%         set(s(8),'XMinorGrid','off');
%         axis_a = s(8);
%         % set box property to off and remove background color
%         set(axis_a,'box','off','color','none')
%         % create new, empty axes with box but without ticks
%         axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
%         % set original axes as active
%         axes(axis_a)
%         % link axes in case of zooming
%         linkaxes([axis_a axis_b])
%         set(s(8),'YLim',[0 0.01])
%     end

 % % Pneumatic controllers

	histogram(gasvec(:,11),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordLGreen, 'Parent', s(8));
	set(s(8),'YLim',[0 0.1]);

	 histogram(oilvec(:,11),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed, 'Parent', s(8));
	set(s(8),'YLim',[0 0.1]);

%     set(s(9),'YTickLabel',[]);

	if k == n.trial
		set(s(8), 'XScale', 'log');
		set(s(8),'FontSize',7)
		set(s(8),'FontName','Arial')
		set(s(8),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
		set(s(8),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
		set(s(8),'XMinorTick','on','YMinorTick','on')
		set(s(8), 'TickDir', 'out')
		set(s(8),'TickLength',[0.03 0.035])
		set(s(8),'XLim',[0.000099 10000])
		grid(s(8),'on')
		set(s(8),'XMinorGrid','off');
		axis_a = s(8);
		% set box property to off and remove background color
		set(axis_a,'box','off','color','none')
		% create new, empty axes with box but without ticks
		axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
		% set original axes as active
		axes(axis_a)
		% link axes in case of zooming
		linkaxes([axis_a axis_b])
		set(s(8),'YLim',[0 0.1])
	end

 % % Tank leaks

	histogram(gasvec(:,6),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordLGreen, 'Parent', s(9));
	set(s(9),'YLim',[0 0.1])

	 histogram(oilvec(:,6),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed, 'Parent', s(9));
	set(s(9),'YLim',[0 0.1])

%     set(s(10),'YTickLabel',[]);
	if k == n.trial
		set(s(9), 'XScale', 'log');
		set(s(9),'FontSize',7)
		set(s(9),'FontName','Arial')
		set(s(9),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
		set(s(9),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
		set(s(9),'XMinorTick','on','YMinorTick','on')
		set(s(9),'TickDir', 'out')
		set(s(9),'TickLength',[0.03 0.035])
		set(s(9),'XLim',[0.000099 10000])
		grid(s(9),'on')
		set(s(9),'XMinorGrid','off');
		axis_a = s(9);
		% set box property to off and remove background color
		set(axis_a,'box','off','color','none')
		% create new, empty axes with box but without ticks
		axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
		% set original axes as active
		axes(axis_a)
		% link axes in case of zooming
		linkaxes([axis_a axis_b])
		set(s(9),'YLim',[0 0.1])
	end
	% % Tank vents

	histogram(gasvec(:,7),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordLGreen, 'Parent', s(10));
	set(s(10),'YLim',[0 0.08])

	 histogram(oilvec(:,7),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed, 'Parent', s(10));
	set(s(10),'YLim',[0 0.08])

%     set(s(11),'YTickLabel',[]);

	if k == n.trial
		set(s(10), 'XScale', 'log');
		set(s(10),'FontSize',7)
		set(s(10),'FontName','Arial')
		set(s(10),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
		set(s(10),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
		set(s(10),'XMinorTick','on','YMinorTick','on')
		set(s(10),'TickDir', 'out')
		set(s(10),'TickLength',[0.03 0.035])
		set(s(10),'XLim',[0.000099 10000])
		grid(s(10),'on')
		set(s(10),'XMinorGrid','off');
		axis_a = s(10);
		% set box property to off and remove background color
		set(axis_a,'box','off','color','none')
		% create new, empty axes with box but without ticks
		axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
		% set original axes as active
		axes(axis_a)
		% link axes in case of zooming
		linkaxes([axis_a axis_b])
		set(s(10),'YLim',[0 0.08])
	end

 % Liquids unloadings

	histogram(gasvec(:,12),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordLGreen, 'Parent', s(11));
	set(s(11),'YLim',[0 0.03])

%     histogram(oilvec(:,12),b,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1,'EdgeColor',StanfordRed, 'Parent', s(12));
%     set(s(1),'YLim',[0 0.05]])    
%     
%     set(s(12),'YTickLabel',[]);
	if k == n.trial       
		set(s(11), 'XScale', 'log');
		set(s(11),'FontSize',7)
		set(s(11),'FontName','Arial')
		set(s(11),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
		set(s(11),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
		set(s(11),'XMinorTick','on','YMinorTick','on')
		set(s(11),'TickDir', 'out')
		set(s(11),'TickLength',[0.03 0.035])
		set(s(11),'XLim',[0.000099 10000])
		grid(s(11),'on')
		set(s(11),'XMinorGrid','off');
		axis_a = s(11);
		% set box property to off and remove background color
		set(axis_a,'box','off','color','none')
		% create new, empty axes with box but without ticks
		axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
		% set original axes as active
		axes(axis_a)
		% link axes in case of zooming
		linkaxes([axis_a axis_b])
		set(s(11),'YLim',[0 0.03])
	end

%  Tank breathing

	histogram(gasvec(:,15),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordLGreen, 'Parent', s(12));
	set(s(12),'YLim',[0 0.04])

	histogram(oilvec(:,15),c,'Normalization','probability','DisplayStyle','stairs','LineStyle','-','LineWidth',1.5,'EdgeColor',StanfordRed, 'Parent', s(12));
	set(s(12),'YLim',[0 0.04])    

%     set(s(13),'YTickLabel',[]);

	if k == n.trial
		set(s(12), 'XScale', 'log');
		set(s(12),'FontSize',7)
		set(s(12),'FontName','Arial')
		set(s(12),'XTick',[10^-4 10^-2 10^0 10^2 10^4]);
		set(s(12),'XTickLabel',{'10^{-4}', '10^{-2}', '10^{0}', '10^{2}', '10^{4}'});
		set(s(12),'XMinorTick','off','YMinorTick','off')
		set(s(12), 'TickDir', 'out')
		set(s(12),'TickLength',[0.03 0.035])
		set(s(12),'XLim',[0.000099 10000])
		grid(s(12),'on')
		set(s(12),'XMinorGrid','off');
		axis_a = s(12);
		% set box property to off and remove background color
		set(axis_a,'box','off','color','none')
		% create new, empty axes with box but without ticks
		axis_b = axes('Position',get(axis_a,'Position'),'box','on','xtick',[],'ytick',[]);
		% set original axes as active
		axes(axis_a)
		% link axes in case of zooming
		linkaxes([axis_a axis_b])
		set(s(12),'YLim',[0 0.04]) 
	end
