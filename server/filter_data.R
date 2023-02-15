filter_data <- function(df, years, sci_name, vern_name) {
  #filter dataframe with selected years
  base <- df %>%
    dplyr::filter(year >= years[1],
                  year <= years[2])
  
  #if there's a filter active for scientific name, filter dataframe
  if(!is.null(sci_name) & sci_name != ""){
    base <- base %>%
      filter(str_detect(species_list, sci_name))
  }
  
  #if there's a filter active for vernacular name, filter dataframe
  if(!is.null(vern_name) & vern_name != ""){
    base <- base %>%
      filter(str_detect(vernacular_name, vern_name))
  }
  
  #return dataframe with selected filters applied
  return(base)
}