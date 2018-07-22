library(locfit)
source("readfile.R")

# define various parameters 
I = 64 
J = 64 
K = 33
L = 210

# randomly select 80% as training data the other 20% will be validation data 
index = 1:210 
per = round(210 * 0.8)

index_train = sample(index, per) 
index_valid = index[-index_train]
mask <- getMask()
activity <- getActivity(mask)

voxels <- getVoxels()

getModelPoly <- function(h,i,j,k){
  y = voxels[i, j, k, index] 
  #print(head(y))
  x = (1:L)
  
  # fit local polynomial model with specified bandwidth 
  model = locfit(y ~ lp(x, deg = 2, h = h))
  return(model)
}

getLinear <- function(modelPoly){
  x = (1:L)
  predictions = predict(modelPoly, x)
  
  # fit linear model 
  model = lm(predictions ~ x)
  return(model)
}

train <- function(bandwidth){
  print(head(voxels))
  
  # we choose bandwidth 15 
  h = bandwidth
  
  
  # iterate over all voxels 
  for (i in 1:I) { 
    for (j in 1:J) { 
      for (k in 1:K) {
        
        # if mask == TRUE 
        if (mask[i, j, k]) {
          
          # 210 observations to train from 
          y = voxels[i, j, k, index] 
          #print(head(y))
          x = (1:L)
          
          # fit local polynomial model with specified bandwidth 
          model_poly = locfit(y ~ lp(x, deg = 2, h = h))
          
          # generate predictions for all 210 time points 
          predictions = predict(model_poly, x)
          
          # fit linear model 
          model_linear = lm(predictions ~ x)
          
          # we measure activity as the MSE between local polynomial and linear model 
          activity[i, j, k] = mean((predictions - predict(model_linear, data.frame(x)))^2)
          #print(summary(activity))
         
        }
      }
    }
  }
  return(activity)
}


getTrainedActivity <- function(){
  return(activity)
}
