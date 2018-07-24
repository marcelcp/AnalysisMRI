library(fmri)

# use getwd() in console to get the path
# load the data  
path<-("bold1.nii") 
data = read.NIFTI(path) 

getMask <- function(){

  # extract mask from NIFTI file  
  mask = data$mask
  return(mask)
}

getActivity <- function(mask){
  
  # denote activity = mask, arbitrarily (used later)  
  activity = mask
  return(activity)
}

getVoxels <- function(){
  
  # extract voxel intensities  
  voxels = extract.data(data) 
  
  return(voxels)
}

