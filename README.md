


# R package: caffsim

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.842649.svg)](https://doi.org/10.5281/zenodo.842649) ![CRAN downloads](http://cranlogs.r-pkg.org/badges/grand-total/caffsim)

> Monte Carlo Simulation of Plasma Caffeine Concentrations by Using Population Pharmacokinetic Model

- This package is used for publication of the paper about pharmacokinetics of plasma caffeine.
- Gitbook <http://asancpt.github.io/CaffeineEdison> is created solely dependent on this R package.
- Reproducible research is expected.

## Installation


```r
install.pacakges("devtools")
devtools::install_github("asancpt/caffsim")

# Simply create single dose dataset
caffsim::caffPkparam(Weight = 20, Dose = 200, N = 20) 

# Simply create multiple dose dataset
caffsim::caffPkparamMulti(Weight = 20, Dose = 200, N = 20, Tau = 12) 
```

## Single dose

### Create a PK dataset for caffeine single dose


```r
library(caffsim)
MyDataset <- caffPkparam(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyDataset), format = 'markdown')
```



| subjid|      Tmax|     Cmax|       AUC| Half_life|       CL|        V|         Ka|        Ke|
|------:|---------:|--------:|---------:|---------:|--------:|--------:|----------:|---------:|
|      1| 0.7100622| 11.05701|  62.69317|  3.399840| 3.190140| 15.65074|  4.5897609| 0.2038331|
|      2| 0.3558802| 10.29074|  88.12761|  5.682643| 2.269436| 18.60952| 13.3074785| 0.1219503|
|      3| 0.5858692| 12.11520|  87.54078|  4.582875| 2.284649| 15.10860|  6.5953420| 0.1512151|
|      4| 2.7571384| 11.23381| 136.90777|  6.208321| 1.460837| 13.08708|  0.8463838| 0.1116244|
|      5| 0.1445937| 14.90318|  82.44868|  3.732315| 2.425752| 13.06446| 36.7578566| 0.1856756|
|      6| 1.0381873| 15.17212| 150.61817|  6.116126| 1.327861| 11.71914|  3.3855090| 0.1133070|

### Create a dataset for concentration-time curve


```r
MyConcTime <- caffConcTime(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyConcTime), format = 'markdown') 
```



| Subject| Time|      Conc|
|-------:|----:|---------:|
|       1|  0.0|  0.000000|
|       1|  0.1|  7.115031|
|       1|  0.2| 11.202122|
|       1|  0.3| 13.523476|
|       1|  0.4| 14.815375|
|       1|  0.5| 15.507311|

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
MyDatasetMulti <- caffPkparamMulti(Weight = 20, Dose = 200, N = 20, Tau = 12)
knitr::kable(head(MyDatasetMulti), format = 'markdown') 
```



| subjid|     TmaxS|    CmaxS|      AUCS|       AI|     Aavss|     Cavss|   Cmaxss|   Cminss|
|------:|---------:|--------:|---------:|--------:|---------:|---------:|--------:|--------:|
|      1| 0.8175387| 11.32349|  62.68320| 1.081522|  77.20115|  5.223600| 14.60520| 1.100903|
|      2| 0.5752308| 15.02750| 158.16994| 1.426069| 165.20823| 13.180828| 22.70792| 6.784485|
|      3| 2.5245512| 11.55165| 144.36009| 1.402262| 159.82863| 12.030007| 21.06524| 6.042916|
|      4| 0.3463222| 13.78313|  86.34019| 1.150965|  98.25382|  7.195016| 16.82170| 2.206395|
|      5| 0.2809857| 11.43719|  74.65384| 1.171167| 103.78166|  6.221153| 14.01183| 2.047845|
|      6| 0.9885991| 13.72998|  99.11498| 1.165413| 102.22577|  8.259582| 18.79331| 2.667433|

### Create a dataset for concentration-time curve


```r
MyConcTimeMulti <- caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
knitr::kable(head(MyConcTimeMulti), format = 'markdown')
```



| Subject| Time|      Conc|
|-------:|----:|---------:|
|       1|  0.0|  0.000000|
|       1|  0.1|  3.738362|
|       1|  0.2|  6.434834|
|       1|  0.3|  8.367203|
|       1|  0.4|  9.739345|
|       1|  0.5| 10.700889|

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

