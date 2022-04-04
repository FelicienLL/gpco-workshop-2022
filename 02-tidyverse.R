library(tidyverse)

#' Tidyverse = un package qui contient plusieurs packages
#' Utiles +++ pour mettre en forme et analyser des donnees, faires des figures, programmer...
#' Fonctionnent de maniere homogene ensemble
#' ==> https://r4ds.had.co.nz/

#' Jeu de donnees exemple
Theoph
head(Theoph)

#' 1) tibble = "comme des data.frame mais en mieux"
Theoph <- as_tibble(Theoph)
Theoph

#' 2) dplyr = manipuler des donnees
#' 2.1) filter = ne GARDER que certaines LIGNES
#' Premier argument: TOUJOURS le jeu de donnees
#' Arguments suivants: une (des) condition(s) qui rend(ent) `TRUE`

filter(Theoph, Subject == 1)
filter(Theoph, Time !=0 , Wt >= 79)

#' 2.2) select = ne GARDER que certaines COLONNES
#' Premier argument: TOUJOURS le jeu de donnees
#' Arguments suivants: noms des colonnes
select(Theoph, Time, conc)

#' 2.3) mutate = MODIFIER ou CREER une COLONNE
#' Premier argument: TOUJOURS le jeu de donnees
#' Arguments suivants: colonne(s) a MODIFIER ou CREER
mutate(Theoph, Minutes = Time * 60, conc = log(conc))


#' Si je veux appliquer ces trois fonctions l'une apres l'autres, deux strategies
#' soit, 1, je cree des objets a chaque fois
data1 <- filter(Theoph, Time !=0 , Wt >= 79)
data2 <- select(data1, Time, conc)
data3 <- mutate(data2, Minutes = Time * 60, conc = log(conc))
data3
#' Ca marche, mais j'ai cree plein d'objets pour rien...
#' soit, 2, j'applique tout d'un coup

mutate(select(filter(Theoph, Time !=0 , Wt >= 79), Time, conc), Minutes = Time * 60, conc = log(conc))

#' Super mais c'est illisible
#' Utilisation du PIPE : %>%

#' 3) magrittr : le PIPE %>%
#' Le principe : ce qui est a gauche du PIPE est utilise comme 1er argument de la fonction apres le pipe
2 %>%
  log()
#' est equivalent a
log(2)


#' L'interet est de pouvoir enchainer les fonctions
2 %>%
  log() %>%
  sqrt() %>%
  exp()

#' est equivalent a
exp(sqrt(log(2)))

# Surtout pratique avec les tableaux de donnees et fonctions de dplyr. Si on reprend l'exemple:
mutate(select(filter(Theoph, Time !=0 , Wt >= 79), Time, conc), Minutes = Time * 60, conc = log(conc))

# On peut le reecrire
Theoph %>%
  filter(Time !=0 , Wt >= 79) %>%
  select(Time, conc) %>%
  mutate(Minutes = Time * 60, conc = log(conc))


# dplyr :
# group by et summarise pour les stats descriptives
Theoph %>%
  mutate(N = rep(1:11, 12)) %>%
  group_by(N) %>%
  summarise(
    Time = mean(Time),
    Mean = mean(conc)
    )
