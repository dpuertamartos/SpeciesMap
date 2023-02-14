library(shiny)
library(leaflet)

# df <- read.csv(file="~/SpeciesMap/data/filteredPolandClean.csv",
#                header=TRUE,
#                sep=",")
df <- arrow::read_parquet("~/SpeciesMap/data/transformed.parquet") %>%
    dplyr::filter(year == 2019)

print(head(df))
ui <- bootstrapPage(
  #front end
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", 
                width = "100%", 
                height = "100%"),
  absolutePanel(style = "max-width: 30%;background-color: rgba(255,255,255,0.7);padding: 0px 10px 0px 10px;border-radius: 10px",top = 10, right = 10,
                gt::gt_output("species_in_area"),
                htmlOutput("species_list_text")),
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
  # data to use to generate the gt table
  df_bounds <- reactive({
    if (is.null(input$map_bounds))
      return(df[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(df,
           decimalLatitude >= latRng[1] & decimalLatitude <= latRng[2] &
             decimalLongitude >= lngRng[1] & decimalLongitude <= lngRng[2])
  })
  
  output$species_in_area <- gt::render_gt({
    df_bounds() %>%
      select(species_list) %>%
      separate_rows(species_list,sep = ",") %>%
      count(species_list,sort=T,name = "Count") %>%
      slice_max(Count,n=5) %>%
      rename("Species" = "species_list") %>%
      gt::gt() %>%
      gt::tab_options(table.font.size = "12pt",heading.title.font.size = "14pt") %>%
      gt::tab_header(title = "Most observed species in area") %>%
      gtExtras::gt_plt_bar(column = Count,color = "darkblue",scale_type = "number")
  })
  
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
