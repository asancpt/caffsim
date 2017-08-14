#' Run shiny app to interactively simulate plasma caffeine concentration.
#' 
#' \code{caffShiny} will run an internal shiny app \code{Caffeine Concentration Predictor} in order to interactively simulate plasma caffeine concentration.
#' 
#' @return shiny app
#' @export
#' @import shiny
#' @seealso \url{https://asan.shinyapps.io/caff/}

caffShiny <- function() {
  appDir <- system.file("shiny-examples", package = "caffsim")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `mypackage`.", call. = FALSE)
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}
