library(tidyverse)

#' Tidyverse = un package qui contient plusieurs packages
#' Utiles +++ pour mettre en forme et analyser des donnees, faires des figures, programmer...
#' Fonctionnent de maniere homogene ensemble
#' ==> https://r4ds.had.co.nz/

#' Jeu de donnees exemple
Theoph
head(Theoph)

#' 1) tibble = "comme des data.frame mais en mieux"
Theoph2 <- as_tibble(Theoph)
Theoph2

#' 2) dplyr = manipuler des donnees
#' 2.1) filter = ne GARDER que certaines LIGNES
#' Premier argument: TOUJOURS le jeu de donnees
#' Arguments suivants: une (des) condition(s) qui rend(ent) `TRUE`

filter(Theoph2, Subject == 2)
filter(Theoph2, Time !=0 , Wt >= 79)

#' L'equivalent en "R de base" serait:

Theoph2[Theoph2$Subject==2,]
Theoph2[Theoph2$Time != 0 & Theoph2$Wt >= 79,]

#' 2.2) select = ne GARDER que certaines COLONNES
#' Premier argument: TOUJOURS le jeu de donnees
#' Arguments suivants: noms des colonnes
select(Theoph2, Time, conc)

#' L'equivalent en "R de base" serait:
Theoph2[,c("Time", "conc")]

#' 2.3) mutate = MODIFIER ou CREER une COLONNE
#' Premier argument: TOUJOURS le jeu de donnees
#' Arguments suivants: colonne(s) a MODIFIER ou CREER
mutate(Theoph2, Minutes = Time * 60, conc = log(conc))

#' L'equivalent en "R de base" serait:
Theoph2$Minutes <- Theoph2$Time * 60
Theoph2$conc <- log(Theoph2$conc)

#' Pas tout a fait equivalent... car assignation avec <- !
print(Theoph2)
Theoph2 <- as_tibble(Theoph)

#' Si je veux appliquer ces trois fonctions l'une apres l'autres, deux strategies
#' soit, 1, je cree des objets a chaque fois
data1 <- filter(Theoph2, Time !=0 , Wt >= 79)
data2 <- select(data1, Time, conc)
data3 <- mutate(data2, Minutes = Time * 60, conc = log(conc))
data3
#' Ca marche, mais j'ai cree plein d'objets pour rien...
#' soit, 2, j'applique tout d'un coup

mutate(select(filter(Theoph2, Time !=0 , Wt >= 79), Time, conc), Minutes = Time * 60, conc = log(conc))

#' Super mais c'est illisible
#' Utilisation du PIPE : %>%

#' 3) magrittr : le PIPE %>%
#' Le principe : ce qui est AVANT le PIPE est utilise comme 1er argument de la fonction APRES le pipe
2 %>% log()
#' est equivalent a
log(2)


#' L'interet est de pouvoir enchainer les fonctions
2 %>%
  log() %>%
  sqrt() %>%
  exp()

#' est equivalent a
exp(sqrt(log(2)))

#' Surtout pratique avec les tableaux de donnees et fonctions de dplyr. Si on reprend l'exemple:
mutate(select(filter(Theoph2, Time !=0 , Wt >= 79), Time, conc), Minutes = Time * 60, conc = log(conc))

#' On peut le reecrire
Theoph2 %>%
  filter(Time !=0 , Wt >= 79) %>%
  select(Time, conc) %>%
  mutate(Minutes = Time * 60, conc = log(conc))


#' dplyr :
#' group by et summarise pour les stats descriptives
Theoph2 %>%
  mutate(N = rep(1:11, 12)) %>%
  group_by(N) %>%
  summarise(
    Time = mean(Time),
    Mean = mean(conc)
    )
