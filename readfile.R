library(fmri)
path<-("bold1.nii") 
data = read.NIFTI(path) 

getMask <- function(){
  mask = data$mask
  return(mask)
}

getActivity <- function(mask){
  # use getwd() in console to get the path
  # load the data  
  
  
  # extract mask from NIFTI file  
   
  
  # denote activity = mask, arbitrarily (used later)  
  activity = mask
  return(activity)
}

getVoxels <- function(){
  
  
  # extract voxel intensities  
  voxels = extract.data(data) 
  
  return(voxels)
}

