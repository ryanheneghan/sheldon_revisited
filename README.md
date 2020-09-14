# sheldon_revisited
Authors: Ian Hatton, Ryan Heneghan, Yinon Bar-On and Eric Galbraith

**Input data to calculate global estimates and uncertainty can be found in the ‘./data’ folder.

**Scripts to create data frames to save estimates found in the './R/processing_scripts/' folder

**Scripts to estimate biomass for each group can be found in the './R/biomass_estimate_scripts/' folder

***Figures are saved in ./figures, global map data for each group in ‘./output/global_map_data’, processing scripts for plots and global map data in ‘./R/processing_scripts’, summary output files in ‘./summary_output/’ file

The 'sheldon_revisited_master.R' script is the master script to set up dataframes, calculate biomass estimates
and their uncertainties, plot figures and conduct sensitivity analysis. The master script is set up to run
in four stages:

Step 0: Load all required packages.

Step 1: Run “./R/processing_scripts/create_summary_output_dataframes.R” to create the empty data frames to save biomass estimate and uncertainty outputs. Climate change projections for bacteria are also calculated in the "bacteria_biomass_estimate.R" script.

Step 2: Calculate total biomass and uncertainty estimates, and the spatial distibution of biomass for each group

Step 3: Run slope sensitivity tests to assess the sensitivity of the global biomass spectrum slope to uncertainty in biomass and distribution of each group's biomass within their respective size range. Conducts test for total biomass across all depths, and top 200m only. Also calculates uncertainty of global abundance spectrum, for all depths and top 200m. Tests are run through the script './processing_scripts/sensitivity_tests_master.R'



