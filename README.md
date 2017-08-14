


# R package: caffsim

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.842649.svg)](https://doi.org/10.5281/zenodo.842649)

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
| 1.2948598| 10.111937|  87.82701|  5.036800| 2.277204| 16.55097|  2.319010| 0.1375874|
| 1.3654989|  9.859373|  69.32755|  3.798329| 2.884856| 15.81188|  1.897408| 0.1824487|
| 0.4004801| 11.098271|  68.28439|  3.976377| 2.928927| 16.80594| 10.379308| 0.1742792|
| 0.7387260| 12.175905| 100.55288|  5.184973| 1.989003| 14.88157|  5.050086| 0.1336555|
| 0.4402578| 14.962193|  88.30001|  3.771991| 2.265006| 12.32840|  9.030723| 0.1837226|
| 0.6517388| 17.243336| 154.16700|  5.725939| 1.297295| 10.71895|  6.147688| 0.1210282|

### Create a dataset for concentration-time curve


```r
MyConcTime <- caffConcTime(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyConcTime), format = 'markdown') 
```



| Subject| Time|      Conc|
|-------:|----:|---------:|
|       1|  0.0|  0.000000|
|       1|  0.1|  8.190014|
|       1|  0.2| 11.138422|
|       1|  0.3| 12.098254|
|       1|  0.4| 12.305625|
|       1|  0.5| 12.230203|

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



|     TmaxS|     CmaxS|      AUCS|       AI|     Aavss|     Cavss|   Cmaxss|    Cminss|
|---------:|---------:|---------:|--------:|---------:|---------:|--------:|---------:|
| 1.1862805| 19.647107| 278.94051| 1.655711| 215.47166| 23.245042| 35.64925| 14.118169|
| 1.3275399| 17.569965| 182.61153| 1.355253| 149.06419| 15.217628| 27.61339|  7.238310|
| 0.8455024| 19.152063| 221.66792| 1.482792| 177.86723| 18.472327| 30.73490| 10.007185|
| 0.8135864| 13.050755|  89.82137| 1.157197|  99.97914|  7.485114| 17.29108|  2.348870|
| 2.3988848|  9.211125| 101.60883| 1.304423| 137.16203|  8.467403| 16.07166|  3.750768|
| 0.7209423|  9.842992|  69.29822| 1.173426| 104.38877|  5.774852| 12.95593|  1.914821|

### Create a dataset for concentration-time curve


```r
MyConcTimeMulti <- caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
knitr::kable(head(MyConcTimeMulti), format = 'markdown')
```



| Subject| Time|      Conc|
|-------:|----:|---------:|
|       1|  0.0|  0.000000|
|       1|  0.2|  8.809939|
|       1|  0.4| 11.489755|
|       1|  0.6| 12.112726|
|       1|  0.8| 12.051589|
|       1|  1.0| 11.768769|

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

## Interactive shiny app

```r
caffShiny()
```

