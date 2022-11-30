#' Modifier "models/ruxo.cpp" en "models/ruxo_mapbay.cpp"

#' Pour pouvoir utiliser le modele dans mapbayr, 5 modifications a faire:
#' 1- Dans $PARAM. Ajouter des parametres ETA1, ETA2 etc... que l'on veut estimer
#' 2- Dans $MAIN. Ajouter ces ETA1, ETA2 etc... dans la definition de CL, V...
#' 3- Dans $SIGMA : Erreur proportionnelle en PREMIER, Erreur additive en DEUXIEME.
#' 4- Dans $CAPTURE : La concentration predite doit etre DV.
#' 5- Dans $CAPTURE : Capturer les variables qui vous interesse : CL, V ?


#' Importer-le dans R
ruxo_mapbay <- mread("models/ruxo_mapbay.cpp")
check_mapbayr_model(ruxo_mapbay)
#' Importer un dataset de ruxolitinib a analyser
ruxodata <- read.csv("data/ruxodata.csv")
ruxodata
ruxo_est <- mapbayest(ruxo_mapbay, data = ruxodata)
ruxo_est
plot(ruxo_est) # objet ggplot = modifiable
hist(ruxo_est)

#' Metrique PK qui nous interesse ?
#' 1. AUC = DOSE / CL
#' CL
CL <- get_param(ruxo_est, "CL") # L/h
#' Dose : depuis `ruxodata`
DOSE <- ruxodata$AMT[ruxodata$EVID==1] # mg
#ou depuis
get_data(ruxo_est)
DOSE <- get_data(ruxo_est)$amt[get_data(ruxo_est)$evid==1] # mg
AUC <- DOSE / CL # mg/L.h
AUC <- 1000 * DOSE / CL # ng/mL.h
AUC
paste("Clairance du patient:", round(CL), "L/h, et AUC =", round(AUC), "ng/mL.h")

#' Dans une fonction: ?
ecrire_commentaire_CL <- function(est){
}


#' 2. Concentration au temps T=0, T=2.5 ou T=11.9
ruxo_est %>%
  as.data.frame() %>%
  filter(time == 0) %>%
  select(time, DV, PRED, IPRED)

#' Dans une fonction ?
tableau_predictions <- function(est){
}


#' 3. Concentration au temps TX... 8h ?
#' Necessite de faire des simulations: use_posterior()
ruxo_est %>%
  use_posterior() %>%
  data_set(ruxodata) %>%
  mrgsim(start = 0, end = 24,
         obsaug = TRUE) %>% #OBSservation AUGmentation = ajouter temps si utilisation de "data_set()"
  filter(TIME == 8) %>%
  select(DV)


#' 4. %Temps au-dessus de 100 ng/mL ?
simu4 <- ruxo_est %>%
  use_posterior() %>%
  data_set(ruxodata) %>%
  mrgsim(start = 0, end = 12,
         delta = 0.01, # <- petit delta
         obsaug = TRUE)

simu4 %>%
  summarise(ProportionTempsAuDessusDe100 = mean(DV > 100),
            TempsAuDessusDe100 = 12 * ProportionTempsAuDessusDe100)

#' 5. Plusieurs nouveaux schemas posologiques ?
toutes_poso_ruxo <- expand.ev(amt = c(5, 10, 15, 20), ii = c(12, 24), ss = 1)

#' 5.1 Pour une concentration a un temps precis.
sum51 <- ruxo_est %>%
  use_posterior() %>%
  ev(toutes_poso_ruxo) %>%
  mrgsim(recsort = 3, start = 0, end = 0, obsonly = TRUE)
toutes_poso_ruxo %>%
  select(amt, ii) %>%
  mutate(conc = round(sum51$DV, 2))

# Dans une fonction ?
tableau_simulations <- function(est){
}

#' 5.2 Pour un temps au-dessus d'un seuil.
ruxo_est %>%
  use_posterior() %>%
  ev(toutes_poso_ruxo) %>%
  mrgsim(recsort = 3, start = 0, end = 24, delta = 0.01, obsonly = TRUE) %>%
  group_by(ID) %>%
  summarise(ProportionTempsAuDessusDe100 = mean(DV > 100),
            TempsAuDessusDe100 = 24 * ProportionTempsAuDessusDe100)
