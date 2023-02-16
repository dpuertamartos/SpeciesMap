##THIS MODULE IS IN CHARGE OF GENERATING FILTERS
source("utils/conditional_input_filter.R")

filterModUI <- function(id){
  ns <- NS(id)
  tagList(
      radioButtons(ns("filter_type"),
                   label = "Select filter type:",
                   choices = list("Scientific Name" = "sci_name", "Common Name" = "vern_name"),
                   selected = "sci_name"),
      ##this uses the helper ui function conditional_input_filter that
      #makes a conditional selectizeInput
      conditional_input_filter(
        condition = 'input.filter_type == "sci_name"',
        ns = ns,
        id = "sci_name",
        label = "Enter scientific Name",
        placeholder = "Grus grus"
      ),
      conditional_input_filter(
        condition = 'input.filter_type == "vern_name"',
        ns = ns,
        id = "vern_name",
        label = "Enter common Name",
        placeholder = "Common Crane"
      ),
      sliderInput(
        ns("years"),
        "Select years",
        min = as.integer("1984"),
        max = as.integer("2020"),
        value = c(as.integer("2018"),as.integer("2020")),
        step = 1,
        ticks = FALSE,
        width = "90%"
      )
  )
}

filterModServer <- function(id, df){
  moduleServer(
    id,
    function(input, output, session) {
      
      #scientific name filter reactive
      sci_name_choices <- reactive({
        data_base <- df %>% select(species_list) %>% unlist()
        names(data_base) <- data_base
        
        if(is.null(input$sci_name) | input$sci_name == ""){
          return(data_base)
        }
        data_base[str_detect(data_base,input$sci_name)]
      })
      
      #vern name filter options reactive
      vern_name_choices <- reactive({
        data_base <- df %>% select(vernacular_name) %>% unlist()
        names(data_base) <- data_base
        
        if(is.null(input$vern_name) | input$vern_name == ""){
          return(data_base)
        }
        data_base[str_detect(data_base,input$vern_name)]
      })
      
      #update choices of the filters in frontend
      isolate({
        updateSelectizeInput(session,"sci_name",server = TRUE,choices = sci_name_choices())
        updateSelectizeInput(session,"vern_name",server = TRUE, choices = vern_name_choices())
      })
      
      #this observes the filter type selected, to erase the value of the opposite filter
      observeEvent(input$filter_type, {
        if (input$filter_type == "sci_name") {
          updateSelectizeInput(session, "vern_name", selected = "")
        } else if (input$filter_type == "vern_name") {
          updateSelectizeInput(session, "sci_name", selected = "")
        }
      })
     
      
      #return the input values to be used by other modules
      return(
        list(
          sci_name = reactive({input$sci_name}),
          vern_name = reactive({input$vern_name}),
          years = reactive({input$years})
        )
      )
    }
  )
}