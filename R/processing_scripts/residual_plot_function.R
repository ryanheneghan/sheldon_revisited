#################################################################################
## Script for Sheldon Revisited group biomass estimates
## Authors: Ian Hatton, Ryan Heneghan, Yinon Bar-On, Eric Galbraith
##
############# MAIN EFFECTS AND PARTIAL RESIDUAL PLOTS ###########################
##
## THIS SCRIPT TAKES THE FITTED STATISTICAL MODEL FOR A GROUP, AND PLOTS  
## THE MAIN EFFECTS WITH PARTIAL RESIDUALS
#################################################################################

# model: the statistical model
# xvar: independent variable whose main effect and partial residuals you are plotting
# xlab: xlabel for plot
# ylab: ylabel for plot
# subtitle: subtitle for plot
# new_xticks: if you're specifying xtick labels, do so here. This is only used for 
#             non-rhizaria mesozooplankton BiomassMethod plot


require(ggplot2)
require(visreg)

resid_plot <- function(model, xvar, xlab, ylab, subtitle, new_xticks = NA){
  
  mfit <- visreg(model,xvar,plot = FALSE)
  mfit_line <- mfit$fit
  mfit_res <- mfit$res
  
  if(is.na(new_xticks[1]) == TRUE){
  tt = ggplot() + geom_point(data = mfit_res, aes(x=!!ensym(xvar), y = visregRes), col = "darkgrey", alpha = 0.5)+
      geom_line(data = mfit_line, aes(x=!!ensym(xvar), y = visregFit), col = "darkred", size = 2) + 
    geom_ribbon(data = mfit_line, aes(x = !!ensym(xvar), ymin = visregLwr, ymax = visregUpr), fill = "darkred", alpha = .5)+
    theme_bw()+
    theme(axis.text = element_text(size = 24),
          plot.subtitle = element_text(size = 24),
          axis.title = element_text(size = 24),
          panel.border = element_rect(size = 1),
          axis.ticks = element_line(size = 1),
          legend.position = "none")+labs(subtitle = subtitle)+ylab(ylab) + xlab(xlab)
  }
  
  if(!is.na(new_xticks[1]) == TRUE){
  curr_ticks = levels(mfit_line[,xvar])
  tt = ggplot(data = mfit_res, aes(x=!!ensym(xvar), y = visregRes)) + geom_jitter(position = position_jitter(0.3), col = "darkgrey", alpha = 0.5)+
    stat_summary(fun=median,  geom="crossbar", color="darkred", size = 0.8)+ 
    scale_x_discrete(breaks = curr_ticks, labels = new_xticks)+
    theme_bw()+
    theme(axis.text = element_text(size = 24),
          axis.text.x = element_text(size = 20, angle = 20, hjust = 1),
          plot.subtitle = element_text(size = 24),
          axis.title = element_text(size = 24),
          panel.border = element_rect(size = 1),
          axis.ticks = element_line(size = 1),
          legend.position = "none")+labs(subtitle = subtitle)+ylab(ylab) + xlab(xlab)
  }
  
  
  
  return(tt)
  
}
