%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EQUIPMENT LEAKAGE DECOMPOSITION PLOTTING
% Jeff Rutherford
% last updated November 1, 2020
%
% The purpose of this code is to generate decompositions for equipment
% leakage emissions factors (Figure 4 and others in SI). Decompositions are
% equipment-level emissions factors broken down into 3 constituents:
% (i)  component-level emissions measurements
% (ii) component counts per equipment
% (iii) fraction of components leaking
% 
% Input data:
%   (i) Component-level survey data: 
%           LGemitters.mat - exported from Methane_Data_Gathering on
%           October 31, 2020
%           SMemitters.mat - exported from Methane_Data_Gathering on
%           October 31, 2020
%   (ii) Upper-bound and lower-bound component-count matrices for oil and
%   gas systems.
%   (iii) Fraction of components leaking: FractionLeaking.csv
%   (iv) Equipment level data
%       EFs_ave - Average equipment-level emission factors copy and pasted
%       from Tables_Final_Plots on February 12, 2021
%       Equipvecs_Set20 - Saved vectors from first realizations of Set 20
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear; clc;

%% SETTING

z = 3;  % 1 = wellhead, 2 = separator, 3 = meter

% EPA order:
%   (1) West
%   (2) East
%   (3) Light
%   (4) Heavy

%% LOAD DATA

	% Study leaker values
    
		% > 10,000 ppmv
		load 'LGemitters'; 

		Component = cellstr(Component);
		StudyEmissions = EmissionsKgD;

		% Extract TC, VL, OEL

			StudyHi.TC = StudyEmissions(find(ismember(Component,'TC')+ismember(Component,'F')));
			StudyHi.TC = StudyHi.TC(isfinite(StudyHi.TC));
            StudyHi.TC(StudyHi.TC==0) = 0.000001;
            StudyHi.TC(StudyHi.TC < 0) = 0.000001;
            ind = isnan(StudyHi.TC);
            StudyHi.TC= StudyHi.TC(~ind);
    
			StudyHi.VL = StudyEmissions(find(ismember(Component,'VL')));
			StudyHi.VL = StudyHi.VL(isfinite(StudyHi.VL));
            StudyHi.VL(StudyHi.VL==0) = 0.000001;
            StudyHi.VL(StudyHi.VL < 0) = 0.000001;
            ind = isnan(StudyHi.VL);
            StudyHi.VL= StudyHi.VL(~ind);
            
			StudyHi.OEL = StudyEmissions(find(ismember(Component,'OEL')));
			StudyHi.OEL = StudyHi.OEL(isfinite(StudyHi.OEL));
            StudyHi.OEL(StudyHi.OEL==0) = 0.000001;
            StudyHi.OEL(StudyHi.OEL < 0) = 0.000001;
            ind = isnan(StudyHi.OEL);
            StudyHi.OEL= StudyHi.OEL(~ind);
            
		% < 10,000 ppmv
		
		load 'SMemitters'; 

		Component = cellstr(Component);
		StudyEmissions = EmissionsKgD;

		% Extract TC, VL, OEL
		
			StudyLo.TC = StudyEmissions(find(ismember(Component,'TC')+ismember(Component,'F')));
			StudyLo.TC = StudyLo.TC(isfinite(StudyLo.TC));

			StudyLo.VL = StudyEmissions(find(ismember(Component,'VL')));
			StudyLo.VL = StudyLo.VL(isfinite(StudyLo.VL));

			StudyLo.OEL = StudyEmissions(find(ismember(Component,'OEL')));
			StudyLo.OEL = StudyLo.OEL(isfinite(StudyLo.OEL));
    
	% EPA matrices
		data=importdata('EPA_Conn.csv');
		EPA_Comp.Conn = data;
		data=importdata('EPA_Valve.csv');
		EPA_Comp.Valve = data;  
		data=importdata('EPA_OEL.csv');
		EPA_Comp.OEL = data;

%% Plotting
       
for i = 1:4

    Leakage_Plotting(StudyHi,EPA_Comp,i, z)

      set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 3.25])
      print('-djpeg','-r300',sprintf('MET_SI_Set20_lbl_%d.jpg',i));
%       print('-dtiff','-r600',sprintf('MET_SI_Set20_lbl_%d.tif',i));
      %print('-dpdf','-r600',sprintf('WELL_SI_Set16_nolbl_%d.pdf',i));
%       set(gcf,'Renderer', 'Painters')
%       saveas(gcf,sprintf('WELL_SI_Set20_lbl_%d.emf',i),'meta');
end
