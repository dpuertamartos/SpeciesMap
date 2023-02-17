library(jsonlite)

test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("mapgenServer produces output", {
  # Create a mock df
  df <- data.frame(year = c(2000, 2000, 2001, 2001),
                   species_list = c("species1", "species2", "species1", "species2"),
                   id = c("id1","id2","id3","id4"),
                   vernacular_name = c("species1", "species2", "species1", "species2"),
                   species_count = c(5, 10, 20, 25),
                   decimalLongitude = c(40,41,51,52),
                   decimalLatitude = c(40,41,51,52),
                   accessURI =c("false.jpg","false.jpg","false.jpg","false.jpg"),
                   originalPhoto = c("","","","")
  )
  
  sci_input <- reactiveVal()
  vern_input <- reactiveVal()
  year_input <- reactiveVal()
  
  
  testServer(mapGenServer, 
             args = list(df = df, sci_input = sci_input, 
                         vern_input = vern_input, year_input = year_input), 
             {
               sci_input("")
               vern_input("")
               year_input(c(2000,2001))
               session$flushReact()
               # Check if there's output
               
               expect_false(is.null(output$map))
               obj <- fromJSON(output$map)
               #correct bounds of the map produced
               
               expect_true(obj$x$fitBounds[[1]]==48)
               expect_true(obj$x$fitBounds[[2]]==14)
               expect_true(obj$x$fitBounds[[3]]==55)
               expect_true(obj$x$fitBounds[[4]]==25)
               #correct layer
               expect_true(obj$x$options$crs$crsClass=="L.CRS.EPSG3857")
              
               
             })
})

