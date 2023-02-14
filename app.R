library(shiny)
library(leaflet)

df <- read.csv(file="~/SpeciesMap/data/filteredPoland.csv",
               nrows=5000,
               skip=0,
               header=TRUE,
               sep=",")
# df <- arrow::read_parquet("~/SpeciesMap/data/filteredPoland.parquet") 
print(head(df))

ui <- bootstrapPage(
  #front end
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", 
                width = "100%", 
                height = "100%"),
)


server <- function(input, output, session) {
  #back end
  output$map <- renderLeaflet({
    leaflet(data=df, options = leafletOptions(preferCanvas = TRUE)) %>%
      addTiles() %>%
      addMarkers(~longitudeDecimal, 
                 ~latitudeDecimal)
  })
  
}
# Run the application 
shinyApp(ui = ui, server = server)
