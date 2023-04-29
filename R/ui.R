ui <- bootstrapPage(
  #front end
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  mapGenUI("map_generator"),

  absolutePanel(style = "max-width: 30%;background-color: rgba(255,255,255,0.85);padding: 20px 15px 0px 15px;border-radius: 10px",top = 10, right = 10,
                selectInput("dataset_size", "Choose dataset:",
                            choices = c("South" = "sur",
                                        "Mid" = "centro",
                                        "North" = "norte",
                                        "East and Baleares" = "este",
                                        "Canary islands" = "canarias"),
                            selected = "centro"),
                filterModUI("filters"),
                speciesAreaUI("species_area_graph")
                # timeLineUI("timeline_graph"),
                
  ),
  absolutePanel(top = 10, left = "20%",
                style="background-color: rgba(255,255,255,0.7);padding: 10px 30px 10px 30px;border-radius: 20px;",
                speciesSelectedUI("marker_selected_info")
  ),
)