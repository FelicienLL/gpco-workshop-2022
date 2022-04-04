# Install these packages
# Can be quite long...

install.packages("tidyverse")
install.packages("mrgsolve")
install.packages("mapbayr")

# Check if installation is succesful
Sys.which("make")

# You should obtain something like:
# "C:\\rtools40\\usr\\bin\\make.exe"

# Otherwise, for windows users :
# go to: https://cran.r-project.org/bin/windows/Rtools/rtools40.html
# write('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', file = "~/.Renviron", append = TRUE)

packageVersion("mapbayr")



