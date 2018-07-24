# Define server logic required to summarize and view the selected dataset
library(shiny)
shinyUI(
  pageWithSidebar(
    headerPanel("Voxel Activity Prediction"),
    
    sidebarPanel(
      
      sliderInput("bandwidth","Please Select Bandwith: ",
                  min=5,max =35,value = 35, step=5),
                  #min=5,max =15,value = 5, step=5),
      
      sliderInput("zplane","Please Select z plane: ",
                  min=1,max=33,value = 16, step=1),
      
      sliderInput("i","I value",
                  min=1,max =64,value = 1, step=1),
      sliderInput("j","J value",
                  min=1,max =64,value = 1, step=1),
      sliderInput("k","K value",
                  min=1,max =33,value = 1, step=1),
      conditionalPanel(condition = "input.Distribution == 'Normal' ",
                       textInput("Mean", "", 0))
      
    ),
    
    mainPanel(
      plotOutput("myPlot"),
      plotOutput("voxelGraph")
    )
  )
)
