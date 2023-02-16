df <- arrow::read_parquet("~/SpeciesMap/data/transformed.parquet") 

server <- function(input, output, session) {
  #back end
  df_react <- reactive({
    filter_data(df, input$years, input$sci_name, input$vern_name)
  })
  
  #create timeseries using time_line_module
  timeline_server("timeline_graph", 
                  df = df, 
                  year_input = reactive({input$years}), 
                  sci_input = reactive({input$sci_name}), 
                  vern_input = reactive({input$vern_name}))
  
  #data to use to generate the gt table
  species_in_area_server("species_area_graph",
                         df = df, 
                         year_input = reactive({input$years}), 
                         sci_input = reactive({input$sci_name}), 
                         vern_input = reactive({input$vern_name}),
                         map_bounds = reactive({input$map_bounds}))
  

  #this module allows user to click a marker and obtain information
  marker_info_server("marker_selected_info",
                     df = df,
                     map_marker_click = reactive({input$map_marker_click}))
  

  #this initiates leaflet map
  output$map <- renderLeaflet({
    leaflet(options = leafletOptions(preferCanvas = TRUE)) %>%
      addTiles() %>%
      fitBounds(lng1 = 14 ,lat1 = 48, lng2 = 25, lat2 = 55)
  })
  
  
  #scientific name filter reactive
  sci_name_choices <- reactive({
    base <- df %>% select(species_list) %>% unlist()
    names(base) <- base
    
    if(is.null(input$sci_name) | input$sci_name == ""){
      return(base)
    }
    base[str_detect(base,input$sci_name)]
  })
  
  #vern name filter options reactive
  vern_name_choices <- reactive({
    base <- df %>% select(vernacular_name) %>% unlist()
    names(base) <- base
    
    if(is.null(input$vern_name) | input$vern_name == ""){
      return(base)
    }
    base[str_detect(base,input$vern_name)]
  })
  
  #update choices of the filters in frontend
  isolate({
    updateSelectizeInput(session,"sci_name",server = TRUE,choices = sci_name_choices())
    updateSelectizeInput(session,"vern_name",server = TRUE, choices = vern_name_choices())
  })
  
  #this observes the filter type selected, to erase the value of the opposite filter
  observeEvent(input$filter_type, {
    if (input$filter_type == "sci_name") {
      updateSelectizeInput(session, "vern_name", selected = "")
    } else if (input$filter_type == "vern_name") {
      updateSelectizeInput(session, "sci_name", selected = "")
    }
  })
  

  

  count_palet <- colorBin(palette = "Dark2",bins = c(0, 5, 10, 100, Inf) ,pretty=TRUE)
  
  observe({
    leafletProxy("map", data = df_react()) %>%
      clearMarkerClusters() %>%
      clearShapes() %>%
      clearMarkers() %>%
      clearControls() %>%
      addMarkers(lng = ~decimalLongitude,
                 lat = ~decimalLatitude,
                 clusterOptions = markerClusterOptions(),layerId = ~id) %>%
      #would be nice to connect radius to observation radius
      addCircles(lng = ~decimalLongitude,
                 lat = ~decimalLatitude,
                 color = ~count_palet(species_count),
                 radius = 500) %>%
      addLegend("bottomleft", pal = count_palet, values = ~species_count,
                title = "observed animals (n)",
                opacity = 1
      )
  })
  
}