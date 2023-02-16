test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("filter_data returns same df when no filters affect the df", {
  # Create sample data
  original_df <- data.frame(year = c(2000, 2000, 2001, 2001),
                   species_list = c("species1", "species2", "species3", "species4"),
                   id = c("id1","id2","id3","id4"),
                   vernacular_name = c("species1", "species2", "species3", "species4"),
                   species_count = c(5, 10, 20, 25),
                   decimalLongitude = c(40,41,51,52),
                   decimalLatitude = c(40,41,51,52))
  
  expect_equal(original_df, filter_data(original_df,c(2000,2001),"",""))
})

test_that("filter_data returns correct df when filtered by years or combination with years", {
  # Create sample data
  original_df <- data.frame(year = c(2000, 2000, 2001, 2001),
                            species_list = c("species1", "species2", "species3", "species4"),
                            id = c("id1","id2","id3","id4"),
                            vernacular_name = c("species1", "species2", "species3", "species4"),
                            species_count = c(5, 10, 20, 25),
                            decimalLongitude = c(40,41,51,52),
                            decimalLatitude = c(40,41,51,52))
  
  expect_true(nrow(filter_data(original_df,c(2001,2001),"","")) == 2)
  expect_equal(original_df %>% dplyr::filter(year==2001),filter_data(original_df,c(2001,2001),"",""))
  expect_true(nrow(filter_data(original_df,c(2001,2001),"species3","")) == 1)
  expect_equal(original_df %>% dplyr::filter(year==2001, species_list=="species3"),
               filter_data(original_df,c(2001,2001),"species3",""))
})

test_that("filter_data returns correct df when filtered by sci_name", {
  # Create sample data
  original_df <- data.frame(year = c(2000, 2000, 2001, 2001),
                            species_list = c("species1", "species2", "species3", "species4"),
                            id = c("id1","id2","id3","id4"),
                            vernacular_name = c("species1", "species2", "species3", "species4"),
                            species_count = c(5, 10, 20, 25),
                            decimalLongitude = c(40,41,51,52),
                            decimalLatitude = c(40,41,51,52))
  
  expect_true(nrow(filter_data(original_df,c(2000,2001),"species1","")) == 1)
  expect_equal(original_df %>% dplyr::filter(species_list=="species1"),
               filter_data(original_df,c(2000,2001),"species1",""))
})

test_that("filter_data returns correct df when filtered by vern_name", {
  # Create sample data
  original_df <- data.frame(year = c(2000, 2000, 2001, 2001),
                            species_list = c("species1", "species2", "species3", "species4"),
                            id = c("id1","id2","id3","id4"),
                            vernacular_name = c("species1", "species2", "species3", "species4"),
                            species_count = c(5, 10, 20, 25),
                            decimalLongitude = c(40,41,51,52),
                            decimalLatitude = c(40,41,51,52))
  
  expect_true(nrow(filter_data(original_df,c(2000,2001),"","species1")) == 1)
  expect_equal(original_df %>% dplyr::filter(vernacular_name=="species1"),
               filter_data(original_df,c(2000,2001),"","species1"))
})

