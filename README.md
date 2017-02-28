
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
caffsim::Dataset(Weight = 20, Dose = 200, N = 20) 

# Simply create multiple dose dataset
caffsim::DatasetMulti(Weight = 20, Dose = 200, N = 20, Tau = 12) 
```

## Single dose

### Create a PK dataset for caffeine single dose


```r
MyDataset <- caffsim::Dataset(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyDataset), format = "markdown")
```



|      Tmax|     Cmax|       AUC| Half_life|       CL|         V|        Ka|        Ke|
|---------:|--------:|---------:|---------:|--------:|---------:|---------:|---------:|
| 1.4694810| 11.11810|  77.04116|  3.626319| 2.596015| 13.584384|  1.663739| 0.1911029|
| 1.0582490| 10.38013|  77.21961|  4.356645| 2.590016| 16.282510|  2.903572| 0.1590673|
| 0.3125813| 14.41096|  89.86245|  4.098897| 2.225624| 13.163929| 14.384983| 0.1690699|
| 2.1970310| 10.20552| 111.86651|  5.857496| 1.787845| 15.111537|  1.155682| 0.1183099|
| 0.8537614| 10.73846|  76.54280|  4.305407| 2.612917| 16.233293|  3.892172| 0.1609604|
| 1.0905102| 17.97859| 164.11529|  5.516024| 1.218655|  9.700048|  3.050620| 0.1256340|

### Create a dataset for concentration-time curve


```r
MyConcTime <- ConcTime(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyConcTime), format = "markdown")
```



| Subject| Time|     Conc|
|-------:|----:|--------:|
|       1|  0.0| 0.000000|
|       1|  0.1| 1.507648|
|       1|  0.2| 2.880893|
|       1|  0.3| 4.130242|
|       1|  0.4| 5.265397|
|       1|  0.5| 6.295316|

### Create a concentration-time curve


```r
Plot(MyConcTime)
```

![](Figures/MyPlotMyConcTime-1.png)<!-- -->

### Create plots for publication (according to the amount of caffeine)

- `cowplot` package is required


```r
#install.packages("cowplot") # if you don't have it
library(cowplot)

MyPlotPub <- lapply(
    c(seq(100, 800, by = 100)), 
    function(x) PlotMulti(ConcTime(20, x, 20)) + 
        theme(legend.position="none") + 
        labs(title = paste0("Single Dose ", x, "mg")))

plot(plot_grid(MyPlotPub[[1]], MyPlotPub[[2]],
               MyPlotPub[[3]], MyPlotPub[[4]],
               MyPlotPub[[5]], MyPlotPub[[6]],
               MyPlotPub[[7]], MyPlotPub[[8]],
               labels=LETTERS[1:8], ncol = 2, nrow = 4))
```

![](Figures/MyPlotPub-1.png)<!-- -->

## Multiple dose

### Create a PK dataset for caffeine multiple doses


```r
MyDatasetMulti <- DatasetMulti(Weight = 20, Dose = 200, N = 20, Tau = 12)
knitr::kable(head(MyDatasetMulti), format = "markdown")
```



|     TmaxS|     CmaxS|     AUCS|       AI|     Aavss|     Cavss|    Cmaxss|   Cminss|
|---------:|---------:|--------:|--------:|---------:|---------:|---------:|--------:|
| 1.7516280| 20.936717| 217.3607| 1.317656| 140.29128| 18.113389| 33.954464| 8.185631|
| 0.8396776|  6.854125|  44.5225| 1.132319|  92.96787|  3.710209|  9.019034| 1.053935|
| 1.2770408| 10.456115| 111.7348| 1.380920| 154.96654|  9.311230| 16.560109| 4.568021|
| 2.6958523| 13.374531| 164.9837| 1.372649| 153.07150| 13.748645| 24.606548| 6.680223|
| 1.5433489| 13.636142| 123.2506| 1.240888| 121.75323| 10.270881| 20.892266| 4.055723|
| 0.3360171| 11.841927| 125.1371| 1.447760| 170.07370| 10.428090| 17.716994| 5.479476|

### Create a dataset for concentration-time curve


```r
MyConcTimeMulti <- ConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
knitr::kable(head(MyConcTimeMulti), format = "markdown")
```



| Subject| Time|      Conc|
|-------:|----:|---------:|
|       1|  0.0|  0.000000|
|       1|  0.2|  7.078528|
|       1|  0.4| 10.514443|
|       1|  0.6| 12.090965|
|       1|  0.8| 12.720635|
|       1|  1.0| 12.870378|

### Create a concentration-time curve


```r
PlotMulti(MyConcTimeMulti)
```

![](Figures/MyPlotMultiMyConcTimeMulti-1.png)<!-- -->

### Create plots for publication (according to dosing interval)

- `cowplot` package is required


```r
#install.packages("cowplot") # if you don't have it
library(cowplot)

MyPlotMultiPub <- lapply(
    c(seq(4, 32, by = 4)), 
    function(x) PlotMulti(ConcTimeMulti(20, 250, 20, x, 15)) + 
        theme(legend.position="none") + 
        labs(title = paste0("q", x, "hr" )))

plot(plot_grid(MyPlotMultiPub[[1]], MyPlotMultiPub[[2]],
               MyPlotMultiPub[[3]], MyPlotMultiPub[[4]],
               MyPlotMultiPub[[5]], MyPlotMultiPub[[6]],
               MyPlotMultiPub[[7]], MyPlotMultiPub[[8]],
               labels=LETTERS[1:8], ncol = 2, nrow = 4))
```

![](Figures/MyPlotMultiPub-1.png)<!-- -->
