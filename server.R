library(shiny)
library(datasets)
source("train.R")
source("neatmap.R")
# use getwd() in console to get the path
# load the data  
#path<-("bold1.nii") 
#data = read.NIFTI(path) 

# extract voxel intensities  
#voxels = extract.data(data) 

# extract mask from NIFTI file  
#mask = data$mask 

# denote activity = mask, arbitrarily (used later)  
#activity = mask 



shinyServer(
  function(input,output,session){
    

    output$myPlot <- renderPlot({
      
      activity <- train(input$bandwidth)
      
      #print(input$bandwidth)
      #print(input$zplane)
      
      
      slice <- postProcessing(input$zplane,activity)
      heatmap1(slice) 
      })
    
    output$voxelGraph <- renderPlot({
      plot(getLinear(getModelPoly(input$bandwidth,input$i,input$j,input$k)),which = 1)
    })
    
  })