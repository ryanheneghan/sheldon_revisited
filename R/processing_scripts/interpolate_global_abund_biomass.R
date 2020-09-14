#################################################################################
## Script for Sheldon Revisited group biomass estimates
## Authors: Ian Hatton, Ryan Heneghan, Yinon Bar-On, Eric Galbraith
##
##################### PREDICT BIOMASS ###########################################
##
## THIS SCRIPT TAKES THE FITTED STATISTICAL MODEL FOR A GROUP, AND ESTIMATES 
## TOTAL BIOMASS OR ABUNDANCE (m2) and DENSITY (e.g. g m2) FOR 360X180 GLOBAL
## GRID 
#################################################################################

# stat_model: the statistical model
# xvars: environmental predictor variables
# grid_areas: area of 360x180 grid squares, in m2
# pred_dat: environmental predictor variable values for 360x180 grid
# other_xvar_name: if you need to add another predictor variable, specify it's name here
# other_xvar_val: specify values of other xvariable here
# over_depth: do you need an estimate over the water column? This will return total biomass/density over top 200m and entire water column
# int: calculate prediction or confidence interval. Not used at the moment.

pred_func <- function(stat_model, xvars, pred_dat, grid_areas, other_xvar_name = NA, other_xvar_val = NA, over_depth, int = 'confidence'){
  
  areas <- grid_areas
  
  if(over_depth == FALSE){
  ## Data frames for output, one for mean, one for upper limit of 95% CI, one for lower limit of 95% CI
  save_frame <- data.frame('lon' = pred_dat$Long, 'lat' = pred_dat$Lat, 'd1' = NA)
  
  curr_predd <- pred_dat[,xvars]
  
  if(is.na(other_xvar_name) == FALSE){
    curr_predd$`other_xvar_name` <- as.factor(other_xvar_val) 
  }
  
  ## Predict and save total in depth interval
  prediction <- predict(stat_model, curr_predd, interval = int)
  save_frame[,3]<- (10^as.numeric(prediction[,'fit']))

  ## Calculate densities in m2
  save_frame$density <- save_frame[,3]
  save_frame$total <- save_frame$density*areas # Calculate total in each 1x1 grid square
  
  return(list("total" = save_frame$total, 
              "density" = save_frame$density))
  
  }
  
  if(over_depth == TRUE){
    ## For calculating total biomass across the water column, split water column into 8 blocks
    r_top <- c(0, 10, 20, 50, 100, 200, 400, 2000) # Top depth of blocks
    r_bottom <- c(10, 20, 50, 100, 200, 400, 2000, 10000) # Bottom depth of blocks
  r_mean <- log10((r_bottom - r_top)/2) # Mean depth within blocks
  
  ## Data frames for output, one for mean, one for upper limit of 95% CI, one for lower limit of 95% CI
  save_frame <-  data.frame('lon' = pred_dat$Long, 'lat' = pred_dat$Lat, 'd1' = NA, 'd2' = NA, 'd3' = NA, 'd4' = NA,
                                                                   'd5' = NA, 'd6' = NA, 'd7' = NA, 'd8' = NA)
  
  for(i in 1:length(r_top)){ # Loop over depth blocks
    curr_top <- r_top[i] # Current depth block top
    curr_bot <- r_bottom[i] # Current depth block bottom
    
    curr_pred <- pred_dat # Copy prediction frame for current depth block
    curr_pred$logdepth <- NA # Clear logdepth
    curr_pred$depth_int <- NA # Clear depth
    
    # For depths greater than current max depth, assign mean depth of current block,
    # and total depth of block
    curr_pred[which(c(curr_pred$BATHY - curr_bot) > 0), 'logdepth'] <- r_mean[i]
    curr_pred[which(c(curr_pred$BATHY - curr_bot) > 0), 'depth_int'] <- curr_bot - curr_top
    
    # For depths greater than current min depth and less than current max depth, assign depth as mean
    # of current min depth and current actual depth, and depth interval as current actual depth minus
    # current min depth
    curr_ints <- which(c(curr_pred$BATHY - curr_bot) < 0 & c(curr_pred$BATHY - curr_top) > 0)
    
    if(length(curr_ints) > 0){
      curr_pred[curr_ints, 'logdepth'] <- (log10(curr_pred[curr_ints, 'BATHY'])+log10(curr_top))/2
      curr_pred[curr_ints, 'depth_int'] <- curr_pred[curr_ints, 'BATHY']-log10(curr_top)
    }
    
    depth_int <- curr_pred$depth_int
    
    curr_predd <- curr_pred[,xvars]
    
    if(is.na(other_xvar_name) == FALSE){
      curr_predd[,other_xvar_name] <- as.factor(other_xvar_val) 
    }
    
    ## Predict and save total in depth interval
    prediction <- predict(stat_model, curr_predd, interval = int)
    save_frame[,(i+2)]<- (10^as.numeric(prediction[,'fit']))*depth_int
  }
  
  
  ## Calculate densities in m2
  save_frame$density <- rowSums(save_frame[,-c(1,2)],na.rm =TRUE) # Sum up over all depths to get density m^-2
  save_frame$total <- save_frame$density*areas # Calculate total in each 1x1 grid square
  
  ## Calculate densities in m2 in top 200m
  save_frame$density_top200 <- rowSums(save_frame[,c(3:7)],na.rm =TRUE) # Sum up over 0-200m depths to get density m^-2
  save_frame$total_top200 <- save_frame$density_top200*areas # Calculate total in each 1x1 grid square
  
  return(list("total" = save_frame$total, 
              "density" = save_frame$density,
              "total_top200" = save_frame$total_top200,
              "density_top200" = save_frame$density_top200))

  }
  
}




