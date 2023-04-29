##THIS MODULE IS IN CHARGE OF SHOWING THE INFO OF A MARKER SELECTED! >:)

speciesSelectedUI <- function(id){
  ns <- NS(id)
  tagList(
    htmlOutput(ns("species_list_text"), style = "margin-bottom: 10px; margin-top: 10px;")
  )
}

speciesSelectedServer <- function(id, df, map_marker_click){
  moduleServer(
    id,
    function(input, output, session) {
      
      output$species_list_text <- renderUI({
        m <- map_marker_click()
        if(!is.null(m)){
          
          #select the observation in the df with the id associated to the marker in the map
          observation_selected <- df() %>%
            filter(id == m$id) 
          
          #if weird marker (not present in df which should not happen) is passed return error HTML
          if(nrow(observation_selected) == 0){return(HTML("<span>wrong marker</span>"))}
          #when we have the observation selected, when can extract different info
          
          #dom construction to render as HTML when user clicks
          header <- glue::glue("<div class='species_list_header'> Showing info of observation {m$id}<br></div>")
          species_list <- paste(header,"<span> Click on another marker to see more! </span>",
                                collapse='')
          
          #return the dom construction
          return(HTML(species_list))
        }else{
          HTML("<span> Click on a marker to see which species was observed </span>")
        }
      })
    }
  )
}