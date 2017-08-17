#' Create a dataset for simulation of single dose of caffeine 
#'
#' \code{caffPkparam} will create a dataset for simulation of single dose of caffeine 
#' 
#' @param Weight Body weight (kg)
#' @param Dose Dose of single caffeine (mg)
#' @param N The number of simulated subjects
#' @return The dataset of pharmacokinetic parameters of subjects after single caffeine dose following multivariate normal
#' @export
#' @examples 
#' caffPkparam(Weight = 20, Dose = 200, N = 20)
#' caffPkparam(20,500)
#' @importFrom mgcv rmvn
#' @import dplyr
#' @import tibble
#' @seealso \url{https://asancpt.github.io/caffsim}

caffPkparam <- function(Weight, Dose, N = 20){
  mgcv::rmvn(N, CaffMu, CaffSigma) %>% 
    as_tibble() %>% 
    select(eta1 = 1, eta2 = 2, eta3 = 3) %>% 
    mutate(CL = 0.09792 * Weight * exp(eta1), # L/hr
           V  = 0.7219 * Weight * exp(eta2), 
           # TVV =THETA[2] * (1 + ABST*THETA[7]) [1] 0.7218775
           Ka = 4.268 * exp(eta3), # /hr
           Ke = CL / V,
           Tmax = (log(Ka) - log(Ke)) / (Ka - Ke),
           Cmax = Dose / V * Ka / (Ka - Ke) * (exp(-Ke * Tmax) - exp(-Ka * Tmax)), 
           AUC  = Dose / CL, # mg/h/L
           Half_life = 0.693 / Ke) %>% 
    mutate(subjid = row_number()) %>% 
    select(subjid, Tmax, Cmax, AUC, Half_life, CL, V, Ka, Ke)
}

#' Create a dataset for simulation of multiple dose of caffeine 
#'
#' \code{caffPkparamMulti} will create a dataset for simulation of multiple dose of caffeine 
#'
#' @param Weight Body weight (kg)
#' @param Dose Dose of multiple caffeine (mg)
#' @param N The number of simulated subjects
#' @param Tau The interval of multiple dosing (hour)
#' @return The dataset of pharmacokinetic parameters of subjects after multiple caffeine dose following multivariate normal
#' @export
#' @examples 
#' caffPkparamMulti(Weight = 20, Dose = 200, N = 20, Tau = 8)
#' caffPkparamMulti(20,500)
#' @importFrom mgcv rmvn
#' @import dplyr
#' @import tibble
#' @seealso \url{https://asancpt.github.io/caffsim}

caffPkparamMulti <- function(Weight, Dose, N = 20, Tau = 8){
  mgcv::rmvn(N, CaffMu, CaffSigma) %>% 
    as_tibble() %>% 
    select(eta1 = 1, eta2 = 2, eta3 = 3) %>% 
    mutate(CL = 0.09792 * Weight * exp(eta1), # L/hr
           V  = 0.7219 * Weight * exp(eta2), 
           # L, TVV =THETA[2] * (1 + ABST*THETA[7]) [1] 0.7218775
           Ka = 4.268 * exp(eta3), # /hr
           Ke = CL / V,
           Half_life = 0.693 / Ke,
           Tmax = (log(Ka) - log(Ke)) / (Ka - Ke),
           Cmax = Dose / V * Ka / (Ka - Ke) * (exp(-Ke * Tmax) - exp(-Ka * Tmax)),
           AUC  = Dose / CL,
           AI = 1/(1-exp(-1*Ke*Tau)),
           Aavss = 1.44 * Dose * Half_life / Tau,
           Cavss = Dose / (CL * Tau), 
           Cminss = Dose * exp(-Ke * Tau) / (V * (1 - exp(-Ke * Tau))),
           Cmaxss = Dose / (V * (1 - exp(-Ke * Tau)))) %>% 
    mutate(subjid = row_number()) %>% 
    select(subjid, TmaxS = Tmax, CmaxS = Cmax, AUCS = AUC, 
           AI, Aavss, Cavss, Cmaxss, Cminss)
}

#' Calculate descriptive statistics of simulated PK parameters
#'
#' \code{caffDescstat} will calculate descriptive statistics of simulated PK parameters
#'
#' @return The descriptive statistics of pharmacokinetic parameters
#' @export
#' @examples 
#' caffDescstat(caffPkparam(20,500))
#' caffDescstat(caffPkparamMulti(20,500))
#' caffDescExample <- cbind(caffDescstat(caffPkparam(20,500)), 
#'                          caffDescstat(caffPkparam(50,500))[,2])
#' colnames(caffDescExample)[2:3] <- c('20 kg', '50 kg')      
#' caffDescExample
#' @import dplyr
#' @seealso \url{https://asancpt.github.io/caffsim}

caffDescstat <- function(caffPkparam){
  caffPkparam %>% 
    gather(param, value, -subjid) %>% 
    group_by(param) %>% 
    summarise_at(vars(value), funs(mean, sd, min, max)) %>% 
    mutate(value = sprintf('%0.2f (%0.2f) [%0.2f-%0.2f]', mean, sd, min, max)) %>% 
    select(`PK parameters`= param, `value: mean (sd) [min-max]`= value)
}
