# Install these packages
# Can be quite long...

# If you use R < 4.0
# 1) It is a bad idea. Try to install R > 4.0.
# 2) Otherwise, answer "no" if you get asked to install "source version that requires compilation".

install.packages("tidyverse")
install.packages("mrgsolve")
install.packages("mapbayr")
install.packages("shiny")

# Check if installation is succesful
Sys.which("make")

# You should obtain something like:
# "C:\\rtools40\\usr\\bin\\make.exe"

# Otherwise, for windows users :
# go to: https://cran.r-project.org/bin/windows/Rtools/rtools40.html
# write('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', file = "~/.Renviron", append = TRUE)

packageVersion("mapbayr")



