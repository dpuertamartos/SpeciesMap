conditional_input_filter <- function(condition, ns, id, label, placeholder) {
  conditionalPanel(
    condition = condition, ns = ns,
    selectizeInput(ns(id),
                   label = label,
                   choices = NULL,
                   multiple = FALSE,
                   width = "100%",
                   options = list(
                     create = FALSE,
                     placeholder = placeholder,
                     maxItems = '1',
                     onDropdownOpen = I("function($dropdown) {if (!this.lastQuery.length) {this.close(); this.settings.openOnFocus = false;}}"),
                     onType = I("function (str) {if (str === \"\") {this.close();}}")))
  )
}