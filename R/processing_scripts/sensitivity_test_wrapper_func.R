# The 'sens_test_wrapper' function returns the mean and sd of the slope of total biomass, histograms
# of the distribution of the slope and confidence bands for the global abundance spectrum
# "global_biom_frame": Data frame of total biomass estimates
# "save_ref": Reference name for saved plots and dataframes (usually "all_biom" or "top200_biom")

# Load slope and intercept sensitivity function
source("./R/processing_scripts/sensitivity_func.R")

sens_test_wrapper <- function(glob_biom_frame, long_biom_frame, save_ref){
  glob_biom_all <- glob_biom_frame$Biomass_Pg_wet_weight_estimate*1e15 # Convert from Pg to grams
  glob_biom_all<- c(glob_biom_all,sum(glob_biom_all[2:4])) # Get total phytoplankton
  glob_biom_all <- glob_biom_all[c(1,12,5,6,7,8,9,10,11)]  # Remove pico, nano and microphytoplankton
  names(glob_biom_all) <- c("bact","phyt","nanozoo","microzoo","mesozoo","macrozoo","mesopelagic","fish","mammals")
  
  # Log10 midpoint of size bins
  x <- -13.5:8.5
  
  # Data.frame (sizes) with 1s for size range and 0s for outside size range for each group. Can be used to modify number of bins
  long_frame <- matrix(long_biom_frame$Biomass_Pg_wet_weight_estimate, nrow = length(x))
  long_frame[,2] <- long_frame[,2] + long_frame[,3] + long_frame[,4]
  long_frame <- long_frame[,-c(3,4)]
  colnames(long_frame) <- c("bact","phyt","nanozoo","microzoo","mesozoo","macrozoo","mesopelagic","fish","mammals")
  sizes <- long_frame
  sizes[sizes > 0] <- 1
 
  # Fraction of biomass in each size bin for each group
  fracsB1 <- sweep(long_frame, 2, colSums(long_frame), "/")

  rownames(sizes) <- rownames(fracsB1) <- x
  
  # Import 95% confidence interval and divide by 1.96 to get standard errors
  group_errors <- read.csv("./output/summary_output/summary_tables/group_standard_errors.csv")
  log_se <- log10(group_errors$log10_Standard_Error[-c(2,3)])/1.96 # Standard error of each group biomass estimate (in log10-space)
  log_mean_biom <- log10(glob_biom_all)
  
  # Obtain distribution of slopes and intercepts when distribution of average biomass is allowed to vary across the size range of each group
  print("Calculating slope and intercept uncertainty when distribution of average biomass only is allowed to vary")
  mean_biom_sensitivity <- sensitivity_func(10000, log_mean_biom = log10(glob_biom_all), log_se = log_se, var_biom = FALSE, sizes = sizes, x = x, props = fracsB1)
  mean_biom_sensitivity <- data.frame("intercept"= mean_biom_sensitivity[,1], "slope" = mean_biom_sensitivity[,2])
  
  write.csv(mean_biom_sensitivity, file = paste('./output/summary_output/sensitivity_analysis/biomass_slopes/all_sens_slope_ints_mean_biom', save_ref, '.csv', sep = ""), row.names = FALSE)
  print(paste("Slopes and intercepts from 10,000 simulations using mean biomass for each group stored in ", paste('./output/summary_output/sensitivity_analysis/biomass_slopes/all_sens_slope_ints_mean_biom', save_ref, '.csv', sep = ""), sep = ""))
  
  # Obtain distribution of slopes and intercepts when biomass is allowed to vary for each group, based on group standard error,
  # and distribution of biomass varies across the size range of each group
  print("Calculating slope and intercept uncertainty when both biomass and distribution of biomass allowed to vary")
  distn_biom_sensitivity <- sensitivity_func(10000, log_mean_biom = log10(glob_biom_all), log_se = log_se, var_biom = TRUE, sizes = sizes, x = x, props = fracsB1)
  distn_biom_sensitivity <- data.frame("intercept" = distn_biom_sensitivity[,1], "slope" = distn_biom_sensitivity[,2])
  
  write.csv(distn_biom_sensitivity, file = paste('./output/summary_output/sensitivity_analysis/biomass_slopes/all_sens_slope_ints_distn_biom', save_ref, '.csv', sep = ""), row.names = FALSE)
  
  print(paste("Slopes and intercepts from 10,000 simulations allowing varying biomass for each group stored in ", paste('./output/summary_output/sensitivity_analysis/biomass_slopes/all_sens_slope_ints_distn_biom', save_ref, '.csv', sep = ""), sep = ""))
  
  ## Summary table
  print("Saving summary table of mean and sd of biomass spectrum slope from both tests")
  summary_slopes <- matrix(c(mean(mean_biom_sensitivity$slope), sd(mean_biom_sensitivity$slope), mean(distn_biom_sensitivity$slope), sd(distn_biom_sensitivity$slope)), nrow = 2, ncol = 2)
  rownames(summary_slopes) <- c("Mean Slope", "Slope SE")
  colnames(summary_slopes) <- c("Mean_Biom", "Distn_Biom")
  summary_slopes
  
  write.csv(summary_slopes, file = paste('./output/summary_output/sensitivity_analysis/biomass_slopes/sensitivity_slopes_', save_ref, '.csv', sep = ""), row.names = FALSE)
  
  ## Plot distribution of slopes with mean bimass estimate for each group, where we do not assume biomass is equally distributed for each group in log10 order of magnitude bins
  print("Saving histograms of slopes from both tests")
  hist1 <- ggplot(mean_biom_sensitivity, aes(slope)) + 
    geom_histogram(binwidth = .005, col="black", fill = "darkgray",size=0.5,position="identity")+
    theme_bw()+theme(axis.text = element_text(size = 24),
                     plot.subtitle = element_text(size = 24),
                     axis.title = element_text(size = 24),
                     panel.border = element_rect(size = 1),
                     axis.ticks = element_line(size = 1),
                     legend.position = "none")+
    geom_vline(xintercept = mean(mean_biom_sensitivity$slope), col = "darkred", size = 1)+
    ylab('Frequency') + 
    xlab('Global Biomass Spectrum Slope') + xlim(min(c(mean_biom_sensitivity$slope, distn_biom_sensitivity$slope)), max(c(mean_biom_sensitivity$slope, distn_biom_sensitivity$slope)))+
    labs(subtitle = "a)")
  
  ## Plot distribution of slopes with varying biomass estimate for each group, where we do not assume biomass is equally distributed for each group in log10 order of magnitude bins
  hist2 <- ggplot(distn_biom_sensitivity, aes(slope)) + 
    geom_histogram(binwidth = .005, col="black", fill = "darkgray",size=0.5,position="identity")+
    theme_bw()+theme(axis.text = element_text(size = 24),
                     plot.subtitle = element_text(size = 24),
                     axis.title = element_text(size = 24),
                     panel.border = element_rect(size = 1),
                     axis.ticks = element_line(size = 1),
                     legend.position = "none")+
    geom_vline(xintercept = mean(distn_biom_sensitivity$slope), col = "darkred", size = 1)+
    ylab('Frequency') + 
    xlab('Global Biomass Spectrum Slope')+ xlim(min(c(mean_biom_sensitivity$slope, distn_biom_sensitivity$slope)), max(c(mean_biom_sensitivity$slope, distn_biom_sensitivity$slope)))+
    labs(subtitle = "b)")
  
  
  ggsave(filename = paste("./figures/suppfig7_frequency_sensitivity_", save_ref, ".png", sep = ''), plot = ggarrange(plots = list(hist1,hist2), ncol = 2), width = 16, height = 7)
  
  
  ## Calculate 95% confidence interval for each size class in abundance size spectrum
  print("Calculating 95% confidence interval for global abundance spectrum")
  weight_mat <- matrix(x, nrow = dim(distn_biom_sensitivity)[1], ncol = length(x), byrow = TRUE)
  abund_mat1 <- abund_mat2 <- weight_mat*NA
  
  for(i in 1:dim(weight_mat)[1]){
    abund_mat1[i,] <- mean_biom_sensitivity[i,"intercept"] + (mean_biom_sensitivity[i,"slope"]-1)*x
    abund_mat2[i,] <- distn_biom_sensitivity[i,"intercept"] + (distn_biom_sensitivity[i,"slope"]-1)*x
  }
  
  lower_ci <- apply(abund_mat1, 2, mean) - 1.96*apply(abund_mat1, 2, sd)
  upper_ci <- apply(abund_mat1, 2, mean) + 1.96*apply(abund_mat1, 2, sd)
  
  mean_abund_ci <- data.frame("log10_BodySize" = x, "lower_95" = lower_ci, "upper_95" = upper_ci)
  write.csv(mean_abund_ci, paste("./output/summary_output/sensitivity_analysis/abundance_spectrum_ci/mean_abund_ci_", save_ref, ".csv", sep = ""), row.names = FALSE)
  
  lower_ci <- apply(abund_mat2, 2, mean) - 1.96*apply(abund_mat2, 2, sd)
  upper_ci <- apply(abund_mat2, 2, mean) + 1.96*apply(abund_mat2, 2, sd)
  
  distn_abund_ci <- data.frame("log10_BodySize" = x, "lower_95" = lower_ci, "upper_95" = upper_ci)
  write.csv(distn_abund_ci, paste("./output/summary_output/sensitivity_analysis/abundance_spectrum_ci/distn_abund_ci_", save_ref, ".csv", sep = ""), row.names = FALSE)
  
}
