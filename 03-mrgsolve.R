library(mrgsolve)
#' Principe de mrgsolve:
#' 1) coder son modele dans un fichier (".cpp")
#' 2) L'importer dans R
#' 3) L'utiliser pour faire des simulations

#'-------------- PRESENTATION MRGSOLVE -------------
#'   --- Fonctionnement ---
#' 1) Un modele: simple

mod1 <- mread("models/fichiermodele1.cpp")

mod1

#' Quelle donnees ?

data1 <- data.frame(
  ID = 1,
  time = c(0, 2, 6, 12, 24),
  evid = c(1,0,0,0,0),
  cmt = c(1,2,2,2,2),
  amt = c(1000,0,0,0,0)
)

data1

mrgsim(mod1, data1)

#' OU
mod1 %>%
  data_set(data1) %>%
  mrgsim()

mrgsim(mod1, data1) %>% plot()
mrgsim(mod1, data1) %>% plot("CP")

#' "Incoveniant" : necessite de creer "a la main" son data set en amont
#' Peu pratique...
#'
#' * Powerpoint *
#'
#' Solution : On separe :
#' 1) D'une part les EVENEMENTS que je veux simuler, ici les DOSES administrees
#' ==> fonction `ev()`
#' 2) D'autre part : la SEQUENCE de simulation, c'est-a-dire de QUAND a QUAND
#' ==> arguments `start`, `delta` et `end`

ev(amt = 5000)

mod1 %>%
  ev(amt = 5000) %>%
  mrgsim(start = 0, end = 48, delta = .1)

mod1 %>%
  ev(amt = 5000) %>%
  mrgsim(start = 0, end = 48, delta = .1) %>%
  plot()

#' Administrations multiples
mod1 %>%
  ev(amt = 1000, addl = 6, ii = 24) %>%
  mrgsim(start = 0, end = 168, delta = .1) %>%
  plot()

mod1 %>%
  ev(amt = 1000, addl = 6, ii = 24) %>%
  mrgsim(start = 0, end = 168, delta = .1) %>%
  plot("CP")

#' --- MODIFICATION DES VALEURS DE PARAMETRES
#'
#' Je veux simuler en changeant la valeur de clairance.
#' Plusieurs possibilites:
#'
#' 1) Retourner dans le code (fichier .cpp), puis le reimporter avec `mread()`
#' ==> Possible mais non conseille car...
#'
#' 2) On peut le faire dans R directement !
#' ==> En modifiant les valeurs definies dans `$PARAM`
#' ==> fonction `param()`
#' Permet de VOIR les valeurs de parametres:

param(mod1)

mod1 %>%
  param()

as.double(param(mod1))

#' Et permet de MODIFIER les valeurs de parametres
#' Il suffit de rajouter un argument, par exemple `CL = 3`
param(mod1, CL = 3)

#' Retourne cette fois un MODELE mrgsolve avec la nouvelle valeur de CL
mod1 %>%
  param(CL = 3) %>%
  param()

#' ATTENTION, ne pas oublier qu'on a RIEN sauvegarde ici !

param(mod1) #on a toujours CL = 1

# Il faut assigner le nouveau resultat

mod1bis <- mod1 %>%
  param(CL = 999)
param(mod1bis)

mod1 %>%
  param(CL = 3) %>%
  ev(amt = 1000, addl = 6, ii = 24) %>%
  mrgsim(start = 0, end = 168, delta = .1) %>%
  plot("CP")

#' Au besoin, on peut aussi utiliser une colonne `CL` dans le jeu de donnees

data1bis <- data1 %>%
  mutate(CL = 3)

#' Au moment de simuler, cette valeur dans les donnees va etre utilisee a la place de celle
#' definie dans `$PARAM` ou par `param()`

mod1 %>%
  data_set(data1bis) %>%
  mrgsim() %>%
  plot("CP")

#' Que faire quand on on veut simuler plusieurs CL ?
#' On peut creer un jeu de donnees tel que :

data12 <- bind_rows(data1, mutate(data1, ID = 2)) %>%
  mutate(CL = rep(c(0.1, 1), each = nrow(data1)))

data12

mod1 %>%
  data_set(data12) %>%
  mrgsim() %>%
  plot("CP")

#' Mais la aussi, par tres pratique de devoir creer tout un jeu de donnes
#' Plus simple : utiliser la fonction `idata_set()`
#' Utile pour passer un tableau supplementaire avec les caracteristiques des patients.

idata1 <- data.frame(
  ID = 1:4,
  CL = c(0.1, 0.2, 0.5, 1)
)
idata1

mod1 %>%
  idata_set(idata1) %>%
  ev(amt = 1000, addl = 6, ii = 24) %>%
  mrgsim(start = 0, end = 168, delta = .1) %>%
  plot("CP")

#' Multiples possibilites
#' fonction : `expand.idata()`
#' Creer un tableau qui croise toutes les possibilites
#' ici 4 volumes x 4 clairances = 16 possibilites
idata2 <- expand.idata(
  CL = c(0.1, 0.2, 0.5, 1),
  V = c(5, 10, 20, 50)
)
idata2

mod1 %>%
  idata_set(idata2) %>%
  ev(amt = 1000, addl = 6, ii = 24) %>%
  carry_out(CL, V) %>%                          # <-- fonction carry_out, pour qu'il me ressorte CL et V a la fin
  mrgsim(start = 0, end = 168, delta = .1) %>%
  plot(CP~time|as.factor(CL))


#' 2) Variabilite inter-individuelle (IIV)

mod2 <- mread("models/fichiermodele2.cpp")

#' On verifie ?
#' function : `omat()` "OMEGA MATRIX"
#' comme avec `param()`, permet de VOIR ou MODIFIER la matrice OMEGA

omat(mod1)
omat(mod2)

#' 1 patient
mod2 %>%
  ev(amt = 1000) %>%
  mrgsim(start = 0, end = 48, delta = .1) %>%
  plot("CP")

#' Plusieurs patients:  nid = XX ?
mod2 %>%
  ev(amt = 1000) %>%
  mrgsim(start = 0, end = 48, delta = .1, nid = 10) %>%
  plot("CP")

#' 3) Variabilite residuelle (RUV)

mod3 <- mread("models/fichiermodele3.cpp")

#' On verifie ?
#' function : `smat()` "SIGMA MATRIX"
#' comme avec `param()` ou `omat()`, permet de VOIR ou MODIFIER la matrice SIGMA

smat(mod3)

#' 1 patient
mod3 %>%
  ev(amt = 1000) %>%
  mrgsim(start = 0, end = 48, delta = 4) %>% #toutes les 4 heures
  plot("CP")

#' Plusieurs patients:  nid = XX ?
mod3 %>%
  ev(amt = 1000) %>%
  mrgsim(start = 0, end = 48, delta = 4, nid = 10) %>%
  plot("CP")

#' Simple de coder un modele avec IIV et RUV, mais comment "revenir en arriere",
#' c'est a dire simuler SANS effet aleatoire (IIV et ou RUV)
#' function `zero_re()`: zero random effects

mod3 %>%
  revar() # see random effect variables

mod3 %>%
  zero_re() %>%
  revar()

#' Ne mettre que la variabilite residuelle a zero ?

mod3 %>%
  zero_re("sigma") %>%
  revar()

#' 4) Application: tester des schemas posologiques

#' On souhaite connaitre la dose la plus adaptee sachant :
#' -  que l'on dispose d'un modele de PK pop qui décrit la PK typique + variabilites PK
#' -  que l'on a une cible therapeutique, par exemple: efficacite si conc a T24h > 100

#' On va simuler different niveaux de doses
#' A chaque fois sur n patients... et on voit quelle proportion satisfait le critere

#' function : `expand.ev()`
#' Cette fonction permet de spécifier des evenements (par exemple, en CROISANT les ID et AMT)
#' ex: Cinq niveaux de dose, a chaque fois sur 5 patients
scenarios <- expand.ev(ID = 1:5, amt = c(300, 1000, 3000, 10000, 30000))

#' ca rend un tableau de 5x5 = 25 patients
scenarios

mod2 %>%
  ev(scenarios) %>%
  mrgsim() %>%
  plot("CP", logy = TRUE)

#' on va maintenant simuler n = 1000 patients au lieu de 5 par groupe

scenarios2 <- expand.ev(ID = 1:1000, amt = c(300, 1000, 3000, 10000, 30000)) %>%
  mutate(DOSE = amt)
head(scenarios2)
nrow(scenarios2)

#' gros fichier a simuler, on l'enregistre : "sims"
sims <- mod2 %>%
  ev(scenarios2) %>%
  mrgsim(start = 0, end = 24, delta = 1, obsonly = TRUE, carry_out = "DOSE")

#' `sims` n'est pas vraiment un tableau, mais un "mrgsims"...
#' Pour obtenir un "vrai" tableau, il fallait simuler avec :
#' `mrgsim_df(...)` ou specifier `mrgsim(output = "df")`
#' Sinon, on peut toujours demander apres coup:
sims@data
as.data.frame(sims)
as_tibble(sims)

#' On a un tableau avec les concentrations en fonction du temps pour 5000 patients
#' On a plus qu'a l'analyser... par exemple avec dplyr

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

#' Representation graphique
#' Tous les profils PK ? ...

sims %>%
  as_tibble() %>%
  ggplot(aes(time, CP, group = ID)) +
  geom_line()+
  facet_grid(.~DOSE) +
  scale_y_log10()

#' Pas d'interet et long +++ a representer
#' Plutot representer les quantiles

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
  scale_y_log10() +
  geom_hline(yintercept = 100, linetype = 2)
