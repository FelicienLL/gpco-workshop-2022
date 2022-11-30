library(shiny)
library(mrgsolve) # <- besoin de ces deux packages
library(mapbayr)  # <- besoin de ces deux packages

ui <- fluidPage(
  titlePanel("Adaptation Poso Ruxolitinib"),
  sidebarLayout(
    sidebarPanel(
      numericInput("dose", "Dose", value = 10, step = 5),
      numericInput("ii", "Intervalle Interdose", value = 12),
      numericInput("timeech1", "Temps Ech 1", value = 0),
      numericInput("conc1", "Concentration 1", value = NA_real_),
      numericInput("timeech2", "Temps Ech 2", value = 0),
      numericInput("conc2", "Concentration 2", value = NA_real_),
      numericInput("poids", "Poids", value = 72.9),
      numericInput("sex", "Sexe", 0, min = 0, max = 1, step = 1),
      actionButton("go", "Go !")
    ),
    mainPanel(
      textOutput("CLAUCtext"),
      tableOutput("predtab"),
      plotOutput("predplot"),
      tableOutput("simutab")
    )
  )
)
server <- function(input, output) {

  # Reactives

  # re_data <- eventReactive(, {
  #
  # })

  re_est <- reactive({

  })

  re_posthoc <- reactive({

  })

  # Outputs

  output$CLAUCtext <- renderText({

  })

  output$predtab <- renderTable({

  })

  output$predplot <- renderPlot({

  })

  output$simutab <- renderTable({

  })
}
shinyApp(ui = ui, server = server)
