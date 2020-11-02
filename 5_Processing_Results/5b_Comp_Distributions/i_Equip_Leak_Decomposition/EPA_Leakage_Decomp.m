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
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear; clc;

%% SETTING

z = 1;  % 1 = wellhead, 2 = separator, 3 = meter

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
            StudyHi.TC(StudyHi.TC==0) = NaN;
            StudyHi.TC(StudyHi.TC < 0) = NaN;
            ind = isnan(StudyHi.TC);
            StudyHi.TC= StudyHi.TC(~ind);
    
			StudyHi.VL = StudyEmissions(find(ismember(Component,'VL')));
			StudyHi.VL = StudyHi.VL(isfinite(StudyHi.VL));
            StudyHi.VL(StudyHi.VL==0) = NaN;
            StudyHi.VL(StudyHi.VL < 0) = NaN;
            ind = isnan(StudyHi.VL);
            StudyHi.VL= StudyHi.VL(~ind);
            
			StudyHi.OEL = StudyEmissions(find(ismember(Component,'OEL')));
			StudyHi.OEL = StudyHi.OEL(isfinite(StudyHi.OEL));
            StudyHi.OEL(StudyHi.OEL==0) = NaN;
            StudyHi.OEL(StudyHi.OEL < 0) = NaN;
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
     print('-djpeg','-r600',sprintf('MET_SI_Set11_nolbl_%d.jpg',i));
    
end
