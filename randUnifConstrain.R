randUnifConstrain <- function(len, vals, targetMean) {
  sampVec <- sample(vals, len, replace=TRUE)
  
  while (mean(sampVec) != targetMean) sampVec <- sample(vals, len, replace=TRUE)
  
  return(sampVec)
}