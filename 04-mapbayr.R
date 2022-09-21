library(mapbayr)
#' Principe de mapbayr:
#' 1) coder son modele MRGSOLVE dans un fichier (".cpp")
#' 2) Le modifier legerement pour qu'il soit utilisable avec MAPBAYR
#' 3) L'importer dans R
#' 4) Formatter ses donnees (concentrations, administration)
#' 5) Faire des estimations MAP-BAYESIENNE

mod4 <- mread("models/fichiermodele4.cpp")

data4 <- data.frame(
  ID = 1,
  time = c(0, 2,  6, 15),
  evid = c(1, 0, 0, 0),
  cmt = c(1, 2, 2, 2),
  amt = c(1000, 0, 0, 0),
  DV = c(NA, 24.2, 27.1, 17.2)
)

data4

est <- mapbayest(mod4, data4)
est
as.data.frame(est)
as_tibble(est)
plot(est, end = 24)
hist(est)

#' Des fonctions existent pour directement mettre en forme le jeu donnees

mod4 %>%
  adm_lines(amt = 1000, cmt = 1) %>%
  obs_lines(time = c(2, 6, 15), DV = c(24.2, 27.1, 17.2), cmt = 2) %>% # get_data()
  mapbayest()

#' Comment utiliser les resultats des estimation
#' 1) Simplement repredire une Cmin a T24
#' Ajouter le temps avec MDV = 1 dans le jeu de donnees
mod4 %>%
  adm_lines(amt = 1000, cmt = 1) %>%
  obs_lines(time = c(2, 6, 15), DV = c(24.2, 27.1, 17.2), cmt = 2) %>%
  obs_lines(time = 24, DV = NA, mdv = 1, cmt = 2) %>% # get_data()
  mapbayest()

#' 2) Simuler des schemas posologiques
#' Fonction : `use_posterior()`
#' Prend le resultat d'une estimation, et retourne le modele mrgsolve "mis a jour" pour le patient

updated_mod <- est %>%
  use_posterior()

updated_mod
updated_mod %>%
  param()

updated_mod %>%
  ev(expand.ev(amt = c(300, 1000, 3000, 10000, 30000))) %>%
  mrgsim(start = 24, end = 24, obsonly = TRUE)


#' 3) Calculer une AUC
CL <- get_param(est, "CL")
#' ou
CL <- as.data.frame(est)[1,"CL"]
AUC <- 1000 / CL
AUC


# Cas pratique: RUXOLITINIB
# Covariable
# IOV
# CV% to omega variance
# correlation ?
# error additive
# ==> unite ?
