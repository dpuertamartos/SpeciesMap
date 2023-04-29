library(dplyr)
library(tidyr)

df <- read.csv(file="~/SpeciesMap/data/filteredSpainMultimedia.csv",
               header=TRUE,
               sep=",")

new_df <- df %>%
  select(id,
         species_list = scientificName,
         vernacular_name = vernacularName,
         species_count = individualCount,
         decimalLongitude = longitudeDecimal,
         decimalLatitude =latitudeDecimal,
         eventDate,
         eventTime,
         accessURI
         )

# generate new column to store if the photo is original (1) or will be filled (0)

new_df <- new_df %>%
  mutate(originalPhoto = ifelse(accessURI == "", "", "1")) 


# fill missing accessURI with the closest one of the same species
new_df <- new_df %>%
  mutate(accessURI = if_else(accessURI == "", NA_character_, accessURI)) %>%
  dplyr::group_by(species_list) %>%
  fill(accessURI, .direction = "downup") %>%
  dplyr::ungroup() %>%
  mutate(accessURI = if_else(is.na(accessURI), "", accessURI))

# reduce eventTime to only the hours
# reduce size of csv by eliminitatin start of url
# split date in three columns

new_df <- new_df %>%
  mutate(eventTime = substr(eventTime, 1, 2)) %>%
  mutate(accessURI = gsub("https://observation.org/photos/","",accessURI)) %>%
  separate(eventDate, c("year", "month", "day"), sep = "-") %>%
  select(id,
         species_list,
         vernacular_name,
         species_count,
         decimalLongitude,
         decimalLatitude,
         year,
         accessURI,
         originalPhoto
  ) %>%
  filter(decimalLongitude >= -22.18872 & decimalLongitude <= -5.302732) %>%
  filter(decimalLatitude >= 25.86581 & decimalLatitude <= 35.89498)
  
  # filter(decimalLongitude >= map_bounds$west & decimalLongitude <= map_bounds$east) %>%
  # filter(decimalLatitude >= map_bounds$south & decimalLatitude <= map_bounds$north)
  #dplyr::filter(year >= 2019,
  #              year <= 2020)

new_df$id <- gsub("@OBS", "", new_df$id)

write.csv(new_df, "~/SpeciesMap/data/transformedMultimediaCanarias.csv", row.names = FALSE)


