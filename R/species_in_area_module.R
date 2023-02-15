##THIS MODULE IS IN CHARGE OF PLOTTING THE MOST FREQUENT OBSERVATIONS IN AREA!

species_in_area_UI <- function(id){
  ns <- NS(id)
  tagList(
    gt::gt_output(ns("species_in_area"))
  )
}

species_in_area_server <- function(id, df, 
                                   year_input, sci_input, vern_input, 
                                   map_bounds){
  moduleServer(
    id,
    function(input, output, session) {
      
      df_bounds <- reactive({
        if (is.null(map_bounds()))
          return(df[FALSE,])
        bounds <- map_bounds()
        latRng <- range(bounds$north, bounds$south)
        lngRng <- range(bounds$east, bounds$west)
        
        subset(filter_data(df, year_input(), sci_input(), vern_input()),
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
          gt::tab_header(title = "Most frequent observations in area") %>%
          gtExtras::gt_plt_bar(column = Count,color = "darkblue",scale_type = "number")
      })
      
    }
  )
}
