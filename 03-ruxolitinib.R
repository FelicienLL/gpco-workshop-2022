#' Modifier "models/ruxo.cpp" en "models/ruxo_mapbay.cpp"

#' Importer-le dans R
ruxo_mapbay <- mread("models/ruxo_mapbay.cpp")
check_mapbayr_model(ruxo_mapbay)

#' Importer un dataset de ruxolitinib a analyser
ruxodata <- read.csv("data/ruxodata.csv")
ruxodata
ruxo_est <- mapbayest(ruxo_mapbay, data = ruxodata)
ruxo_est
plot(ruxo_est)
plot(ruxo_est) + scale_y_log10()
hist(ruxo_est)

#' Metrique PK qui nous interesse ?
#' 1. AUC
CL <- get_param(ruxo_est, "CL") # L/h
DOSE <- ruxodata$AMT[ruxodata$EVID==1] # mg
DOSE / CL #mg/L.h
1000 * DOSE / CL # microg/L.h = ng/mL.h

#' 2. Concentration au temps T=0, T=2.5 ou T=11.9
ruxo_est %>%
  as.data.frame() %>%
  filter(time == 0) %>%
  select(IPRED)

#' 3. Concentration au temps TX... 8h ?
ruxo_est %>%
  use_posterior() %>%
  data_set(ruxodata) %>%
  mrgsim(start = 8, end = 8,
         obsaug = TRUE) %>% #OBSservation AUGmentation = ajouter temps si utilisation de "data_set()"
  filter(TIME == 8) %>%
  select(DV)

#' 4. %Temps au-dessus de 100 ng/mL ?
ruxo_est %>%
  use_posterior() %>%
  data_set(ruxodata) %>%
  mrgsim(start = 0, end = 12,
         delta = 0.01, # <- petit delta
         obsaug = TRUE) %>%
  summarise(ProportionTempsAuDessusDe100 = mean(DV > 100),
            TempsAuDessusDe100 = 12 * ProportionTempsAuDessusDe100)

#' 5. Plusieurs nouveaux schemas posologiques ?
toutes_poso_ruxo <- expand.ev(amt = c(5, 10, 15, 20), ii = c(12, 24), ss = 1)

#' 5.1 Pour une concentration a un temps precis.
ruxo_est %>%
  use_posterior() %>%
  ev(toutes_poso_ruxo) %>%
  mrgsim(recsort = 3, start = 0, end = 0, obsonly = TRUE)

#' 5.2 Pour un temps au-dessus d'un seuil.
ruxo_est %>%
  use_posterior() %>%
  ev(toutes_poso_ruxo) %>%
  mrgsim(recsort = 3, start = 0, end = 24, delta = 0.01, obsonly = TRUE) %>%
  group_by(ID) %>%
  summarise(ProportionTempsAuDessusDe100 = mean(DV > 100),
            TempsAuDessusDe100 = 24 * ProportionTempsAuDessusDe100)
