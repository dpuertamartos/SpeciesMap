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

new_df <- new_df %>%
  mutate(eventTime = substr(eventTime, 1, 2)) %>%
  mutate(accessURI = gsub("https://observation.org/photos/","",accessURI)) %>%
  separate(eventDate, c("year", "month", "day"), sep = "-")


write.csv(new_df, "~/SpeciesMap/data/transformedMultimedia.csv", row.names = FALSE)


