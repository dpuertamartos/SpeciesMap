library(shiny)
library(leaflet)
library(tidyverse)
library(reactlog)
library(svglite) # for shinyapps.io to install

# Load modules
source("R/species_selected.R")
source("R/species_in_area_module.R")
source("R/time_line_module.R")

#Load functions
source("server/filter_data.R")
source("ui/conditional_input_filter.R")

#Load UI and SERVER
source("ui/ui.R")
source("server/server.R")
# source("utils/utils.R")

# Run the application 
shinyApp(ui = ui, server = server)
