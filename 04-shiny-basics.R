library(shiny)
ui <- fluidPage(
    titlePanel("La loi Normale"),
    sidebarLayout(
        sidebarPanel(
            sliderInput(inputId = "nsample",
                        label = "Nombre d'echantillons",
                        min = 10,
                        max = 1000,
                        value = 30)
        ),
        mainPanel(
           plotOutput("distributionPlot")
        )
    )
)
server <- function(input, output) {
  output$distributionPlot <- renderPlot({
    values <- rnorm(n = input$nsample, mean = 0, sd = 1)
    hist(x = values, main = "Distribution normale")
  })
}
shinyApp(ui = ui, server = server)
