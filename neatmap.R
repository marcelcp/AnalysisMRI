library(NeatMap)
source("train.R")
source("readfile.R")

postProcessing <- function(zplane,activity){
    slice = activity [, ,zplane]
    
    slice[slice < 10] = 0
    slice[slice > 300] = 300
    
    return(slice) + scale_fill_gradient(low = "black", high = "white")
}
