library(shiny)
library(leaflet)
library(tidyverse)
library(reactlog)
library(svglite) # for shinyapps.io to install

# Load essential components
source("R/species_in_area_module.R")
source("R/time_line_module.R")
source("server/filter_data.R")
source("ui/conditional_input_filter.R")
source("ui/ui.R")
source("server/server.R")
# source("utils/utils.R")

# Run the application 
shinyApp(ui = ui, server = server)
