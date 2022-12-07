# App1 : Basic App
hist(rnorm(n = 90), main = "Distribution normale", col = "grey")
hist(rnorm(n = 500), main = "Distribution normale", col = "grey")

# App2 : A partir de App1, ajouter un input pour changer la couleur
hist(rnorm(n = 500), main = "Distribution normale", col = "red")
hist(rnorm(n = 500), main = "Distribution normale", col = "blue")
hist(rnorm(n = 500), main = "Distribution normale", col = "green")

# App3 : A partir de App2, ajouter un output pour calculer la moyenne reelle
values <- rnorm(n = 500)
mean(values)
hist(values, main = "Distribution normale", col = "green")

# App4 : A partir de App3, ajouter un bouton "Go!"
