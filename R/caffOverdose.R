#' Calculate a duration of toxic concentration over specified levels (40 mg/L or 80 mg/L) 
#' 
#' \code{caffOverdose} calculates a time duration of plasma caffeine concentration over specified toxic limits (40 mg/L or 80 mg/L)
#' 
#' @export
#' @import dplyr
#' @import tidyr
#' @param caffConcTimeData data frame containing concentration-time data
#' @return descriptive statistics of duration of toxic concentrations
#' @examples 
#' caffOverdose(caffConcTime(Weight = 20, Dose = 200, N = 20))
#' caffOverdose(caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 8, Repeat = 4))
#' @seealso \url{https://asan.shinyapps.io/caff/}

caffOverdose <- function(caffConcTimeData){
  nonzero <- function(x) sum(x != 0)
  
  caffConcTimeData %>% 
    mutate(Conc40 = ifelse(Conc >=40, 0.1, 0),
           Conc80 = ifelse(Conc >=80, 0.1, 0)) %>% 
    select(Subject, Conc40, Conc80) %>% 
    group_by(Subject) %>% 
    summarise(MeanConc80 = sum(Conc80), 
              MeanConc40 = sum(Conc40)) %>% 
    select(-Subject) %>% 
    # paramValueDesc starts
    gather(param, value) %>% 
    group_by(param) %>% 
    summarise_at(vars(value), funs(mean, sd, min, max, nonzero, n())) %>% 
    mutate(value = sprintf('%0.2f (%0.2f) [%0.2f-%0.2f], %3.f%%', 
                           mean, sd, min, max, nonzero/n*100)) %>% 
    select(param, value) %>% 
    # paramValueDesc ends
    mutate(param = ifelse(param == 'MeanConc40', 'Duration of conc. >40 mg/L (hr)', 'Duration of conc. >80 mg/L (hr)'))
}
