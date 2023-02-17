test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("speciesSelectedServer produces correct HTML output when a marker is clicked", {
  # Create a mock df
  df <- data.frame(year = c(2000, 2000, 2001, 2001),
                   species_list = c("species1", "species2", "species1", "species2"),
                   id = c("id1","id2","id3","id4"),
                   vernacular_name = c("species1", "species2", "species1", "species2"),
                   species_count = c(5, 10, 20, 25)
                   )
  
  map_marker_click <- reactiveVal()

  testServer(speciesSelectedServer, 
             args = list(df = df, map_marker_click = map_marker_click), 
             {
               map_marker_click(list(id = "id1"))
               session$flushReact()
               # Check if there's output
               expect_false(is.null(output$species_list_text))
               expect_true(
                 output$species_list_text$html == "<div class='species_list_header'> Showing info of observation id1<br></div> <span> Click on another marker to see more! </span>"
               )
  })
})

test_that("if no marker clicked it gives the base message", {
  # Create a mock df
  df <- data.frame(year = c(2000, 2000, 2001, 2001),
                   species_list = c("species1", "species2", "species1", "species2"),
                   id = c("id1","id2","id3","id4"),
                   vernacular_name = c("species1", "species2", "species1", "species2"),
                   species_count = c(5, 10, 20, 25)
  )
  
  map_marker_click <- reactiveVal()
  
  testServer(speciesSelectedServer, 
             args = list(df = df, map_marker_click = map_marker_click), 
             {
               session$flushReact()
               # Check if there's output
               expect_false(is.null(output$species_list_text))
               # check is said output is the base message
               expect_true(
                 output$species_list_text$html == "<span> Click on a marker to see which species was observed </span>"
               )
             })
})


test_that("if marker with wrong id (non existant in df) gives wrong marker error as HTML", {
  # Create a mock df
  df <- data.frame(year = c(2000, 2000, 2001, 2001),
                   species_list = c("species1", "species2", "species1", "species2"),
                   id = c("id1","id2","id3","id4"),
                   vernacular_name = c("species1", "species2", "species1", "species2"),
                   species_count = c(5, 10, 20, 25)
  )
  
  map_marker_click <- reactiveVal()
  
  testServer(speciesSelectedServer, 
             args = list(df = df, map_marker_click = map_marker_click), 
             {
               map_marker_click(list(id = "id5"))
               session$flushReact()
               # Check if there's output
               expect_false(is.null(output$species_list_text))
               # check is said output is the base message
               expect_true(
                 output$species_list_text$html == "<span>wrong marker</span>"
               )
             })
})