library(mapbayr)
simpledata <- read.csv("simpledata.csv", na = ".")
simpledata
mrgsim(simple, simpledata)

#' Pour pouvoir utiliser le modele dans mapbayr, 5 modifications a faire:
#' 1- Dans $PARAM. Ajouter des parametres ETA1, ETA2 etc... que l'on veut estimer
#' 2- Dans $MAIN. Ajouter ces ETA1, ETA2 etc... dans la definition de CL, V...
#' 3- Dans $SIGMA : Erreur proportionnelle en PREMIER, Erreur additive en DEUXIEME.
#' 4- Dans $CAPTURE : La concentration predite doit etre DV.
#' 5- Dans $CAPTURE : Capturer les variables qui vous interesse : CL, V ?

#' Modifier simple2.cpp en simple2_mapbay.cpp
simple2_mapbay <- mread("models/simple2_mapbay.cpp")
check_mapbayr_model(simple2_mapbay)

est <- mapbayest(simple2_mapbay, simpledata)

est
plot(est, PREDICTION = "IPRED")
hist(est)
as.data.frame(est)

get_data(est)
get_eta(est)
CL <- get_param(est, "CL")
unique(dplyr::as_tibble(est)$CL)

dose <- simpledata$AMT[simpledata$EVID == 1]
AUC <- dose / CL
AUC
