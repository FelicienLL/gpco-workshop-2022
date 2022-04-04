library(mrgsolve)
#' Principe de mrgsolve:
#' 1) coder son modele dans un fichier (".cpp")
#' 2) L'importer dans R
#' 3) L'utiliser pour faire des simulations

#-------------- PRESENTATION MRGSOLVE -------------
#   --- Fonctionnement ---
# 1) Un modele: simple

mod1 <- mread("models/fichiermodele1.cpp")

# Quelle donnees ?

data1 <- data.frame(ID = 1,
                    time = c(0, 2, 6, 12, 24),
                    evid = c(1,0,0,0,0),
                    cmt = c(1,2,2,2,2),
                    amt = c(1000,0,0,0,0))
data1

mrgsim(mod1, data1)
mrgsim(mod1, data1) %>% plot()
mrgsim(mod1, data1) %>% plot("CP")

# Peu pratique...
# Utilisation de `ev()`

mod1 %>%
  ev(amt = 5000) %>%
  mrgsim(start = 0, end = 48, delta = .1) %>%
  plot()

#Administrations multiples
mod1 %>%
  ev(amt = 1000, addl = 6, ii = 24) %>%
  mrgsim(start = 0, end = 168, delta = .1) %>%
  plot("CP")

# --- MODIFICATION DES VALEURS DE PARAMETRES
# --- dans R directement

# Pour 1 patient
mod1 %>%
  param(CL = 0.1) %>%
  ev(amt = 1000, addl = 6, ii = 24) %>%
  mrgsim(start = 0, end = 168, delta = .1) %>%
  plot("CP")

# Programmer plusieurs patients

idata1 <- expand.idata(CL = c(0.1, 0.2, 0.5, 1))
idata1

mod1 %>%
  idata_set(idata1) %>%
  ev(amt = 1000, addl = 6, ii = 24) %>%
  mrgsim(start = 0, end = 168, delta = .1) %>%
  plot("CP")

# Multiples possibilites
idata2 <- expand.idata(CL = c(0.1, 0.2, 0.5, 1),
                       V = c(5, 10, 20, 50))
idata2

mod1 %>%
  idata_set(idata2) %>%
  ev(amt = 1000, addl = 6, ii = 24) %>%
  carry_out(CL, V) %>%
  mrgsim(start = 0, end = 168, delta = .1) %>%
  plot(CP~time|as.factor(CL))


# 2) Variabilite inter-individuelle

mod2 <- mread("models/fichiermodele2.cpp")

# 1 patient
mod2 %>%
  ev(amt = 1000) %>%
  mrgsim(start = 0, end = 48, delta = .1) %>%
  plot("CP")

# Plusieurs patients:  nid = XX ?
mod2 %>%
  ev(amt = 1000) %>%
  mrgsim(start = 0, end = 48, delta = .1, nid = 10) %>%
  plot("CP")

# 3) Variabilite residuelle

mod3 <- mread("models/fichiermodele3.cpp")

# 1 patient
mod3 %>%
  ev(amt = 1000) %>%
  mrgsim(start = 0, end = 48, delta = 4) %>% #toutes les 4 heures
  plot("CP")

# Plusieurs patients:  nid = XX ?
mod3 %>%
  ev(amt = 1000) %>%
  mrgsim(start = 0, end = 48, delta = 4, nid = 10) %>%
  plot("CP")

# 4) Application: tester des schemas posologiques

# On souhaite connaitre la dose la plus adaptee sachant :
# -  que l'on dispose d'un modele de PK pop qui décrit la PK typique + variabilites PK
# -  que l'on a une cible therapeutique, par exemple: efficacite si conc a T24h > 100

# On va simuler different niveau de doses
# A chaque fois sur n patients... et on voit quelle proportion satisfait le critere

# expand.ev()
# Cette fonction permet de spécifier ce qu'on voudra tester.
# ex: Cinq niveaux de dose, a chaque fois sur 5 patients
scenarios <- expand.ev(ID = 1:5, amt = c(300, 1000, 3000, 10000, 30000))

# ca rend un tableau de 5x5 = 25 patients
scenarios

mod2 %>%
  ev(scenarios) %>%
  mrgsim() %>%
  plot("CP", logy = TRUE)

# on va maintenant simuler n = 1000 patients au lieu de 5 par groupe

scenarios2 <- expand.ev(ID = 1:1000, amt = c(300, 1000, 3000, 10000, 30000)) %>%
  mutate(DOSE = amt)

nrow(scenarios2)

# gros fichier a simuler, on l'enregistre : "sims"
sims <- mod2 %>%
  ev(scenarios2) %>%
  mrgsim(start = 0, end = 24, delta = 1, obsonly = TRUE, carry_out = "DOSE")

# On a un tableau avec les concentrations en fonction du temps pour 5000 patients
# On a plus qu'a l'analyser... par exemple avec dplyr

sims %>%
  as_tibble() %>%
  filter(time == 24) %>%
  group_by(DOSE) %>%
  summarise(
    Q95 = quantile(CP, .95),
    Q50 = quantile(CP, .50),
    Q05 = quantile(CP, .05),
    SUCCESS = sum(CP > 100),
    SUCCESS_PERCENT = scales::percent(SUCCESS/1000)
  )

# Representation graphique
# Tous les profils PK ? ...

sims %>%
  as_tibble() %>%
  ggplot(aes(time, CP, group = ID)) +
  geom_line()+
  facet_grid(.~DOSE) +
  scale_y_log10()

# Pas d'interet et long +++ a representer
# Plutot representer les quantiles

sims %>%
  as_tibble() %>%
  mutate(DOSE = as.factor(DOSE)) %>%
  group_by(DOSE, time) %>%
  summarise(
    Q95 = quantile(CP, .95),
    Q50 = quantile(CP, .50),
    Q05 = quantile(CP, .05)
  ) %>%
  ggplot(aes(time, col = DOSE, fill = DOSE)) +
  geom_line(aes(y = Q50)) +
  geom_ribbon(aes(ymin = Q05, ymax = Q95), alpha = .2) +
  facet_grid(.~DOSE) +
  scale_y_log10()
