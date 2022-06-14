library(DT,)

library(data.table, ggplot)


t_perguntas <-  fread('Pasta4.csv')
resposta <- data.frame(
  Area = t_perguntas$area,
  Eixo = t_perguntas$eixo,
  Ponto = t_perguntas$ponto
)

ggplot(data = t_perguntas,
       )

ui <- basicPage(
  h2("Tabela"),
  DT::dataTableOutput("mytable")
)


ggplot(data(t_perguntas))

server <- function(input, output) {
  output$barplot = DT::renderbarDataTable({
    resposta
  })
}

shinyApp(ui, server)