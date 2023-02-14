library(dplyr)
library(tidyr)

df <- read.csv(file="~/SpeciesMap/data/filteredPoland.csv",
               header=TRUE,
               sep=",")

new_df <- df %>%
  select(id, 
         species_list = scientificName, 
         vernacular_name = vernacularName, 
         species_count = individualCount, 
         decimalLongitude = longitudeDecimal, 
         decimalLatitude =latitudeDecimal, eventDate)

new_df <- new_df %>%
  separate(eventDate, c("year", "month", "day"), sep = "-")

write.csv(new_df, "~/SpeciesMap/data/transformed.csv", row.names = FALSE)


