##THIS MODULE IS IN CHARGE OF PLOTTING THE MOST FREQUENT OBSERVATIONS IN AREA!

speciesAreaUI <- function(id){
  ns <- NS(id)
  tagList(
    gt::gt_output(ns("species_in_area"))
  )
}

speciesAreaServer <- function(id, df){
  moduleServer(
    id,
    function(input, output, session) {
      
      output$species_in_area <- gt::render_gt({
        df() %>%
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
