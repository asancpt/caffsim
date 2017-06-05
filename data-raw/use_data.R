# use_data ----------------------------------------------------------------

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
                   UnitTable,
                   internal = TRUE, overwrite = TRUE)

