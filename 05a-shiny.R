faithful
faithful[,2]
vec <- faithful[,2]
hist(vec, breaks = c(40, 45, 60, 90,110))
separateurs <- seq(from = 10, to = 200, length.out = 7)
separateurs
hist(vec, breaks = separateurs)
separateurs <- seq(from = min(vec), to = max(vec), length.out = 7)
hist(vec, breaks = separateurs)
separateurs <- seq(from = min(vec), to = max(vec), length.out = 10)
hist(vec, breaks = separateurs)
