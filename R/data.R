#' Unit data of PK parameters
#'
#' A dataset containing information regarding unit data of pharmacokinetic parameters
#'
#' @format A data frame with 16 rows and 2 variables:
#' \describe{
#'   \item{Parameters}{Abbreviated pharmacokinetic parameters}
#'   \item{Parameter}{Pharmacokinetic parameters in full name}
#' }
#' @seealso \url{https://asancpt.github.io/caffsim}
#' @export

"UnitTable"

globVar <- utils::globalVariables(c('CL', 'V', 'Ka', 'Ke', 'x', 'y', 'Time', 'Subject', 'Conc', 'AI', 'AUC', 'Aavss', 'Cavss', 'Cmax', 'Cmaxss', 'Cminss', 'ConcOrig', 'ConcTemp', 'Half_life', 'Tmax', 'X1', 'X2', 'X3', 'eta1', 'eta2', 'eta3'))
