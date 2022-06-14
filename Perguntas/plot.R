
library(shiny)

df_perguntas <-  read.csv2('Pasta4.csv')

t_perguntas <-  fread('Pasta2.csv')


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Teste Plotagem"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      ?ggplot
      hist(df_perguntas$pontos)
    )
  )
))
