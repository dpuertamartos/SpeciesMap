library(shiny)
library(leaflet)

# df <- read.csv(file="~/SpeciesMap/data/filteredPolandClean.csv",
#                header=TRUE,
#                sep=",")
df <- arrow::read_parquet("~/SpeciesMap/data/transformed.parquet") %>%
    dplyr::filter(year == 2020)

ui <- bootstrapPage(
  #front end
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", 
                width = "100%", 
                height = "100%"),
  absolutePanel(bottom = 10, right = 10,
                sliderInput(
                  "day_month",
                  "Select Day of year",
                  min = as.Date("2020-01-01","%Y-%m-%d"),
                  max = as.Date("2020-12-31","%Y-%m-%d"),
                  value = c(as.Date("2020-01-01"),as.Date("2020-12-31")),
                  timeFormat="%Y-%m-%d"
                ))
)


server <- function(input, output, session) {
  #back end
  output$map <- renderLeaflet({
    leaflet(data=df, options = leafletOptions(preferCanvas = TRUE)) %>%
      addTiles() %>%
      addMarkers(~decimalLongitude, 
                 ~decimalLatitude)
  })
  
}
# Run the application 
shinyApp(ui = ui, server = server)
