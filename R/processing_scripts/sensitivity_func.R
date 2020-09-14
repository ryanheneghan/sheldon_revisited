# Function to calculate slope and intercept sensitivity to changes in biomass of groups, and changes in distribution of biomass across
# each group's size range
sensitivity_func <- function(n = 10000, log_mean_biom = log10(glob_biom_all), log_se = log_se, var_biom = FALSE, sizes, x){
  
  out_store <- matrix(NA, nrow = n, ncol = 2)
  
  # Sample biomass distribution for each group, using log_mean and log_se of our estimates to define distribution
  glob_biom_ests <- matrix(NA, nrow = n, ncol = length(log_mean_biom))
  
  for(i in 1:length(log_mean_biom)){
    glob_biom_ests[,i] <- rnorm(n, mean = log_mean_biom[i], sd = log_se[i])
  }
  
  pb <- txtProgressBar(min = 0, max = n, style = 3)
  for(i in 1:n){
    setTxtProgressBar(pb, i)
    fracB <- sizes
    
    if(var_biom == TRUE){
      curr_glob_biom_all <- 10^glob_biom_ests[i,]
    }
    
    if(var_biom == FALSE){
      curr_glob_biom_all <- 10^log_mean_biom
    }
    
    for (j in 1:dim(fracB)[2]){
      num_bins <- sum(fracB[,j] > 0)
      curr_fracb <- runif(num_bins)
      fracB[c(fracB[,j] > 0),j]<- curr_fracb/sum(curr_fracb)
    }
    
    curr_b <- sweep(fracB, 2, curr_glob_biom_all, '*')
    
    out_store[i,1] <- (lm(log10(rowSums(curr_b)) ~ x))$coefficients[[1]]
    out_store[i,2] <- (lm(log10(rowSums(curr_b)) ~ x))$coefficients[[2]]
  }
  
  return(out_store)
  
}
