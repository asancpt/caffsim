#' Create a dataset for simulation of single dose of caffeine 
#'
#' \code{Dataset} will create a dataset for simulation of single dose of caffeine 
#' 
#' @param Weight Body weight (kg)
#' @param Dose Dose of single caffeine (mg)
#' @param N The number of simulated subjects
#' @return The dataset of pharmacokinetic parameters of subjects after single caffeine dose following multivariate normal
#' @export
#' @examples 
#' Dataset(Weight = 20, Dose = 200, N = 20)
#' Dataset(20,500)
#' @seealso \url{http://asancpt.github.io/CaffeineEdison}
#' @importFrom mgcv rmvn
#' @import dplyr

Dataset <- function(Weight, Dose, N = 20){
  MVN <- rmvn(N, CaffMu, CaffSigma);  
  MVNdata <- data.frame(MVN, stringsAsFactors = FALSE) %>% 
    select(eta1 = X1, eta2 = X2, eta3 = X3) %>% 
    mutate(CL = 0.09792 * Weight * exp(eta1), # L/hr
           V  = 0.7219 * Weight * exp(eta2), # L, TVV =THETA[2] * (1 + ABST*THETA[7]) [1] 0.7218775
           Ka = 4.268 * exp(eta3), # /hr
           Ke = CL / V) %>%  
    mutate(Tmax = (log(Ka) - log(Ke)) / (Ka - Ke),
           Cmax = Dose / V * Ka / (Ka - Ke) * (exp(-Ke * Tmax) - exp(-Ka * Tmax)), 
           AUC  = Dose / CL, # mg/h/L
           Half_life = 0.693 / Ke) %>% select(Tmax, Cmax, AUC, Half_life, CL, V, Ka, Ke)
  return(MVNdata)
}
