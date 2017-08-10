#' Create concentration-time curve after single dose of caffeine
#'
#' \code{Plot} will create concentration-time curve after single dose of caffeine
#'
#' @param ConcTime Concentration-time dataset having column names Subject, Time, and Conc (case-sensitive)
#' @param log y axis log 
#' @return The concentration-time curve
#' @export
#' @examples 
#' caffPlot(caffConcTime(Weight = 20, Dose = 200, N = 20))
#' @import dplyr
#' @import ggplot2
#' @seealso \url{https://asancpt.github.io/caffsim}

caffPlot <- function(caffConcTime, log = FALSE){
  p <- ggplot(caffConcTime, aes(x=Time, y=Conc)) + 
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

#' Create concentration-time curve after multiple doses of caffeine
#'
#' \code{PlotMulti} will create concentration-time curve after multiple doses of caffeine
#'
#' @param ConcTimeMulti Concentration-time dataset having column names Subject, Time, and Conc (case-sensitive)
#' @param log y axis log 
#' @return The concentration-time curve
#' @export
#' @examples 
#' caffPlotMulti(ConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 8, Repeat = 4))
#' @import dplyr
#' @import ggplot2
#' @seealso \url{https://asancpt.github.io/caffsim}

caffPlotMulti <- function(caffConcTimeMulti, log = FALSE){
  p <- ggplot(caffConcTimeMulti, aes(x=Time, y=Conc)) + #, group=Subject, colour = Conc)) + #Subject)) +
    xlab("Time (hour)") + ylab("Concentration (mg/L)") +
    scale_x_continuous(breaks = seq(0, 96, 12)) +
    #scale_colour_gradient(low="navy", high="red", space="Lab") +
    geom_line(aes(group = Subject, colour = Conc)) + 
    stat_summary(fun.y = "mean", colour = "#F0E442", size = 1, geom = "line") +
    geom_hline(yintercept = 80, colour="red") + 
    geom_hline(yintercept = 40, colour="blue") + 
    geom_hline(yintercept = 10, colour="green") + theme_linedraw()
  
  if (log == TRUE) p <- p + scale_y_log10() #limits = c(0.1, max(80, ggConc$Conc))))
  return(p)
}
