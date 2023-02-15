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
  
  df_bounds <- reactive({
    if (is.null(input$map_bounds))
      return(df[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(df_react(),
           decimalLatitude >= latRng[1] & decimalLatitude <= latRng[2] &
             decimalLongitude >= lngRng[1] & decimalLongitude <= lngRng[2])
  })
  
  output$species_in_area <- gt::render_gt({
    df_bounds() %>%
      select(species_list) %>%
      separate_rows(species_list,sep = ",") %>%
      count(species_list,sort=T,name = "Count") %>%
      slice_max(Count,n=8) %>%
      rename("Species" = "species_list") %>%
      gt::gt() %>%
      gt::tab_options(table.font.size = "12pt",heading.title.font.size = "14pt") %>%
      gt::tab_header(title = "Most frequent observations in area") %>%
      gtExtras::gt_plt_bar(column = Count,color = "darkblue",scale_type = "number")
  })
  
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
  
  output$species_list_text <- renderUI({
    if(!is.null(input$map_marker_click)){
      
      
      #select the observation in the df with the id associated to the marker in the map
      observation_selected <- df %>%
        filter(id == input$map_marker_click$id) 
      
      #when we have the observation selected, when can extract different info
      #the scientific name of the species observed
      species_list <- observation_selected %>%
        select(species_list) 
      
      #extracting the common name of the species observed
      vernacular_list <- observation_selected %>%
        select(vernacular_name) 
      
      #extracting the common name of the species observed
      number_of_animals <- observation_selected %>%
        select(species_count)
      
      #dom construction to render as HTML when user clicks
      header <- glue::glue("<div class='species_list_header'> Showing info of observation {input$map_marker_click$id}: <br></div>")
      species_list <- paste(header,"<div class='species_item'>Species: ",species_list,"</div>",
                            "<div class='vernacular_item'> Common name: ",vernacular_list,"</div>",
                            "<div class='count_item'> Number of individuals: ",number_of_animals,"</div>",
                            collapse='')
      
      #return the dom construction
      return(HTML(species_list))
    }else{
      HTML("<span> Click on a marker to see which species was observed </span>")
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