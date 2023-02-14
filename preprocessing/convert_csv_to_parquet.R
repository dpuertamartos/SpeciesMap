library(arrow)
df <- read.csv("~/SpeciesMap/data/transformed.csv")

# Convert data types
df$id <- as.character(df$id)
df$species_list <- as.character(df$species_list)
df$vernacular_name <- as.character(df$vernacular_name)
df$species_count <- as.integer(df$species_count)
df$decimalLongitude <- as.double(df$decimalLongitude)
df$decimalLatitude <- as.double(df$decimalLatitude)
df$year <- as.integer(df$year)
df$month <- as.integer(df$month)
df$day <- as.integer(df$day)
  
# Create schema
schema <- arrow::schema(
  arrow::field("id", arrow::utf8()),
  arrow::field("species_list", arrow::utf8()),
  arrow::field("vernacular_name", arrow::utf8()),
  arrow::field("species_count", arrow::int32()),
  arrow::field("decimalLongitude", arrow::float64()),
  arrow::field("decimalLatitude", arrow::float64()),
  arrow::field("year", arrow::int32()),
  arrow::field("month", arrow::int32()),
  arrow::field("day", arrow::int32()),
)

# Create Arrow table
table <- arrow_table(df, schema = schema)
print(table)
write_parquet(table, "~/SpeciesMap/data/transformed.parquet")