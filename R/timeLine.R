library(shiny)
library(dplyr)
library(ggplot2)

df <- arrow::read_parquet("~/SpeciesMap/data/transformed.parquet") 

##THIS MODULE IS IN CHARGE OF PLOTTING THE TIME SERIES!

timeLineUI <- function(id){
  ns <- NS(id)
  tagList(
    plotOutput(ns("timeline"),height = "200px")
  )
}

timeLineServer <- function(id, df, year_input, sci_input, vern_input){
  moduleServer(
    id,
    function(input, output, session) {
      
      timeline_plot <- reactive({
        ## first we filter the data using helper function filter_data 
        filter_data(df, year_input(), sci_input(), vern_input()) %>%
          ## then we convert it to the time series table
          group_by(year,species_list) %>%
          summarize(count = n()) %>%
          filter(rank(-count) <= 2) %>% 
          ggplot(aes(x = year, y = species_list, size = count)) +
          geom_point(color = "darkgreen") +
          scale_size_continuous(range = c(1, 10)) +
          theme_minimal() +
          xlab("Year") +
          ylab("Species") +
          scale_x_continuous(breaks = seq(min(year_input()[1]), max(year_input()[2]), by = 1)) +
          labs(title = "Species observations in all Poland (by Year)") +
          theme(axis.text.x = element_text(angle = 270, hjust = 1))
      })
      
      #create timeseries plot if conditions (filter active) in output$timeline are met
      output$timeline <- renderPlot({
        sci <- sci_input()
        vern <- vern_input()
        if ((!is.null(sci) & sci != "") |
            (!is.null(vern) & vern != "")) {
          timeline_plot()
        }
      })
    }
  )
}