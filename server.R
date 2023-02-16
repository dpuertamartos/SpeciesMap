df <- arrow::read_parquet("~/SpeciesMap/data/transformed.parquet") 

server <- function(input, output, session) {
  #back end
  
  #this module generates filters and receives the filters imposed (years, sci_name and vern_name)
  filters_response <- filter_server("filters", df = df)
  
  #this initiates leaflet map and leaflet proxy for grouping markers and showing circles
  #this also receives a response from the map that includes map_bounds and map_marker_click
  response_from_map <- map_server("map_generator", df = df,
                             year_input = reactive({filters_response$years()}), 
                             sci_input = reactive({filters_response$sci_name()}), 
                             vern_input = reactive({filters_response$vern_name()}))
  
  #create timeseries using time_line_module
  timeline_server("timeline_graph", 
                  df = df, 
                  year_input = reactive({filters_response$years()}), 
                  sci_input = reactive({filters_response$sci_name()}), 
                  vern_input = reactive({filters_response$vern_name()}))
  
  #data to use to generate the gt table
  species_in_area_server("species_area_graph",
                         df = df, 
                         year_input = reactive({filters_response$years()}), 
                         sci_input = reactive({filters_response$sci_name()}), 
                         vern_input = reactive({filters_response$vern_name()}),
                         map_bounds = reactive({response_from_map$map_bounds()}))
  

  #this module allows user to click a marker and obtain information
  marker_info_server("marker_selected_info",
                     df = df,
                     map_marker_click = reactive({response_from_map$map_marker_click()}))
  


}