library(shiny)
ui <- fluidPage(
  titlePanel("La loi Normale"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "nsample", label = "Nombre d'echantillons",
                  min = 10, max = 1000, value = 30),
      textInput("color", "couleur", "grey"),
      actionButton("go", "Go!")
    ),
    mainPanel(
      plotOutput(outputId = "distrib"),
      verbatimTextOutput("moyenne")
    )
  )
)
server <- function(input, output) {
  re_values <- eventReactive(input$go, {
    rnorm(n = input$nsample)
  })

  output$distrib <- renderPlot({
    hist(x = re_values(), main = "Distribution normale", col = isolate(input$color))
  })

  output$moyenne <- renderText({
    mean(re_values())
  })

}
shinyApp(ui = ui, server = server)
