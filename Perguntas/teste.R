library(shinysurveys)
library(data.table)


df_perguntas <-  read.csv2('Pasta2.csv')


ui <- fluidPage(
  
shinysurveys::surveyOutput(df = df_perguntas,
                           survey_title = "Prêmio CNJ de Qualidade",
                           survey_description = "Pontuação")
)

server <- function(input, output, session) {
  shinysurveys::renderSurvey()
  observeEvent(input$submit, {
    response_data <- getSurveyData()
    renderTable(response_data)
  })
}


shiny::shinyApp(ui = ui, server = server)

