df <- arrow::read_parquet("~/SpeciesMap/data/transformedMultimedia.parquet") 

server <- function(input, output, session) {
  #back end
  
  #this module generates filters and receives the filters imposed (years, sci_name and vern_name)
  filters_response <- filterModServer("filters", df = df)
  
  # create a reactive expression that filters the data frame based on the selected filters
  
  data <- reactive({ filter_data(df, filters_response$years(), filters_response$sci_name(), filters_response$vern_name()) })
  
  #this initiates leaflet map and leaflet proxy for grouping markers and showing circles
  #this also receives a response from the map that includes map_bounds and map_marker_click
  response_from_map <- mapGenServer("map_generator", df = data)
  
  #create timeseries using time_line_module
  timeLineServer("timeline_graph", 
                  df = data, 
                  year_input = reactive({filters_response$years()}), 
                  sci_input = reactive({filters_response$sci_name()}), 
                  vern_input = reactive({filters_response$vern_name()}))
  
  #data to use to generate the gt table
  speciesAreaServer("species_area_graph",
                         df = data, 
                         map_bounds = reactive({response_from_map$map_bounds()}))
  

  #this module allows user to click a marker and obtain information
  speciesSelectedServer("marker_selected_info",
                     df = data,
                     map_marker_click = reactive({response_from_map$map_marker_click()}))
  

}