library(dplyr)
library(tidyr)

df <- read.csv(file="~/SpeciesMap/data/filteredPolandMultimedia.csv",
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
  mutate(originalPhoto = ifelse(accessURI == "", "", "original photo")) 


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
  separate(eventDate, c("year", "month", "day"), sep = "-")


write.csv(new_df, "~/SpeciesMap/data/transformedMultimedia.csv", row.names = FALSE)


