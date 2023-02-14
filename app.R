library(shiny)
library(leaflet)

# df <- read.csv(file="~/SpeciesMap/data/filteredPolandClean.csv",
#                header=TRUE,
#                sep=",")
df <- arrow::read_parquet("~/SpeciesMap/data/transformed.parquet") %>%
    dplyr::filter(year == 2019)

ui <- bootstrapPage(
  #front end
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", 
                width = "100%", 
                height = "100%"),
  absolutePanel(bottom = 10, left = 10,
                sliderInput(
                  "day_month",
                  "Select Day of year",
                  min = as.Date("2019-01-01","%Y-%m-%d"),
                  max = as.Date("2019-12-31","%Y-%m-%d"),
                  value = c(as.Date("2019-01-01"),as.Date("2019-02-01")),
                  timeFormat="%Y-%m-%d"
                ))
)


server <- function(input, output, session) {
  #back end
  data_reactive <- reactive({
      df %>% tidyr::unite("sight_date",year,month,day,sep="-") %>% 
      dplyr::mutate(sight_date = as.Date(sight_date)) %>%
      dplyr::filter(sight_date > input$day_month[1], 
                    sight_date < input$day_month[2])
    
  })
  output$map <- renderLeaflet({
    leaflet(options = leafletOptions(preferCanvas = TRUE)) %>%
      addTiles() %>%
      fitBounds(lng1 = 14 ,lat1 = 48, lng2 = 25, lat2 = 55)
  })
  
  observe({
    leafletProxy("map", data=data_reactive()) %>%
      clearMarkers() %>%
      addMarkers(lng = ~decimalLongitude,
                 lat = ~decimalLatitude)
  })
  
}
# Run the application 
shinyApp(ui = ui, server = server)
