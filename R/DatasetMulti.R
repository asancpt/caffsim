#' Create a dataset for simulation of multiple dose of caffeine 
#'
#' \code{DatasetMulti} will create a dataset for simulation of multiple dose of caffeine 
#'
#' @param Weight Body weight (kg)
#' @param Dose Dose of multiple caffeine (mg)
#' @param N The number of simulated subjects
#' @param Tau The interval of multiple dosing (hour)
#' @return The dataset of pharmacokinetic parameters of subjects after multiple caffeine dose following multivariate normal
#' @export
#' @examples 
#' DatasetMulti(Weight = 20, Dose = 200, N = 20, Tau = 8)
#' DatasetMulti(20,500)
#' @seealso \url{http://asancpt.github.io/CaffeineEdison}
#' @importFrom mgcv rmvn
#' @import dplyr

DatasetMulti <- function(Weight, Dose, N = 20, Tau = 24){
    #set.seed(20140523+1)
    MVN <- rmvn(N, CaffMu, CaffSigma);  
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

