filter_data <- function(df, years, sci_name, vern_name, map_bounds) {
  
  print('filtering data!!!!!!!!!!')
  
  #filter dataframe with selected years
  
  data_base <- df 
  
  if(!is.null(years)){
    print(years)
    data_base <- data_base %>%
      dplyr::filter(year >= years[1],
                    year <= years[2]
      )
  }
  else{
    data_base <- data_base %>%
      dplyr::filter(year == 2020)
  }
  
  #if there's a filter active for scientific name, filter dataframe
  if(!is.null(sci_name)){
    if(sci_name != ""){
      data_base <- data_base %>%
        filter(str_detect(species_list, sci_name))
    }
  }
  
  #if there's a filter active for vernacular name, filter dataframe
  if(!is.null(vern_name)){
    if(vern_name != ""){
      data_base <- data_base %>%
        filter(str_detect(vernacular_name, vern_name))
    }
  }
  
  # Add map_bounds filtering condition
  if (!is.null(map_bounds)) {
    data_base <- data_base %>%
      filter(decimalLongitude >= map_bounds$west & decimalLongitude <= map_bounds$east) %>%
      filter(decimalLatitude >= map_bounds$south & decimalLatitude <= map_bounds$north)
  }
  
  # Limit to the most recent 25,000 records if there are more than 25,000 records
  if (nrow(data_base) > 15000) {
    data_base <- data_base %>%
      dplyr::arrange(desc(year)) %>%
      dplyr::slice_head(n = 15000)
  }
  
  #return dataframe with selected filters applied
  return(data_base)
}