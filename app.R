library(shiny)
library(leaflet)
library(tidyverse)
library(reactlog)
library(svglite) # for shinyapps.io to install

#Load helper functions
source("utils/filter_data.R")

# Load modules
source("R/filter_module.R")
source("R/map_generator.R")
source("R/species_selected.R")
source("R/species_in_area_module.R")
source("R/time_line_module.R")

#Load UI and SERVER
source("ui.R")
source("server.R")

# Run the application 
shinyApp(ui = ui, server = server)
