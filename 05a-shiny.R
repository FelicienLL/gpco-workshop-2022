faithful
faithful[,2]
x <- faithful[,2]
hist(x)
hist(x, breaks = c(40, 45, 60, 90,110))
separateurs <- seq(from = 10, to = 200, length.out = 7)
separateurs
hist(x, breaks = separateurs)
separateurs <- seq(from = min(x), to = max(x), length.out = 7)
hist(x, breaks = separateurs)
separateurs <- seq(from = min(x), to = max(x), length.out = 30)
hist(x, breaks = separateurs)

faithful_hist <- function(bins){
  separateurs <- seq(from = min(x), to = max(x), length.out = bins + 1)
  hist(x, breaks = separateurs)
}

faithful_hist()
