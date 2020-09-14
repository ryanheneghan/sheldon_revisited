#rm(list=ls())

#########################################################################
## Script for Sheldon Revisited group biomass estimates
## Authors: Ian Hatton, Ryan Heneghan, Yinon Bar-On and Eric Galbraith
##
## THIS SCRIPT CREATES EMPTY CSVS FOR OUTPUT OF UNCERTAINTY AND BIOMASS ESTIMATES
#########################################################################
# Set working directory to scripts_data_figures folder
#setwd("~/Desktop/Papers/Sheldon_Revisited/scripts_data_figures/")

#### SET UP SUMMARY OUTPUT FILES
group_names <- c("Hetero_Bacteria", "Picophytoplankton", "Nanophytoplankton", "Microphytoplankton",
                 "Nanozooplankton", "Microzooplankton", "Mesozooplankton", "Macrozooplankton",
                 "Mesopelagics", "Fish", "Mammals")
midpoint_sizes <- -13.5:8.5

group_standard_errors <- data.frame("Group" = group_names,
                                    "log10_Standard_Error" = 0)

write.csv(group_standard_errors, file = "./output/summary_output/summary_tables/group_standard_errors.csv", row.names = FALSE)

summary_biomass_table <- data.frame("Group" = group_names,
                                         "Biomass_Pg_wet_weight_estimate" = 0,
                                         "Biomass_Pg_wet_weight_95CI_lower" = 0,
                                         "Biomass_Pg_wet_weight_95CI_upper" = 0)

write.csv(summary_biomass_table, file = "./output/summary_output/summary_tables/summary_biomass_table.csv", row.names = FALSE)
write.csv(summary_biomass_table, file = "./output/summary_output/summary_tables/summary_biomass_table_top200.csv", row.names = FALSE)

summary_biomass_table_long <- data.frame("Group" = rep(group_names, each = length(midpoint_sizes)),
                                         "log10_Size_Midpoint_g" = rep(midpoint_sizes, length(group_names)),
                                         "Biomass_Pg_wet_weight_estimate" = 0,
                                         "Biomass_Pg_wet_weight_95CI_lower" = 0,
                                         "Biomass_Pg_wet_weight_95CI_upper" = 0)

write.csv(summary_biomass_table_long, file = "./output/summary_output/summary_tables/summary_biomass_table_long.csv", row.names = FALSE)

summary_biomass_top200_table_long <- data.frame("Group" = rep(group_names, each = length(midpoint_sizes)),
                                                "log10_Size_Midpoint_g" = rep(midpoint_sizes, length(group_names)),
                                                "Biomass_Pg_wet_weight_estimate" = 0,
                                                "Biomass_Pg_wet_weight_95CI_lower" = 0,
                                                "Biomass_Pg_wet_weight_95CI_upper" = 0)

write.csv(summary_biomass_top200_table_long, file = "./output/summary_output/summary_tables/summary_biomass_top200_table_long.csv", row.names = FALSE)


