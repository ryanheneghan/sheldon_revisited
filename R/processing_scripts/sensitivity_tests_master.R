#########################################################################
## Script for Sheldon Revisited group biomass estimates
## Authors: Ian Hatton, Ryan Heneghan, Yinon Bar-On and Eric Galbraith
##
################## SENSITIVITY ANALYSIS OF SLOPE AND INTERCEPT ########################
##
## Here, we vary the biomass in each size bin randomly using the standard error we have calculated
## for each bin. Then, we can refit the slope and intercept for each permutation. We do this 10,000 times
## to get an idea of the standard error of our slope estimate, first assuming the biomass is equally distributed.
## The second time, we do it not assuming the biomass is equally distributed.
## We also report the 95% confidence interval of the slope of the abundance size spectrum with mean and varying biomass for each group
#########################################################################

#rm(list=ls())

# Packages for plotting
library(ggplot2)
library(egg)

# Load sensitivity analysis function
source("./R/processing_scripts/sensitivity_test_wrapper_func.R")

# Conduct sensitivity analysis for global biomass across all depths
print("Now conducting sensitivity test for global biomass across all depths")
glob_biom_frame1 <- read.csv('./output/summary_output/summary_tables/summary_biomass_table.csv')
save_ref1 <- 'all_biom'
sens_test_wrapper(glob_biom_frame = glob_biom_frame1, save_ref = save_ref1)

# Conduct sensitivity analysis for global biomass in top 200m only
print("Now conducting sensitivity test for global biomass in top 200m")
glob_biom_frame2 <- read.csv('./output/summary_output/summary_tables/summary_biomass_table_top200.csv')
save_ref2 <- 'top200_biom'
sens_test_wrapper(glob_biom_frame = glob_biom_frame2, save_ref = save_ref2)


