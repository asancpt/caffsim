#' Run Shiny app to interactively simulate single and multiple dosing for plasma caffeine concentration
#' 
#' \code{caffShiny} runs an internal shiny app \code{Caffeine Concentration Predictor} in order to interactively simulate plasma caffeine concentration.
#' 
#' @return NULL
#' @export
#' @import shiny
#' @seealso \url{https://asan.shinyapps.io/caff/}

caffShiny <- function() {
  appDir <- system.file("shiny-examples", package = "caffsim")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `caffsim`.", call. = FALSE)
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}
