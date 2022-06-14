#-----------------------------------------------------------------------
#                                            Prof. Dr. Walmes M. Zeviani
#                                leg.ufpr.br/~walmes · github.com/walmes
#                                        walmes@ufpr.br · @walmeszeviani
#                      Laboratory of Statistics and Geoinformation (LEG)
#                Department of Statistics · Federal University of Paraná
#                                       2022-jun-06 · Curitiba/PR/Brazil
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------

library(shiny)
library(shinythemes)
library(shinyjs)
library(waiter)

shinyUI(
    fluidPage(
        class = "container",
        # Para usar recursos do {shinyjs}.
        useShinyjs(),
        # Para usar recursos do {waiter}.
        useWaitress(),
        # Uso de um tema do {shinythemes}.
        theme = shinytheme("yeti"),
        # Inclusão de CSS em linha.
        tags$head(
            # Note the wrapping of the string in HTML()
            tags$style(
                HTML("
                @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@300;800&display=swap');
                h1, h2 {
                  font-family: 'Montserrat', sans-serif;
                  font-weight: 800;
                }
                body {
                  font-family: 'Montserrat', sans-serif;
                  font-weight: 300;
                }
                .shiny-input-container {
                  color: #474747;
                }"
                )
            )
        ),
        titlePanel("Conversão de Cotação Diária de Preços"),
        verticalLayout(
            actionLink(inputId = "DOCUMENTACAO",
                       label = "Documentação",
                       style = "margin-bottom: 1em;"),
            # Upload de arquivo.
            fileInput(
                inputId = "THEFILE",
                label = "Selecione o arquivo",
                accept = c(".pdf"),
                buttonLabel = "Procurar",
                placeholder = "Nenhum arquivo selecionado.",
                width = "400px"
            ),
            shinyjs::hidden(
                actionButton(inputId = "PROCESSAR",
                             label = "Converter PDF em tabela",
                             icon = icon("cogs"),
                             style = "margin-bottom: 1em;",
                             width = "400px")
            ),
            shinyjs::hidden(
                downloadButton(
                    outputId = "DOWNLOADDATA",
                    label = "Baixar CSV",
                    style = "width: 400px;")
            )
        ) # verticalLayout()
    ) # fluidPage()
) # shinyUI()

#-----------------------------------------------------------------------
