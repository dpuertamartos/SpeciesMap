test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("speciesAreaServer produces output when there are species inside the map bounds", {
  # Create a mock df
  df <- data.frame(year = c(2000, 2000, 2001, 2001),
                   species_list = c("species1", "species2", "species1", "species2"),
                   id = c("id1","id2","id3","id4"),
                   vernacular_name = c("species1", "species2", "species1", "species2"),
                   species_count = c(5, 10, 20, 25),
                   decimalLongitude = c(40,45,50,55),
                   decimalLatitude = c(40,45,50,55)
  )
  
  sci_input <- reactiveVal()
  vern_input <- reactiveVal()
  year_input <- reactiveVal()
  map_bounds <- reactiveVal()
  
  testServer(speciesAreaServer, 
             args = list(df = df, sci_input = sci_input, 
                         vern_input = vern_input, year_input = year_input,
                         map_bounds = map_bounds), 
             {
               sci_input("")
               vern_input("")
               year_input(c(2000,2001))
               map_bounds(list(north = 35,south=60, east=35, west=60))
               session$flushReact()
               # Check if there's output

               expect_false(is.null(output$species_in_area))
               expect_false(is.null(output$species_in_area$html))
               
               #easy way to check if it produces the correct right html string
               expect_true(nchar(output$species_in_area$html)==11939)

             })
})

test_that("speciesAreaServer produces empty table when there are no species inside the map bounds", {
  # Create a mock df
  df <- data.frame(year = c(2000, 2000, 2001, 2001),
                   species_list = c("species1", "species2", "species1", "species2"),
                   id = c("id1","id2","id3","id4"),
                   vernacular_name = c("species1", "species2", "species1", "species2"),
                   species_count = c(5, 10, 20, 25),
                   decimalLongitude = c(40,45,50,55),
                   decimalLatitude = c(40,45,50,55)
  )
  
  sci_input <- reactiveVal()
  vern_input <- reactiveVal()
  year_input <- reactiveVal()
  map_bounds <- reactiveVal()
  
  testServer(speciesAreaServer, 
             args = list(df = df, sci_input = sci_input, 
                         vern_input = vern_input, year_input = year_input,
                         map_bounds = map_bounds), 
             {
               sci_input("")
               vern_input("")
               year_input(c(2000,2001))
               map_bounds(list(north = 10,south=0, east=35, west=60))
               session$flushReact()
               # Check if there's output
               
               expect_false(is.null(output$species_in_area))
               expect_false(is.null(output$species_in_area$html))
               #easy way to check if table is empty 9155 is the html length of an empty gt table in this case
               expect_true(nchar(output$species_in_area$html)==9155)
               
             })
})