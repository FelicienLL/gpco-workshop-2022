#' 1) Principe de R : utiliser des functions sur des objets :
#' function : sqrt (square root)
#' objet : 4

sqrt(4)

#' Les functions admettent un ou plusieurs arguments, separes par des virgules
#' rnorm : tirer au hasard dans une loi normale (r = random)
#' n = 10 echantillons, loi de moyenne m = 0 et d'ecart-type sd = 1

rnorm(n = 10, mean = 0, sd = 1)

#' si arguments non-nommes, R les lit dans l'ordre

rnorm(10, 0, 1)

#' 2) Possibilite de "sauvegarder" les resultats
#' On "assigne" les resultats avec `<-`

k <- log(2)

#' Lire "k un nouvel object qui prend pour valeur le resultat de `log(2)`"
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

vec <- c(1,23, 456)
vec
length(vec)
#' Structure de base dans R !
#' Pas besoin de faire
sqrt(1)
sqrt(23)
sqrt(456)
#' La majorite des fonctions peuvent etre utilisees avec des vecteurs
sqrt(vec)

#' Au sein d'un vecteur, tous les elements sont du meme type

c("salut", "ca va ?", "oui", "et toi ?")
c(1234, "hello") #tout s'est converti en caractere !

#' 4.3) data.frame = "tableau"
data.frame(A = 1:6, B = c("a", "b", "c", "d", "e", "f"))
#' Forcement rectangulaire...
data.frame(A = 1:6, B = 1:4)

#' 4.4) Liste
#' Un peu le meme principe qu'un vecteur, mais peut acceuillir tout type d'objets
L <- list(A = 1:6, B = "bonjour", C = log, list())
# Dans cette liste, 4 elements : un vecteur de 6 valeurs numeriques, un charactere, une fonction et une liste vide
L[[1]]
L[["B"]]


