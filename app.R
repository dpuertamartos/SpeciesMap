library(shiny)
library(leaflet)
library(tidyverse)
library(reactlog)
library(svglite) # for shinyapps.io to install

# Load essential components
source("ui/ui.R")
source("server/server.R")
# source("utils/utils.R")

# Run the application 
shinyApp(ui = ui, server = server)
