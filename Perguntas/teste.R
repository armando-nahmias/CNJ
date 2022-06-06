library(shinysurveys)
ui <- shiny::fluidPage(
  shinysurveys::surveyOutput(df = shinysurveys::teaching_r_questions,
                             survey_title = "A minimal title",
                             survey_description = "A minimal description")
)

server <- function(input, output, session) {
  shinysurveys::renderSurvey()
}

shiny::shinyApp(ui = ui, server = server)