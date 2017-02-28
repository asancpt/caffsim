UnitTable <- read.csv("data-raw/UnitCSV.csv", as.is = TRUE)

CaffSigma <- matrix(c(0.1599, 6.095e-2, 9.650e-2, 
                      6.095e-2, 4.746e-2, 1.359e-2, 
                      9.650e-2, 1.359e-2, 1.004), nrow = 3)
CaffMu <- c(0,0,0)

Seed <- sample.int(10000, size = 1)

round_df <- function(x, digits) {
    # round all numeric variables
    # x: data frame 
    # digits: number of digits to round
    numeric_columns <- sapply(x, mode) == 'numeric'
    x[numeric_columns] <-  round(x[numeric_columns], digits)
    x
}

Get_os <- function(){
    sysinf <- Sys.info()
    if (!is.null(sysinf)){
        os <- sysinf['sysname']
        if (os == 'Darwin')
            os <- "osx"
    } else { ## mystery machine
        os <- .Platform$OS.type
        if (grepl("^darwin", R.version$os))
            os <- "osx"
        if (grepl("linux-gnu", R.version$os))
            os <- "linux"
    }
    tolower(os)
}

devtools::use_data(CaffSigma, 
                   CaffMu,
                   Seed,
                   round_df,
                   Get_os,
                   internal = TRUE, overwrite = TRUE)
devtools::use_data(UnitTable, overwrite = TRUE)

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

caffsim::Dataset(Weight = 20, Dose = 200, N = 1000) 
caffsim::DatasetMulti(Weight = 20, Dose = 200, N = 1000, Tau = 12) 

remove.packages("caffsim")


devtools::install_github("asancpt/caffsim")
