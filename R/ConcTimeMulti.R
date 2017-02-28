#' Create a dataset of the concentration-time curve of multiple dosing
#'
#' \code{ConcTimeMulti} will create a dataset of the concentration-time curve of multiple dosing
#' 
#' @param Weight Body weight (kg)
#' @param Dose Dose of single caffeine (mg)
#' @param N The number of simulated subjects
#' @param Tau The interval of multiple dosing (hour)
#' @param Repeat The number of dosing
#' @return The dataset of concentration and time of simulated subjects of multiple dosing
#' @export
#' @examples 
#' ConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 8, Repeat = 4)
#' ConcTimeMulti(20, 200)
#' @seealso \url{http://asancpt.github.io/CaffeineEdison}
#' @import dplyr

ConcTimeMulti <- function(Weight, Dose, N = 20, Tau = 8, Repeat = 4){
    Subject <- seq(1, N, length.out = N) # 
    Time <- seq(0, 96, length.out = 481) # 
    Grid <- expand.grid(x = Subject, y = Time) %>% select(Subject=x, Time=y)
    
    ggsuper <- Dataset(Weight, Dose, N) %>% select(CL, V, Ka, Ke) %>% 
        mutate(Subject = row_number()) %>% 
        left_join(Grid, by = "Subject") %>% 
        mutate(Conc = Dose / V * Ka / (Ka - Ke) * (exp(-Ke * Time) - exp(-Ka * Time))) %>% 
        group_by(Subject) %>% 
        mutate(ConcOrig = Conc, 
               ConcTemp = 0)
    ## Superposition
    for (i in 1:Repeat){
        Frame <- Tau * 5 * i
        ggsuper <- ggsuper %>% 
            mutate(Conc = Conc + ConcTemp) %>% 
            mutate(ConcTemp = lag(ConcOrig, n = Frame, default = 0))
    }
    return(ggsuper)
}
