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
      plotOutput(outputId = "distrib"),
      textOutput(outputId = "moyenne")
    )
  )
)
server <- function(input, output) {
  re_values <- reactive({rnorm(n = input$nsample)})

  output$moyenne <- renderText({
    mean(re_values())
  })

  output$distrib <- renderPlot({
    hist(x = re_values(), main = "Distribution normale", col = input$col)
  })
}
shinyApp(ui = ui, server = server)
