library(shiny)
library(mrgsolve) # <- besoin de ces deux packages
library(mapbayr)  # <- besoin de ces deux packages
library(dplyr)
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
### Fonctions pour l'adaptation de dose.
ecrire_commentaire_CL <- function(est){
  CL <- get_param(est, "CL") # L/h
  DOSE <- get_data(est)$amt[get_data(est)$evid==1] # mg
  AUC <- DOSE / CL # mg/L.h
  AUC <- 1000 * DOSE / CL # ng/mL.h
  paste("Clairance du patient:", round(CL), "L/h, et AUC =", round(AUC), "ng/mL.h")
}

tableau_predictions <- function(est){
  est %>%
    as.data.frame() %>%
    filter(time != 0) %>%
    select(time, DV, PRED, IPRED)
}

tableau_simulations <- function(est){
  toutes_poso_ruxo <- expand.ev(amt = c(5, 10, 15, 20), ii = c(12, 24), ss = 1)
  sum51 <- est %>%
    use_posterior() %>%
    ev(toutes_poso_ruxo) %>%
    mrgsim(recsort = 3, start = 0, end = 0, obsonly = TRUE)
  toutes_poso_ruxo %>%
    select(amt, ii) %>%
    mutate(conc = round(sum51$DV, 2))
}


server <- function(input, output) {

  ruxomodel <- mread("../models/reponses/ruxo_mapbay.cpp")

  # Reactives

  re_data <- eventReactive(input$go, {
    ruxomodel %>%
      adm_lines(amt = input$dose, ii = input$ii, ss = 1, cmt = 1) %>%
      obs_lines(time = input$timeech1, DV = input$conc1, cmt = 2) %>%
      obs_lines(time = input$timeech2, DV = input$conc2, cmt = 2) %>%
      add_covariates(covariates = list(BW = input$poids, SEX = input$sex)) %>%
      get_data()
  })

  re_est <- reactive({
    mapbayest(ruxomodel, re_data())
  })

  re_posthoc <- reactive({
    tableau_simulations(re_est())
  })

  # Outputs

  output$CLAUCtext <- renderText({
    ecrire_commentaire_CL(est = re_est())
  })

  output$predtab <- renderTable({
    tableau_predictions(est = re_est())
  })

  output$predplot <- renderPlot({
    plot(re_est())
  })

  output$simutab <- renderTable({
    re_posthoc()
  })
}
shinyApp(ui = ui, server = server)
