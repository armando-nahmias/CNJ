#-----------------------------------------------------------------------
#                                            Prof. Dr. Walmes M. Zeviani
#                                leg.ufpr.br/~walmes · github.com/walmes
#                                        walmes@ufpr.br · @walmeszeviani
#                      Laboratory of Statistics and Geoinformation (LEG)
#                Department of Statistics · Federal University of Paraná
#                                       2022-jun-06 · Curitiba/PR/Brazil
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# server.R

library(shiny)

# Exclui os arquivos.
unlink("tabela.csv")
unlink("arquivo.csv")

shinyServer(
    function(input, output, session) {

        # Mostra o modal quando o link é clicado.
        observeEvent(input$DOCUMENTACAO, {
            showModal(
                modalDialog(
                    title = "Veja como usar essa aplicação",
                    footer = modalButton("Fechar"),
                    p("Essa aplicação lê a tabela de",
                      strong("Cotação Diária de Preços"),
                      "do Ceasa-PR e gera um arquivo CSV."
                      ),
                    p("Você pode baixar os PDF",
                      tags$a("aqui.",
                             href = "https://www.ceasa.pr.gov.br/Pagina/Cotacao-Diaria-de-Precos-2022",
                             target = "_blank")
                      )
                ))
        })

        # Botão carregar dados.
        observe({

            unlink("tabela.csv")
            shinyjs::hide(id = "PROCESSAR")
            shinyjs::hide(id = "DOWNLOADDATA")

            # Escreve arquivo em disco.
            file.copy(from = input$THEFILE$datapath,
                      to = "arquivo.pdf",
                      overwrite = TRUE)

            if (file.exists("arquivo.pdf")) {
                shinyjs::show(id = "PROCESSAR")
            }

        }) # observe()

        # Cria instância para usar algo que indique processamento.
        waitress <- Waitress$new("#PROCESSAR",
                                 theme = "overlay",
                                 infinite = TRUE)

        observeEvent(input$PROCESSAR, {
            # cat("Clicou em processar\n")
            waitress$start()

            # Pega o PDF e processa para gerar um data.frame.
            tb <- extract_tables("arquivo.pdf") |>
                discard(~nrow(.) <= 8)
            csv <- map(tb, split_product) |>
                unlist(recursive = FALSE) |>
                map(extract_data) |>
                bind_rows()
            write.table(csv,
                        file = "tabela.csv",
                        append = FALSE,
                        sep = ";",
                        row.names = FALSE)
            unlink("arquivo.pdf")
            # cat("Processou\n")

            if (file.exists("arquivo.pdf")) {
                shinyjs::hide(id = "PROCESSAR")
            }

            if (file.exists("tabela.csv")) {
                shinyjs::show(id = "DOWNLOADDATA")
            }

            waitress$close() # hide when done

        }) # observeEvent()

        output$DOWNLOADDATA <-
            downloadHandler(
                filename = function() {
                    # Troca a extensão de pdf para csv.
                    sub("\\.pdf", ".csv", input$THEFILE$name)
                },
                content = function(file) {
                    # Retorna o arquivo para baixar.
                    file.copy("tabela.csv", file)
                }
            ) # downloadHandler()

    }
)

#-----------------------------------------------------------------------
