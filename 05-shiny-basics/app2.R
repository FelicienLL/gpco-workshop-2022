library(shiny)
ui <- fluidPage(
  titlePanel("La loi Normale"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "nsample", label = "Nombre d'echantillons",
                  min = 10, max = 1000, value = 30),
      selectInput("col", "Choisir Couleur", c("red", "green", "yellow"))
      # ou textInput("col", "Choisir Couleur")
    ),
    mainPanel(
      plotOutput(outputId = "distrib")
    )
  )
)
server <- function(input, output) {
 output$distrib <- renderPlot({
    hist(x = rnorm(n = input$nsample), main = "Distribution normale", col = input$col)
  })
}
shinyApp(ui = ui, server = server)
