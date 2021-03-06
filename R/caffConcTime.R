#' Create a concentration-time dataset of single oral dosing of caffeine
#'
#' \code{caffConcTime} will create a dataset of the concentration-time curve.
#' 
#' @param Weight Body weight (kg)
#' @param Dose Dose of single caffeine (mg)
#' @param N The number of simulated subjects
#' @return The dataset of concentration and time of simulated subjects
#' @export
#' @examples 
#' caffConcTime(Weight = 20, Dose = 200, N = 20)
#' caffConcTime(20, 200)
#' @import dplyr
#' @seealso \url{https://asancpt.github.io/caffsim}

caffConcTime <- function(Weight, Dose, N = 20){
  ggConc <- caffPkparam(Weight, Dose, N) %>% 
    select(CL, V, Ka, Ke) %>% 
    mutate(Subject = row_number()) %>% 
    left_join(expand.grid(
      x = seq(1, N, length.out = N),  #Subjecti
      y = seq(0,24, by = 0.1)) %>% # Time
        select(Subject=x, Time=y), by = "Subject") %>% 
    mutate(Conc = Dose / V * Ka / (Ka - Ke) * (exp(-Ke * Time) - exp(-Ka * Time))) %>% 
    select(Subject, Time, Conc)
  return(ggConc)
}

#' Create a concentration-time dataset of multiple oral dosing of caffeine
#'
#' \code{caffConcTimeMulti} will create a dataset of the concentration-time curve of multiple oral administration of caffeine.
#' 
#' @param Weight Body weight (kg)
#' @param Dose Dose of single caffeine (mg)
#' @param N The number of simulated subjects
#' @param Tau The interval of multiple dosing (hour)
#' @param Repeat The number of dosing
#' @return The dataset of concentration and time of simulated subjects of multiple dosing
#' @export
#' @examples 
#' caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 8, Repeat = 4)
#' caffConcTimeMulti(20, 200)
#' @import dplyr
#' @seealso \url{https://asancpt.github.io/caffsim}

caffConcTimeMulti <- function(Weight, Dose, N = 20, Tau = 8, Repeat = 4){
#Weight=20; Dose=300; N = 20; Tau = 8; Repeat = 4
  
  Subject <- seq(1, N, length.out = N) # 
  Time <- seq(0, 96, by = 0.1) # 
  Grid <- expand.grid(x = Subject, y = Time) %>% 
    as_tibble() %>% 
    select(Subject=x, Time=y)
  
  ggsuper <- caffPkparam(Weight, Dose, N) %>% 
    select(CL, V, Ka, Ke) %>% 
    mutate(Subject = row_number()) %>% 
    left_join(Grid, by = "Subject") %>% 
    mutate(Conc = Dose / V * Ka / (Ka - Ke) * (exp(-Ke * Time) - exp(-Ka * Time))) %>% 
    group_by(Subject) %>% 
    mutate(ConcOrig = Conc, 
           ConcTemp = 0)
  
  ## Superposition
  for (i in 1:Repeat){
    Frame <- Tau * 10 * i
    ggsuper <- ggsuper %>% 
      mutate(Conc = Conc + ConcTemp) %>% 
      mutate(ConcTemp = lag(ConcOrig, n = Frame, default = 0))
  }
  
  ggsuper <- ggsuper %>% 
    select(Subject, Time, Conc)
  return(ggsuper)
}
