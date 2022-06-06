install.packages("shinysurveys")

library(shiny)
library(shinysurveys)

df <- data.frame(question = "Quantas reuniões foram realizadas?",
                 option = "0",
                 input_type = "numeric",
                 input_id = "5.I.a",
                 dependence = NA,
                 dependence_value = NA,
                 required = F)

ui <- fluidPage(
  surveyOutput(df = df,
               survey_title = "Hello, World!",
               survey_description = "Welcome! This is a demo survey showing off the {shinysurveys} package.")
)

server <- function(input, output, session) {
  renderSurvey()
  
  observeEvent(input$submit, {
    showModal(modalDialog(
      title = "Congrats, you completed your first shinysurvey!",
      "You can customize what actions happen when a user finishes a survey using input$submit."
    ))
  })
}

shinyApp(ui, server)
