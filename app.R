library(shiny)
library(leaflet)


df <- arrow::read_parquet("~/SpeciesMap/data/transformed.parquet") 


print(head(df))
ui <- bootstrapPage(
  #front end
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", 
                width = "100%", 
                height = "100%"),
  absolutePanel(style = "max-width: 30%;background-color: rgba(255,255,255,0.7);padding: 0px 10px 0px 10px;border-radius: 10px",top = 10, right = 10,
                
                gt::gt_output("species_in_area"),
                
                selectizeInput("sci_name",
                               label = "Enter scientific Name",
                               choices = NULL,
                               multiple = FALSE,
                               width = "100%",
                               options = list(
                                 create = FALSE,
                                 placeholder = "Grus grus",
                                 maxItems = '1',
                                 onDropdownOpen = I("function($dropdown) {if (!this.lastQuery.length) {this.close(); this.settings.openOnFocus = false;}}"),
                                 onType = I("function (str) {if (str === \"\") {this.close();}}"))),
                
                selectizeInput("vern_name",
                               label = "Enter common Name",
                               choices = NULL,
                               multiple = FALSE,
                               width = "100%",
                               options = list(
                                 create = FALSE,
                                 placeholder = "Common Crane",
                                 maxItems = '1',
                                 onDropdownOpen = I("function($dropdown) {if (!this.lastQuery.length) {this.close(); this.settings.openOnFocus = false;}}"),
                                 onType = I("function (str) {if (str === \"\") {this.close();}}"))),
                sliderInput(
                  "years",
                  "Select years",
                  min = as.integer("1984"),
                  max = as.integer("2020"),
                  value = c(as.integer("2019"),as.integer("2020")),
                  step = 1,
                  ticks = FALSE,
                  width = "90%"
                  )
                
                ),
  
  absolutePanel(top = 10, left = 500,
                style="background-color: rgba(255,255,255,0.7);padding: 10px 30px 10px 30px;border-radius: 20px;",
                htmlOutput("species_list_text", style = "margin-bottom: 10px; margin-top: 10px;"),
                ),
)


server <- function(input, output, session) {
  #back end
  # data to use to generate the gt table
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
      gt::tab_header(title = "Most observed species in area") %>%
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
  
  output$species_list_text <- renderUI({
    if(!is.null(input$map_marker_click)){

      
      #select the observation in the df with the id associated to the marker in the map
      observation_selected <- df %>%
        filter(id == input$map_marker_click$id) 
      
      #when we have the observation selected, when can extract different info
      #the scientific name of the species observed
      species_list <- observation_selected %>%
        select(species_list) %>%
        unlist() %>%
        paste(collapse = "</span><span class='species_item'>")
      
      #extracting the common name of the species observed
      vernacular_list <- observation_selected %>%
        select(vernacular_name) %>%
        unlist() %>%
        paste(collapse = "</span><span class='vernacular_item'>")
      
      #dom construction to render as HTML when user clicks
      header <- glue::glue("<span class='species_list_header'> You selected observation {input$map_marker_click$id}, species: <br></span>")
      species_list <- paste(header,"<span class='species_item'>",species_list,"</span>",
                            "<span class='species_item'>",vernacular_list,"</span>"
                            ,collapse='')
      
      #return the dom construction
      return(HTML(species_list))
    }else{
      HTML("<span> Click on a marker to see which species was observed </span>")
    }
  })
  
  df_react <- reactive({
    #filter dataframe with selected years
    base <- df %>%
      dplyr::filter(year >= input$years[1],
                    year <= input$years[2])
    
    #if there's a filter active for scientific name, filter dataframe
    if(!is.null(input$sci_name) & input$sci_name != ""){
      print(input$sci_name)
      base <- base %>%
               filter(str_detect(species_list,input$sci_name))
    }
    #if there's a filter active for vernacular name, filter dataframe
    if(!is.null(input$vern_name) & input$vern_name != ""){
      print(input$vern_name)
      base <- base %>%
        filter(str_detect(vernacular_name,input$vern_name))
    }
    #return dataframe with selected filters applied
    return(base)
  })
  
  count_palet <- colorBin(palette = "Dark2",bins = 3,pretty=TRUE,
                          domain = range(df$species_count))
  
  observe({
    leafletProxy("map", data = df_react()) %>%
      clearMarkerClusters() %>%
      clearShapes() %>%
      clearMarkers() %>%
      clearControls() %>%
      addMarkers(lng = ~decimalLongitude,
                 lat = ~decimalLatitude,
                 clusterOptions = markerClusterOptions(),layerId = ~id) %>%
      addCircles(lng = ~decimalLongitude,
                 lat = ~decimalLatitude,
                 color = ~count_palet(species_count),
                 radius = ~species_count) %>%
      addLegend("bottomright", pal = count_palet, values = ~species_count,
                title = "Observations (n)",
                opacity = 1
      )
  })
  
}
# Run the application 
shinyApp(ui = ui, server = server)
