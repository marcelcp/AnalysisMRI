library(NeatMap)
source("train.R")
source("readfile.R")

postProcessing <- function(zplane,activity){
    slice = activity [, ,zplane]
    
    slice[slice < 10] = 0
    slice[slice > 100] = 100
    
    return(slice) + scale_fill_gradient(low = "black", high = "white")
}
