#' Create concentration-time curve after single dose of caffeine
#'
#' \code{Plot} will create concentration-time curve after single dose of caffeine
#'
#' @param ConcTime Concentration-time dataset having column names Subject, Time, and Conc (case-sensitive)
#' @param log y axis log 
#' @return The concentration-time curve
#' @export
#' @examples 
#' Plot(ConcTime(Weight = 20, Dose = 200, N = 20))
#' @seealso \url{http://asancpt.github.io/CaffeineEdison}
#' @import dplyr
#' @import ggplot2

Plot <- function(ConcTime, log = FALSE){
    p <- ggplot(ConcTime, aes(x=Time, y=Conc)) + 
        xlab("Time (hour)") + ylab("Concentration (mg/L)") +
        scale_x_continuous(breaks = seq(from = 0, to = 24, by = 4)) +
        #scale_color_gradient2() +
        #scale_colour_gradient(low="navy", high="red", space="Lab") +
        geom_line(aes(group = Subject, colour = Conc)) + 
        stat_summary(fun.y = "mean", colour = "#F0E442", size = 1, geom = "line") +
        geom_hline(yintercept = 80, colour="red") + 
        geom_hline(yintercept = 40, colour="blue") + 
        geom_hline(yintercept = 10, colour="green") + theme_linedraw()
    
    if (log == TRUE) p <- p + scale_y_log10() #limits = c(0.1, max(80, ggConc$Conc))))
    return(p)
}
