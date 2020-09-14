rm(list=ls())

#############################################
#### STEP 0: Load required packages
#############################################

# To plot figures of main effects and partial residuals
library(ggplot2) 
library(egg) 
library(visreg)
library(raster)

# To fit lognormal distribution (for individual bacteria biomass data)
library(MASS)

# To open netcdfs (for phytoplankton and fish predictions)
library(ncdf4)

# For area of 360x180 global grid squares (for global maps)
library(raster)

#############################################
#### STEP 1: Create summary output dataframes
source("./R/processing_scripts/create_summary_output_dataframes.R")

#############################################
#### STEP 2: Calculate biomass estimates, uncertainty and global maps for each group
run_bootstrap <- FALSE # Calculate bootstrap uncertainty estimate for bacteria abundance and zooplankton biomass
                       # This takes about 10 minutes per group, so set to FALSE by default to use pre-calculated values

## a) Bacteria
source("./R/biomass_estimate_scripts/bacteria_biomass_estimate.R")

## b) Phytoplankton
source("./R/biomass_estimate_scripts/phytoplankton_biomass_estimate.R")

## c) Nano and microzooplankton
source("./R/biomass_estimate_scripts/nano-microzoo_biomass_estimate.R")

## d) Mesozooplankton
source("./R/biomass_estimate_scripts/mesozoo_biomass_estimate.R")

## e) Macrozooplankton
source("./R/biomass_estimate_scripts/macrozoo_biomass_estimate.R")

## f) Mesopelagic, pelagic, demersal fish and invertebrates, and mammals
source("./R/biomass_estimate_scripts/fish_mammals_other_biomass_estimate.R")

#############################################
#### STEP 3: Sensitivity analysis of slope and intercept of global biomass spectrum
source("./R/processing_scripts/sensitivity_tests_master.R")

