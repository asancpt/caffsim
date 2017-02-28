#' Create concentration-time curve after multiple doses of caffeine
#'
#' \code{PlotMulti} will create concentration-time curve after multiple doses of caffeine
#'
#' @param ConcTime Concentration-time dataset having column names Subject, Time, and Conc (case-sensitive)
#' @return The concentration-time curve
#' @export
#' @examples 
#' PlotMulti(ConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 8, Repeat = 4))
#' @seealso \url{http://asancpt.github.io/CaffeineEdison}
#' @import dplyr

PlotMulti <- function(ggsuper){
    ggplot(ggsuper, aes(x=Time, y=Conc)) + #, group=Subject, colour = Conc)) + #Subject)) +
        xlab("Time (hour)") + ylab("Concentration (mg/L)") +
        scale_x_continuous(breaks = seq(0, 96, 12)) +
        #scale_colour_gradient(low="navy", high="red", space="Lab") +
        geom_line(aes(group = Subject, colour = Conc)) + 
        stat_summary(fun.y = "mean", colour = "#F0E442", size = 1, geom = "line") +
        geom_hline(yintercept = 80, colour="red") + 
        geom_hline(yintercept = 40, colour="blue") + 
        geom_hline(yintercept = 10, colour="green") + theme_linedraw()
}
