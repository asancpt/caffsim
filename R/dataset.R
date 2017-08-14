#' Create a dataset for simulation of single dose of caffeine 
#'
#' \code{caffDataset} will create a dataset for simulation of single dose of caffeine 
#' 
#' @param Weight Body weight (kg)
#' @param Dose Dose of single caffeine (mg)
#' @param N The number of simulated subjects
#' @return The dataset of pharmacokinetic parameters of subjects after single caffeine dose following multivariate normal
#' @export
#' @examples 
#' caffDataset(Weight = 20, Dose = 200, N = 20)
#' caffDataset(20,500)
#' @importFrom mgcv rmvn
#' @import dplyr
#' @seealso \url{https://asancpt.github.io/caffsim}

caffDataset <- function(Weight, Dose, N = 20){
  MVN <- mgcv::rmvn(N, CaffMu, CaffSigma)
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

#' Create a dataset for simulation of multiple dose of caffeine 
#'
#' \code{caffDatasetMulti} will create a dataset for simulation of multiple dose of caffeine 
#'
#' @param Weight Body weight (kg)
#' @param Dose Dose of multiple caffeine (mg)
#' @param N The number of simulated subjects
#' @param Tau The interval of multiple dosing (hour)
#' @return The dataset of pharmacokinetic parameters of subjects after multiple caffeine dose following multivariate normal
#' @export
#' @examples 
#' caffDatasetMulti(Weight = 20, Dose = 200, N = 20, Tau = 8)
#' caffDatasetMulti(20,500)
#' @importFrom mgcv rmvn
#' @import dplyr
#' @seealso \url{https://asancpt.github.io/caffsim}

caffDatasetMulti <- function(Weight, Dose, N = 20, Tau = 24){
  #set.seed(20140523+1)
  MVN <- mgcv::rmvn(N, CaffMu, CaffSigma)
  MVNdata <- data.frame(MVN, stringsAsFactors = FALSE) %>% 
    select(eta1 = X1, eta2 = X2, eta3 = X3) %>% 
    mutate(CL = 0.09792 * Weight * exp(eta1), # L/hr
           V  = 0.7219 * Weight * exp(eta2), # L, TVV =THETA[2] * (1 + ABST*THETA[7]) [1] 0.7218775
           Ka = 4.268 * exp(eta3), # /hr
           Ke = CL / V,
           Half_life = 0.693 / Ke,
           Tmax = (log(Ka) - log(Ke)) / (Ka - Ke),
           Cmax = Dose / V * Ka / (Ka - Ke) * (exp(-Ke * Tmax) - exp(-Ka * Tmax)),
           AUC  = Dose / CL
    ) %>%  
    mutate(AI = 1/(1-exp(-1*Ke*Tau)),
           Aavss = 1.44 * Dose * Half_life / Tau,
           Cavss = Dose / (CL * Tau), 
           Cminss = Dose * exp(-Ke * Tau) / (V * (1 - exp(-Ke * Tau))),
           Cmaxss = Dose / (V * (1 - exp(-Ke * Tau)))) %>% 
    select(TmaxS = Tmax, CmaxS = Cmax, AUCS = AUC, AI, Aavss, Cavss, Cmaxss, Cminss)
  return(MVNdata)
}
