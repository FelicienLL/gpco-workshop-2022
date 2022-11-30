#' Creer le modele "models/ruxo.cpp"

#' Importer-le dans R
ruxo <- mread("models/ruxo.cpp")

#' Verification que tout est ok ?
#' Poso ruxo : 5, 10, 15 ou 20 mg, deux fois par jour

# Tous les compartiments ok ?
# Forme de la courbe ?
# Niveau de concentrations ? Attendu 10mg x2 / j: Cmin 10-50 ng/mL ; Cmax 100-200 ng/mL
# Unites ?

poso_ruxo <- ev(amt = 10, ii = 12, ss = 1)
ruxo %>%
  zero_re() %>%
  ev(poso_ruxo) %>%
  mrgsim(end = 24, delta = 0.1, recsort = 3) %>%
  plot() # "'CP'", "logy = TRUE"

# Covariables ok ?
covariables_ruxo <- expand.idata(SEX = c(0, 1), BW = c(30, 60, 90))

covariables_sim <- ruxo %>%
  zero_re() %>%
  idata_set(covariables_ruxo) %>% # <- tester toutes les combinaisons de covariables
  ev(poso_ruxo) %>%
  mrgsim(end = 24, delta = 0.1, recsort = 3,
         carry_out = c("SEX", "BW") # <- SEX et BW dans l'output
         )

plot(covariables_sim) # Graphe avec methode implementee (package {lattice})

covariables_sim %>% #Graph "a la main" : package {ggplot2}.
  as.data.frame() %>%
  ggplot(aes(x = time, y = CP, col = BW, linetype = as.factor(SEX), group = ID)) +
  geom_line() +
  facet_grid(~ BW)

# Variabilite inter-individuelle ?
ruxo %>%
  zero_re("sigma") %>% # sigma=0, juste omega.
  ev(poso_ruxo) %>%
  mrgsim(end = 24, delta = 0.1,  recsort = 3,
         nid = 100 # <- 100 individus
  ) %>%
  plot("CP")

# Variabilite residuelle ?
# surtout pour verifier les unites si erreur additive
ruxo %>%
  zero_re("omega") %>% # omega=0, juste sigma
  ev(poso_ruxo) %>%
  mrgsim(end = 24, delta = 1,  recsort = 3,
         nid = 10 # <- 10 individus
  ) %>%
  plot("CP")






