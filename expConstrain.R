expConstrain <- function(len, targetMean, minITI=0, maxITI=100000000, increment=1) {
  sampVec <- round(rexp(len, 1/targetMean), 0)
  if (increment != 1) sampVec <- sapply(sampVec, function(x) {
    return(x - x %% increment) })
  
  iterator <- 0  
  
  while (mean(sampVec) != targetMean ||
           any(sampVec < minITI) ||
           any(sampVec > maxITI)) {
    sampVec <- round(rexp(len, 1/targetMean), 0)
    if (increment != 1) sampVec <- sapply(sampVec, function(x) {
      return(x - x %% increment) })
    iterator <- iterator + 1
    if (iterator %% 10000 == 0) cat("On iteration: ", iterator, "\n")        
  }
  return(sampVec)
}