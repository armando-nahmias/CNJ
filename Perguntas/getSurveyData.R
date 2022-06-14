
if (interactive()) {
  
  library(shiny)
  
  ui <- fluidPage(
    surveyOutput(teaching_r_questions)
  )
  
  server <- function(input, output, session) {
    renderSurvey()
    # Upon submission, print a data frame with participant responses
    observeEvent(input$submit, {
      print(getSurveyData())
    })
  }
  
  shinyApp(ui, server)
  
}


