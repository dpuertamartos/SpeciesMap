##THIS MODULE IS IN CHARGE OF CREATING THE MAP

mapGenUI <- function(id){
  ns <- NS(id)
  tagList(
    leafletOutput(ns("map"), 
                  width = "100%", 
                  height = "100%"),
  )
}

mapGenServer <- function(id, df, year_input, sci_input, vern_input){
  moduleServer(
    id,
    function(input, output, session) {
      
      output$map <- renderLeaflet({
        leaflet(options = leafletOptions(preferCanvas = TRUE)) %>%
          addTiles() %>%
          fitBounds(lng1 = 14 ,lat1 = 48, lng2 = 25, lat2 = 55)
      })

      count_palet <- colorBin(palette = "Dark2",bins = c(0, 5, 10, 100, Inf) ,pretty=TRUE)

      observe({
        leafletProxy("map", data = filter_data(df, year_input(), sci_input(), vern_input())) %>%
          clearMarkerClusters() %>%
          clearShapes() %>%
          clearMarkers() %>%
          clearControls() %>%
          addMarkers(lng = ~decimalLongitude,
                     lat = ~decimalLatitude,
                     popup = ~paste("<span style='font-style: italic;'>", species_list, "</span>","<br>", 
                                     vernacular_name, "<br>", 
                                    "Number of individuals: ", species_count, "<br>", "<br>",
                                    "<img style='width: 256px; ' src='https://observation.org/photos/",accessURI,"' alt='No img available' >",
                                    "<br>","<br>",originalPhoto,
                                    sep = ""
                                    ),
                     
                     clusterOptions = markerClusterOptions(),layerId = ~id) %>%
          #would be nice to connect radius to observation radius
          addCircles(lng = ~decimalLongitude,
                     lat = ~decimalLatitude,
                     color = ~count_palet(species_count),
                     radius = 500
                     ) %>%
          addLegend("bottomleft", pal = count_palet, values = ~species_count,
                    title = "observed animals (n)",
                    opacity = 1
          )
      })
      
      #return the map bounds and map marker click so it can be accesed by other modules
      return(
        list(
          map_bounds = reactive({input$map_bounds}),
          map_marker_click = reactive({input$map_marker_click})
        )
      )
    }
  )
}