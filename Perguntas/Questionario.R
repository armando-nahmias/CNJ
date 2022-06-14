install.packages("shinysurveys")

library(shiny)
library(shinysurveys)

perguntas <- list(
  'Quantas reuniões foram realizadas?',
  'O núcleo de estatística está em funcionamento?',
  'O comitê está em funcionamento?',
  'Quantas reuniões foram realizadas?'
)



df <- data.frame(question = perguntas,
                 option = respostas,
                 input_type = tipo,
                 input_id = id,
                 dependence = dependencia,
                 dependence_value = valor_dependencia,
                 required = obrigatoria)

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
