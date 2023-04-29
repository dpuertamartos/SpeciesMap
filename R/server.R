<<<<<<< HEAD
initial_df <- arrow::read_parquet("data/transformedMultimediaCentro.parquet")
=======
df <- arrow::read_parquet("data/transformedMultimedia.parquet") 
>>>>>>> master

server <- function(input, output, session) {
  #back end
  
  df <- reactive({
    print("reading new parquet...")
    dataset_path <- switch(input$dataset_size,
                           "sur" = "data/transformedMultimediaSur.parquet",
                           "centro" = "data/transformedMultimediaCentro.parquet",
                           "norte" = "data/transformedMultimediaNorte.parquet",
                           "este" = "data/transformedMultimediaEste.parquet",
                           "canarias" = "data/transformedMultimediaCanarias.parquet"
                           )
    arrow::read_parquet(dataset_path)
  })
  
  # Initialize data_rv
  data_rv <- reactiveVal(filter_data(initial_df,
                                     NULL,
                                     NULL,
                                     NULL,
                                     NULL))
  
  
  #this initiates leaflet map and leaflet proxy for grouping markers and showing circles
  #this also receives a response from the map that includes map_bounds and map_marker_click
  response_from_map <- mapGenServer("map_generator", df = data_rv)
  
  prev_map_bounds <- reactiveVal(NULL)
  
  # if filters are changed update data
  observeEvent(list(filters_response$years(), filters_response$sci_name(), filters_response$vern_name(), input$dataset_size), {
    print("updating data due to filter change")
    new_data <- filter_data(df(),
                            filters_response$years(),
                            filters_response$sci_name(),
                            filters_response$vern_name(),
                            response_from_map$map_bounds()) # Use the current map_bounds
    data_rv(new_data)
    initial_df <- NULL
  }, ignoreInit = TRUE)
  
  ## if map bounds are changed refilter dataframe if more than 45% change
  observeEvent(response_from_map$map_bounds(), {
    new_map_bounds <- response_from_map$map_bounds()
    
    if (is.null(prev_map_bounds())) {
      prev_map_bounds(new_map_bounds)
      return()
    }
    
    # Calculate the difference in latitude and longitude
    lat_diff <- abs(new_map_bounds$north - prev_map_bounds()$north) + abs(new_map_bounds$south - prev_map_bounds()$south)
    lng_diff <- abs(new_map_bounds$east - prev_map_bounds()$east) + abs(new_map_bounds$west - prev_map_bounds()$west)
    
    # Calculate the total movement percentage
    lat_percentage <- lat_diff / (prev_map_bounds()$north - prev_map_bounds()$south)
    lng_percentage <- lng_diff / (prev_map_bounds()$east - prev_map_bounds()$west)
    
    # Check if the movement exceeds the threshold (45%)
    if (lat_percentage > 0.45 || lng_percentage > 0.45) {
      print("updating data")
      new_data <- filter_data(df(),
                              filters_response$years(),
                              filters_response$sci_name(),
                              filters_response$vern_name(),
                              new_map_bounds) # Use the current map_bounds
      data_rv(new_data) # Update the reactive value with the new data
      prev_map_bounds(new_map_bounds)
      initial_df <- NULL
    }
  }, ignoreInit = TRUE)
  
  #this module generates filters and receives the filters imposed (years, sci_name and vern_name)
  filters_response <- filterModServer("filters", df = data_rv)
  
  #create timeseries using time_line_module
  # timeLineServer("timeline_graph", 
  #                df = data_rv, 
  #                year_input = reactive({filters_response$years()}), 
  #                sci_input = reactive({filters_response$sci_name()}), 
  #                vern_input = reactive({filters_response$vern_name()}))
  
  #this module allows user to click a marker and obtain information
  speciesSelectedServer("marker_selected_info",
                        df = data_rv,
                        map_marker_click = reactive({response_from_map$map_marker_click()}))
  
  speciesAreaServer("species_area_graph",
                    df = data_rv)
}


<<<<<<< HEAD
=======
}
>>>>>>> master
