library(shiny)
library(datasets)
source("train.R")
source("neatmap.R")


shinyServer(
  function(input,output,session){
  
    output$myPlot <- renderPlot({
      
      activity <- train(input$bandwidth)
      
      slice <- postProcessing(input$zplane,activity)
      heatmap1(slice) 
      })
    
    output$voxelGraph <- renderPlot({
      plot(getLinear(getModelPoly(input$bandwidth,input$i,input$j,input$k)),which = 1)
      })
    
  })

