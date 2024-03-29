library(shiny)
ui <- fluidPage(
  titlePanel("La loi Normale"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "nsample", label = "Nombre d'echantillons",
                  min = 10, max = 1000, value = 30)
    ),
    mainPanel(
      plotOutput(outputId = "distrib")
    )
  )
)
server <- function(input, output) {
 output$distrib <- renderPlot({
    hist(x = rnorm(n = input$nsample), main = "Distribution normale", col = "grey")
  })
}
shinyApp(ui = ui, server = server)
