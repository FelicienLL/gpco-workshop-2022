#' 1) Principe de R : utiliser des functions sur des objets :
#' function : sqrt (square root)
#' objet : 4

sqrt(4)

#' Les functions admettent un ou plusieurs arguments, separes par des virgules
#' rnorm : tirer au hasard dans une loi normale (r = random, norm = normal)
#' n = 10 echantillons, loi de moyenne m = 0 et d'ecart-type sd = 1

rnorm(n = 10, mean = 0, sd = 1)

#' si arguments non-nommes, R les lit dans l'ordre

rnorm(10, 0, 1)

#' 2) Possibilite de "sauvegarder" les resultats
#' On "assigne" les resultats avec `<-`

k <- log(2)

#' Lire "k est un nouvel object qui prend pour valeur le resultat de `log(2)`"
#' Il s'enregistre dans "l'environnement global" (en haut a droite dans R studio, par defaut)
#' Possibilite de rappeler le resultat ensuite

k
exp(k)

#' Attention, les resultats peuvent etre ecrases

k <- 2
k <- k * 100

#' 3) Types de donnees
#' Retenir qu'il existe differents "types" de donnees dans R:
#' 3.1) "logical" : logique. Vrai ou faux ?
typeof(TRUE)
TRUE
FALSE
T
F


#' 3.2) "numeric": Les nombres... Qui en fait se divisent en 2 "sous-categories"
#' Les nombres a virgules : "double" (pour double precision digits)
#' /!\ ne veut pas dire 2 chiffres apres la virgule !
typeof(1)
typeof(1.23456789)

#' Les nombres entiers : "integer"
typeof(1L)
123L

#' 3.3) Les "character" : caracteres, entre guillemets
typeof("bonjour")
typeof("1")

#' 3.4) Les "factor": generalement des caracteres, mais enregistres avec differents niveaux
#' Permet "d'ordonner" des caracteres. Par exemple
mes_donnees <- c("moyen", "petit", "infiniment grand", "minuscule", "grand")
sort(mes_donnees) # sort = trier

mes_facteurs <- factor(x = mes_donnees, levels = c("minuscule", "petit", "moyen", "grand", "infiniment grand"))
sort(mes_facteurs)


#' 4) Structures de donnees
#' 4.1) Valeur unique
1
"salut"
#' 4.2) Vecteur
#' se cree avec `c()`

vec <- c(1, 23, 456)
vec
length(vec)
#' C'est une structure de base dans R "langage vectorisé"!
#' Pas besoin de faire
sqrt(1)
sqrt(23)
sqrt(456)
#' La majorite des fonctions peuvent etre utilisees avec des vecteurs
sqrt(vec)
vec * 10
vec + c(1, 10, 100)

#' Au sein d'un vecteur, tous les elements sont du meme type
c("salut", "ca va ?", "oui", "et toi ?")
c(TRUE, 1234, "hello") #tout s'est converti en caractere !

#' 4.3) data.frame = "tableau"
data.frame(A = 10:15, B = c("a", "b", "c", "d", "e", "f"))
#' Forcement rectangulaire...
try(data.frame(A = 1:6, B = 1:4))

#' 4.4) Liste
#' Un peu le meme principe qu'un vecteur, mais peut acceuillir tout type d'objets
L <- list(A = 1:6, B = "bonjour", C = log, list())
L
# Dans cette liste, 4 elements : un vecteur de 6 valeurs numeriques, un charactere, une fonction et une liste vide

#' 4.5) Extraire des donnees
#' 4.5.1) Au sein d'un vecteur: `[]`
#' Par les "indices" = POSITION au sein du vecteur

ligue1 <- c("paris", "marseille", "lorient", "lens", "monaco",  "lyon", "lille", "rennes", "montpellier", "troyes")
#' ligue1 = villes top 10 de la Ligue 1 au 21 septembre 2022

ligue1
ligue1[2]
ligue1[c(1,3)]
ligue1[-10]
ligue1[999]

#' ou avec un vecteur logique de la meme longueur
c(TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE)

ligue1[c(TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE)]

which(c(TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE))

ligue1 == "marseille"

#' Pour l'exemple : la fonction grepl peut repondre a la question : y'a-t-il, oui ou non (TRUE or FALSE)
#' un MOTIF (pattern) dans l'element a analyser (x)

grepl(pattern = "a", x = "axitinib")
grepl("a", c("axitinib", "bosutinib", "cabozantinib", "dasatinib", "erlotinib"))

#' comment repondre a la question suivante : je ne veux que les club de ligue 1 avec au moins un L dans le nom ?
grepl("l", ligue1)
ligue1[grepl("l", ligue1)]


#' 4.5.2) Au sein d'un data.frame : `$` ou `[,]`.
dataset <- data.frame(A = 1:10, B = seq(10, 100, 10), C = c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j"))
dataset

#' Les colonnes d'un data.frame ont toujours un nom.
#' On peut extraire une colonne avec `$`

dataset$A   # On a desormais un vecteur !
dataset$B
try(dataset$D) #colonne inexistante
try(dataset$1) #ne marche qu'avec des NOMS de colonnes, pas les INDICES/POSITIONS

#' On peut aussi utiliser les crochets `[,]`
#' Avant la virgule : LIGNE(S)
#' Après la virgule : COLONNE(S)

dataset[,"A"] #colonne nommee "A"
dataset[,3] #troisieme colonne
dataset[c(1,3,9),c("A", "C")] #que les lignes 1, 3 et 9 et les colonnes A et C

dataset$C[dataset$A<5] #?

#' `$`, `[]` ou `[]` peuvent aussi etre combines avec `<-` pour modifier les valeurs
ligue1
ligue1[1]
ligue1[1] <- "toulouse"
ligue1

dataset
dataset$D <- 99:108
dataset
dataset[c(3, 5, 9), "B"] <- -111
dataset

#' 5) Package
#' Un ensemble d'objet, generalement des FONCTIONS que l'on va vouloir utiliser pour une tache particuliere
#' Stats, visualisation, simulations et estimation PK, appli web...
#' Mais peuvent aussi contenir des donnees, et plein d'autre choses imaginables...
#'
#' Pour pouvoir etre utilises, deux etapes :
#' - Premierement: l'INSTALLATION = vous devez avoir les fichiers dans votre ordinateur
#' Generalement, on le fait 1 seule fois (ou quand on réinstalle R, ou quand on veut mettre a jour le package)
#' Generalement, on les installe depuis le CRAN = la "bibliotheque" officielle des package R.
#' Il faut executer `install.packages(...)` ou utiliser la fenetre en bas a droite dans RStudio
#'
#' - Deuxiemement: CHARGER le package.
#' Generalement, on le fait a chaque fois qu'on ouvre R.
#' Generalement, on le fait au tout debut du script que l'on ecrit, avec la fonction `library()`
#'
#' Quand on ouvre R, R charge par defaut une petite dizaine de package essentiels
#' On appelle ca le "R de base" (base R)
(.packages())
library(mapbayr)
(.packages())
