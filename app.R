library(shiny)
library(leaflet)
library(tidyverse)
library(reactlog)
library(svglite) # for shinyapps.io to install

#Load helper functions
source("utils/filter_data.R")

# Load modules
source("R/filterMod.R")
source("R/mapGen.R")
source("R/speciesSelected.R")
source("R/speciesArea.R")
source("R/timeLine.R")

#Load UI and SERVER
source("ui.R")
source("server.R")

# Run the application 
shinyApp(ui = ui, server = server)
