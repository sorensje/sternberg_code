ms_poisson_cutoffs_mean <-function(n_samples,target_mean,target_min,target_max,lambda){
  todraw <-rpois(1000,lambda)*1000
  todraw <-todraw +runif(1000,-500,500)
  todraw <- todraw[todraw>target_min]
  todraw <- todraw[todraw<target_max]
  todraw <- round(todraw,0)
  
  keepworking <- 1
  while(keepworking==1){
    potential_itis <- sample(todraw,n_samples,replace=TRUE)
    mean_potential_itis <- round(mean(potential_itis),0)
    
    if (mean_potential_itis>(target_mean-200) & mean_potential_itis<(target_mean+200)) (keepworking <- 0)
    
  }
  
  return(potential_itis)
  
}