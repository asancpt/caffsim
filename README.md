


# R package: caffsim

> Monte Carlo Simulation of Plasma Caffeine Concentrations by Using Population Pharmacokinetic Model

- This package is used for publication of the paper about pharmacokinetics of plasma caffeine.
- Gitbook <http://asancpt.github.io/CaffeineEdison> is created solely dependent on this R package.
- Reproducible research is expected.

## Installation


```r
install.pacakges("devtools")
devtools::install_github("asancpt/caffsim")

# Simply create single dose dataset
caffsim::caffDataset(Weight = 20, Dose = 200, N = 20) 

# Simply create multiple dose dataset
caffsim::caffDatasetMulti(Weight = 20, Dose = 200, N = 20, Tau = 12) 
```

## Single dose

### Create a PK dataset for caffeine single dose


```r
library(caffsim)
MyDataset <- caffDataset(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyDataset), format = 'markdown')
```



|      Tmax|      Cmax|       AUC| Half_life|       CL|        V|        Ka|        Ke|
|---------:|---------:|---------:|---------:|--------:|--------:|---------:|---------:|
| 1.0906131| 11.314388| 121.76524|  6.657688| 1.642505| 15.77963|  3.262995| 0.1040902|
| 0.5077390|  9.503155|  32.08079|  1.953896| 6.234261| 17.57734|  5.887948| 0.3546760|
| 0.5619410| 12.913824| 107.44157|  5.361767| 1.861477| 14.40232|  7.310243| 0.1292484|
| 0.8627242| 14.795723| 125.85073|  5.261418| 1.589184| 12.06546|  4.123528| 0.1317135|
| 1.9623962| 13.828196| 138.83715|  5.411751| 1.440537| 11.24939|  1.314898| 0.1280547|
| 0.3461002| 14.109070| 106.51535|  4.986041| 1.877664| 13.50954| 13.322522| 0.1389880|

### Create a dataset for concentration-time curve


```r
MyConcTime <- caffConcTime(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyConcTime), format = 'markdown') 
```



| Subject| Time|      Conc|
|-------:|----:|---------:|
|       1|  0.0|  0.000000|
|       1|  0.1|  3.997178|
|       1|  0.2|  6.949478|
|       1|  0.3|  9.111235|
|       1|  0.4| 10.675216|
|       1|  0.5| 11.787516|

### Create a concentration-time curve


```r
caffPlot(MyConcTime)
```

![](assets/figures/MyPlotMyConcTime-1.png)<!-- -->

### Create plots for publication (according to the amount of caffeine)

- `cowplot` package is required


```r
#install.packages("cowplot") # if you don't have it
library(cowplot)

MyPlotPub <- lapply(
  c(seq(100, 800, by = 100)), 
  function(x) caffPlotMulti(caffConcTime(20, x, 20)) + 
    theme(legend.position="none") + 
    labs(title = paste0("Single Dose ", x, "mg")))

plot_grid(MyPlotPub[[1]], MyPlotPub[[2]],
          MyPlotPub[[3]], MyPlotPub[[4]],
          MyPlotPub[[5]], MyPlotPub[[6]],
          MyPlotPub[[7]], MyPlotPub[[8]],
          labels=LETTERS[1:8], ncol = 2, nrow = 4)
```

![](assets/figures/MyPlotPub-1.png)<!-- -->

## Multiple dose

### Create a PK dataset for caffeine multiple doses


```r
MyDatasetMulti <- caffDatasetMulti(Weight = 20, Dose = 200, N = 20, Tau = 12)
knitr::kable(head(MyDatasetMulti), format = 'markdown') 
```



|     TmaxS|     CmaxS|      AUCS|       AI|     Aavss|     Cavss|   Cmaxss|   Cminss|
|---------:|---------:|---------:|--------:|---------:|---------:|--------:|--------:|
| 0.5271146| 12.484516|  79.03187| 1.143311|  96.10779|  6.585989| 15.63696| 1.960048|
| 1.8913324| 12.019455| 179.09764| 1.648569| 213.94066| 14.924803| 22.95346| 9.030201|
| 0.6318965| 10.665360|  98.51506| 1.328002| 142.72210|  8.209588| 15.24596| 3.765590|
| 3.1907127|  6.310865|  84.02889| 1.396045| 158.41622|  7.002408| 12.31609| 3.493959|
| 0.2903834| 11.633120|  71.39127| 1.146897|  97.11712|  5.949272| 14.02226| 1.795997|
| 1.1666484|  9.491114|  94.03967| 1.333555| 144.02132|  7.836639| 14.48238| 3.622403|

### Create a dataset for concentration-time curve


```r
MyConcTimeMulti <- caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
knitr::kable(head(MyConcTimeMulti), format = 'markdown')
```



| Subject| Time|     Conc|
|-------:|----:|--------:|
|       1|  0.0| 0.000000|
|       1|  0.2| 6.107943|
|       1|  0.4| 7.995832|
|       1|  0.6| 8.477541|
|       1|  0.8| 8.493149|
|       1|  1.0| 8.356661|

### Create a concentration-time curve


```r
caffPlotMulti(MyConcTimeMulti)
```

![](assets/figures/MyPlotMultiMyConcTimeMulti-1.png)<!-- -->

### Create plots for publication (according to dosing interval)

- `cowplot` package is required


```r
#install.packages("cowplot") # if you don't have it
library(cowplot)

MyPlotMultiPub <- lapply(
  c(seq(4, 32, by = 4)), 
  function(x) caffPlotMulti(caffConcTimeMulti(20, 250, 20, x, 15)) + 
    theme(legend.position="none") + 
    labs(title = paste0("q", x, "hr" )))

plot_grid(MyPlotMultiPub[[1]], MyPlotMultiPub[[2]],
          MyPlotMultiPub[[3]], MyPlotMultiPub[[4]],
          MyPlotMultiPub[[5]], MyPlotMultiPub[[6]],
          MyPlotMultiPub[[7]], MyPlotMultiPub[[8]],
          labels=LETTERS[1:8], ncol = 2, nrow = 4)
```

![](assets/figures/MyPlotMultiPub-1.png)<!-- -->
