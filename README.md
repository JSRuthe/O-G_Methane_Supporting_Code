# O-G_Methane_Supporting_Code

## Overview and contents ##
This repository contains code and spreadsheets supporting the paper "Closing the gap: Explaining persistent underestimation of US oil and natural gas production methane inventories". 

The analysis platform for this study is the component-level methane emissions subroutine embedded within the life-cycle assessment simulator Oil Production and Greenhouse Gas Emissions Estimator (OPGEE 3.0, see repository for OPGEE 3.0 [here](https://github.com/arbrandt/OPGEE ) ). Note that OPGEE 3.0 is under continuous development.

The methane emissions subroutine processes inputs from external databases – specifically equipment-level emissions distributions and well and production values and produces gross emissions estimates. The flowchart below summarizes the data processing workflow with reference to the specific folder locations in this repository. Certain datasets used are propriety and not publicly available. These include the Enverus dataset, used to generate well count and production parameters, and the Wood Mackenzie dataset, used to generator gas-to-oil ratios for oil-only wells.

Another key element of analysis in the paper referenced above is the summary of methane emissions in the EPA Greenhouse Gas Inventory. Spreadsheets supporting this analysis are located in the folder “1_GHGI_Analysis”.

![alt text](https://user-images.githubusercontent.com/42356585/108004143-2fb22d00-6fb2-11eb-84a6-a70410f936ad.jpg)

## Software requirements and installation ##
OPGEE 3.0 and the methane emissions database are developed in a Microsoft Excel format, therefore no specific installation instructions are required. For full access to OPGEE 3.0 uncertainty analysis capabilities, users should have the Developer tab  visible.

The data and visuals processing scripts are written in the Matlab programming language.

## Running the model ##
Basic functions of the methane emissions subroutine in OPGEE can be run independently of the preceding “Methane database” and “Equipment-level EF generator” scripts. Description of the methane database and development of the equipment-level emission factor distributions can be found in Supplementary Methods 4 in the Supplementary Information.
For a single uncertainty realization:
1)	The OPGEE 3.0 Excel file is located in the folder: “\4_OPGEE_Modelling\b_OPGEE_runs”.
2)	Prior to opening OPGEE, make sure “Calculation options” are set to “Manual” (File -> Options -> Formulas -> Calculation Options).
3)	Open OPGEE 3.0
4)	Navigate to the “Inputs tab”. Settings (top rows) should already be preset to those used for the study (Uncert. Runs: 1, Functional unit: Gas, Oil boundary: Field, Gas boundary: Distribution, Co-production: Allocation, Fugitives model: Component).
5)	Set fields: 200-273. OPGEE generates outputs (carbon intensity or methane leakage rate) on a “field” basis, where a “field” represents an O&NG system with unique properties. In our case, “fields” are the productivity tranches/bins (described in Supplementary Methods 5).
6)	Click “Run Assessment”. A full assessment of all 74 tranches (corresponding to all US wells) takes approximately 2.5 hours on a standard desktop computer, but possibly longer on a laptop computer.

Results of the methane emissions subroutine can be viewed on the “VF method – component” tab (see description of how to navigate this tab in Supplementary Methods 4). Total emissions should be within the uncertainty bounds presented in the main manuscript.
The OPGEE file located in “2_OPGEE_Modelling” has already been seeded with a single uncertainty realization of equipment-level emission factor distributions. However, results presented in the main text of the paper were generated with 100 Monte Carlo uncertainty realizations (where one uncertainty realization corresponds to a separate equipment-level emission factor distribution file). 

For a full uncertainty assessment:
1)	First, make sure that the Developer tab   is visible.
2)	Follow steps 1-5 same as above
3)	Download all equipment-level emission factor distributions in the folder: “\4_OPGEE_Modelling\b_OPGEE_runs\Inputs”. Save files to the same folder as the OPGEE Excel file.
4)	Navigate to the Macros menu in the [Developer tab](https://support.microsoft.com/en-us/office/show-the-developer-tab-e1192344-5e56-4d45-931b-e5fd9bea2d45). Scroll to the bottom of the list, select the “Ultrabulk_assessment” macro, then click “Edit”.
5)	Navigate to the “Autorun macro” (On left hand side of VBA terminal, double click on “AutoRun” in the modules folder). 
6)	In the “Autorun” macro, edit “StrText” to the folder where you will run OPGEE. Do not remove “\Equip” at the end of the folder path. The general form should be:

strText = “C:\INSERT_FOLDER_NAME\Equip”

7)	Run the “AutoRun” macro.
8)	OPGEE will generate a set of 100 .csv files containing results data. These results are processed using the Matlab scripts contained in the folder “\5_Processing_Results\8a_OPGEE_Processing”
