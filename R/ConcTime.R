#' Create a dataset of the concentration-time curve
#'
#' \code{ConcTime} will create a dataset of the concentration-time curve
#' 
#' @param Weight Body weight (kg)
#' @param Dose Dose of single caffeine (mg)
#' @param N The number of simulated subjects
#' @return The dataset of concentration and time of simulated subjects
#' @export
#' @examples 
#' ConcTime(Weight = 20, Dose = 200, N = 20)
#' ConcTime(20, 200)
#' @seealso \url{http://asancpt.github.io/CaffeineEdison}
#' @import dplyr

ConcTime <- function(Weight, Dose, N = 20){
    #set.seed(Seed)
    ggConc <- Dataset(Weight, Dose, N) %>% 
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
