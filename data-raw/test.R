# Tests -------------------------------------------------------------------

Weight <- 20
Dose <- 400
N <- 20
Tau <- 8

edisonlib <- c("mgcv", "psych", "ggplot2", "dplyr", "markdown", "knitr", "tibble")
lapply(edisonlib, function(pkg) {
    if (system.file(package = pkg) == '') install.packages(pkg)
})
lapply(edisonlib, library, character.only = TRUE) # if needed # install.packages(mylib, lib = localLibPath)

library(roxygen2)
roxygenize()

remove.packages("caffsim")
devtools::install_github("asancpt/caffsim")
