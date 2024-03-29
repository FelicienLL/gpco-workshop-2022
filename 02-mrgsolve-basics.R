library(mrgsolve)

#' 1. Bases

simple <- mread("models/simple.cpp")

simple %>%
  ev(amt = 100) %>% # ev = evenement = une dose.
  mrgsim()

simple %>%
  ev(amt = 100) %>%
  mrgsim() %>%
  plot()





#' 2. Changer la sequence de simulation

simple %>%
  ev(amt = 100) %>%
  mrgsim(start = 0, end = 96, delta = .1) %>% # <- start, end et delta.
  plot()





#' 3. Modifier les doses

simple %>%
  ev(amt = 100, addl = 3, ii = 24) %>% # <- ADDitionaL doses, Interdose Interval
  mrgsim(start = 0, end = 96, delta = .1) %>%
  plot()

#' Possibilite de creer le "scenario de schema posologique" avant dans un tableau

ev1 <- ev(amt = 100, addl = 3, ii = 24)

simple %>%
  ev(ev1) %>%
  mrgsim(start = 0, end = 96, delta = .1) %>%
  plot()

#' Combiner plusieurs scenarios
#' 100, 200, 300 mg
#' toutes les 12 ou 24 h
ev6 <- expand.ev(amt = c(100, 200, 300), ii = c(12,24), addl = 3)

simple %>%
  ev(ev6) %>%
  mrgsim(start = 0, end = 72, delta = .1) %>%
  plot("CP")

#' Etat d'equilibre
simple %>%
  ev(amt = 100, ss = 1, ii = 24) %>% # <- steady-state = 1 = YES, every 24h
  mrgsim(start = 0, end = 96, delta = .1, recsort = 3) %>% # <- recsort = RECord SORT = 3
  plot()




#' 4. Changement des valeurs de parametres
param(simple) # Juste regarder
param(simple, TVCL = 3) # Modifier : retourne un modele "mis a jour"

simple %>%
  param(TVCL = 1) %>%
  ev(amt = 100) %>%
  mrgsim() %>%
  plot()

#' Idem pour les covariables

simple %>%
  param(BW = 10) %>%
  ev(amt = 100) %>%
  mrgsim() %>%
  plot()

#' 5. Variabilite inter-individuelle et residuelle
#' Changer les matrices OMEGA (0.3, 0.2) et SIGMA (0.04, 0) dans simple.cpp
#' Enregistrer dans simple2.cpp

simple2 <- mread("models/simple2.cpp")
simple2 %>%
  ev(amt = 100) %>%
  mrgsim() %>%
  plot()

simple2 %>%
  ev(amt = 100) %>%
  mrgsim(nid = 10) %>% # <-- nid = 10
  plot()

simple2 %>%
  zero_re() %>% # <-- "zero random effects"
  ev(amt = 100) %>%
  mrgsim(nid = 10) %>%
  plot()

simple2 %>%
  zero_re("sigma") %>% # <-- "zero random effects" dans SIGMA (reste que OMEGA)
  ev(amt = 100) %>%
  mrgsim(nid = 10) %>%
  plot()

simple2 %>%
  zero_re("omega") %>% # <-- "zero random effects" dans OMEGA (reste que SIGMA)
  ev(amt = 100) %>%
  mrgsim(nid = 10) %>%
  plot()




