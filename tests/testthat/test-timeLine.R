test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("timeLineServer produces a plot", {
  # Create a mock df
  df <- data.frame(year = c(2000, 2000, 2001, 2001),
                   species_list = c("species1", "species2", "species1", "species2"))
  sci_input <- reactiveVal()
  vern_input <- reactiveVal()
  year_input <- reactiveVal()
  

  testServer(timeLineServer, 
             args = list(df = df, sci_input = sci_input, 
                         vern_input = vern_input, year_input = year_input), 
            {
              
            sci_input("species1")
            vern_input("")
            year_input(c(2000,2001))
            session$flushReact()
            # Check if there's output
            print(output$timeline)
            expect_true(!is.null(output$timeline)) 
            expect_true(output$timeline$alt=="Plot object")
            expect_true(length(output$timeline$coordmap$panels[[1]]$mapping)>0)
            expect_false(output$timeline$coordmap$panels[[1]]$domain$left == -0.050)
            
            
  })
})

test_that("timeLineServer does not call timeline_plot when there's not input", {
  # Create a mock df
  df <- data.frame(year = c(2000, 2000, 2001, 2001),
                   species_list = c("species1", "species2", "species1", "species2"))
  sci_input <- reactiveVal()
  vern_input <- reactiveVal()
  year_input <- reactiveVal()
  
  
  testServer(timeLineServer, 
             args = list(df = df, sci_input = sci_input, 
                         vern_input = vern_input, year_input = year_input), 
             {
               
               sci_input("")
               vern_input("")
               year_input(c(2000,2001))
               session$flushReact()
               # Check if there's output
               expect_true(!is.null(output$timeline)) 
               expect_true(output$timeline$alt=="Plot object")
               expect_false(length(output$timeline$coordmap$panels[[1]]$mapping)>0)
             })
})

test_that("When inputs are correct but filtered df is empty it calls timeline_plot
          but produces a blank plot", {
  # Create a mock df
  df <- data.frame(year = c(2003,2004),
                   species_list = c("species1","species1"))
  sci_input <- reactiveVal()
  vern_input <- reactiveVal()
  year_input <- reactiveVal()
  
  
  testServer(timeLineServer, 
             args = list(df = df, sci_input = sci_input, 
                         vern_input = vern_input, year_input = year_input), 
             {
               
               sci_input("species1")
               vern_input("")
               year_input(c(2000,2001))
               session$flushReact()
               # Check if there's output
               expect_true(!is.null(output$timeline)) 
               expect_true(output$timeline$alt=="Plot object")
               expect_true(length(output$timeline$coordmap$panels[[1]]$mapping)>0)
               expect_true(output$timeline$coordmap$panels[[1]]$domain$left == -0.050)
             })
})
