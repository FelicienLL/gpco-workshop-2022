#' R : Rappels de Base.

#' Assigner
1 + 1
a <- 1 + 1
a
a + 1
a
a <- a + 1
a

#' Fonctions
exp(x = 1)
exp(a)
rnorm(n = 10, mean = 0, sd = 1)
rnorm(10, 0, 1)

#' Package
#' 1. INSTALLER
#' install.packages("mapbayr")
(.packages())
#' 2. CHARGER
library(mapbayr)
(.packages())

library(tidyverse)
(.packages())

#' Pipe
log(10)
#' CTRL + SHIFT + M
10 %>%
  log()

exp(sqrt(log(10)))
10 %>%
  log() %>%
  sqrt() %>%
  exp()
