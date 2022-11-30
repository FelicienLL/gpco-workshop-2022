library(mapbayr)
simpledata <- read.csv("data/simpledata.csv", na = ".")
simpledata
simple %>%
  data_set(simpledata) %>%
  mrgsim()

#' Modifier simple2.cpp en simple2_mapbay.cpp
simple2_mapbay <- mread("models/simple2_mapbay.cpp")
check_mapbayr_model(simple2_mapbay)

est <- mapbayest(simple2_mapbay, simpledata)

est
plot(est)
hist(est)
as.data.frame(est)

get_data(est)
get_eta(est)
get_param(est, "CL")
CL <- get_param(est, "CL")
unique(as.data.frame(est)$CL)

dose <- simpledata$AMT[simpledata$EVID == 1]
AUC <- dose / CL
AUC

#' Faire des simulations
est %>%
  use_posterior()

est %>%
  use_posterior() %>%
  ev(amt = 200, addl = 3, ii = 24) %>%
  mrgsim(start = 0, end = 96) %>%
  plot("DV")

new_scenarios <- expand.ev(
  amt = c(100, 200, 300),
  ii = c(12, 24),
  addl = 10
)

new_scenarios

est %>%
  use_posterior() %>%
  ev(new_scenarios) %>%
  mrgsim(start = 96, end = 96, obsonly = TRUE, carry_out = "amt, ii")


