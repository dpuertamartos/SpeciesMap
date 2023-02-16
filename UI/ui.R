ui <- bootstrapPage(
  #front end
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  map_UI("map_generator"),
  absolutePanel(style = "max-width: 30%;background-color: rgba(255,255,255,0.7);padding: 0px 10px 0px 10px;border-radius: 10px",top = 10, right = 10,
            
                species_in_area_UI("species_area_graph"),
                filter_UI("filters"),
                timeline_UI("timeline_graph")
  ),
  
  
  
  absolutePanel(top = 10, left = "40%",
                width = "25%",
                style="background-color: rgba(255,255,255,0.7);padding: 10px 30px 10px 30px;border-radius: 20px;",
                marker_info_UI("marker_selected_info")
  ),
)