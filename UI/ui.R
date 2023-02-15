ui <- bootstrapPage(
  #front end
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", 
                width = "100%", 
                height = "100%"),
  absolutePanel(style = "max-width: 30%;background-color: rgba(255,255,255,0.7);padding: 0px 10px 0px 10px;border-radius: 10px",top = 10, right = 10,
                
                gt::gt_output("species_in_area"),
                radioButtons("filter_type",
                             label = "Select filter type:",
                             choices = list("Scientific Name" = "sci_name", "Common Name" = "vern_name"),
                             selected = "sci_name"),
                
                conditionalPanel(
                  condition = 'input.filter_type == "sci_name"',
                  selectizeInput("sci_name",
                                 label = "Enter scientific Name",
                                 choices = NULL,
                                 multiple = FALSE,
                                 width = "100%",
                                 options = list(
                                   create = FALSE,
                                   placeholder = "Grus grus",
                                   maxItems = '1',
                                   onDropdownOpen = I("function($dropdown) {if (!this.lastQuery.length) {this.close(); this.settings.openOnFocus = false;}}"),
                                   onType = I("function (str) {if (str === \"\") {this.close();}}")))
                ),
                
                conditionalPanel(
                  condition = 'input.filter_type == "vern_name"',
                  selectizeInput("vern_name",
                                 label = "Enter common Name",
                                 choices = NULL,
                                 multiple = FALSE,
                                 width = "100%",
                                 options = list(
                                   create = FALSE,
                                   placeholder = "Common Crane",
                                   maxItems = '1',
                                   onDropdownOpen = I("function($dropdown) {if (!this.lastQuery.length) {this.close(); this.settings.openOnFocus = false;}}"),
                                   onType = I("function (str) {if (str === \"\") {this.close();}}")))
                ),
                sliderInput(
                  "years",
                  "Select years",
                  min = as.integer("1984"),
                  max = as.integer("2020"),
                  value = c(as.integer("2018"),as.integer("2020")),
                  step = 1,
                  ticks = FALSE,
                  width = "90%"
                ),
                
                plotOutput("timeline",height = "200px")
  ),
  
  
  
  absolutePanel(top = 10, left = "40%",
                width = "25%",
                style="background-color: rgba(255,255,255,0.7);padding: 10px 30px 10px 30px;border-radius: 20px;",
                htmlOutput("species_list_text", style = "margin-bottom: 10px; margin-top: 10px;")
  ),
)