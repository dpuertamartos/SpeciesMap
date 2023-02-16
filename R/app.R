library(shiny)
library(leaflet)
library(tidyverse)
library(reactlog)
library(svglite)
# for shinyapps.io to install

myApp <- function(...){
  # Run the application 
  shinyApp(ui = ui, server = server, ...)
}


