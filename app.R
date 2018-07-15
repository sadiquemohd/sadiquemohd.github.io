#  Purpose of this program is to use the interactive map to show the unemployment rate/1000 in india
#  Author : Sadique
# Used data set from india data.gov.in
#

library(shiny)
library(shiny)
library(leaflet)
library(dplyr)
library(tidyr)
library(tidyverse)
library(htmlwidgets)

fpath<-"F:/c9proj"
setwd(fpath)
df = read.table("India_unemp_rate_data.csv" , header=TRUE,  sep=",")
#Server function
server <- function(input,output, session){
  
  data <- reactive({
    x <- df
  })
  
  output$empratemap <- renderLeaflet({
    df <- data()
    #print(input$state_name)      
    # Get latitude and longitude
    if(input$state_name=="Ex: Goa"){
      ZOOM=2
      LAT=0
      LONG=0
      uemprt=0
    }else{
      state_pos<-subset(df, df$States==input$state_name)
      #print(head(state_pos))
      LAT<-state_pos$Lattitude
      LONG<-state_pos$Longitude
      uemprt <-state_pos$UnemploymentRate
     # print(LAT)
      #print(LONG)
      }    
    m<- leaflet() %>%
      addTiles() %>%
      setView(lng=LONG, lat=LAT, zoom=5 ) %>%
      addMarkers(lng = LONG,
                 lat = LAT,
                 popup = paste("State ", input$state_name, "<br>",
                               "Unemp.Rate:", uemprt))
    saveWidget(m,file="leaf_out3.html")
  })
}
ui <- fluidPage(
  leafletOutput("empratemap",height = 1000),
  absolutePanel(top=20, left=70, textInput("state_name", "" , "Ex: Goa"))
  
)  

# Run the application 
shinyApp(ui = ui, server = server)

