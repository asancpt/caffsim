


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



| subjid|      Tmax|     Cmax|       AUC| Half_life|       CL|        V|       Ka|        Ke|
|------:|---------:|--------:|---------:|---------:|--------:|--------:|--------:|---------:|
|      1| 1.7228616| 15.17929| 157.27624|  5.855968| 1.271648| 10.74564| 1.646528| 0.1183408|
|      2| 1.6078916| 10.00723|  69.21445|  3.479753| 2.889570| 14.50937| 1.421496| 0.1991521|
|      3| 0.8459035| 16.41961| 119.93671|  4.435290| 1.667546| 10.67251| 3.985168| 0.1562468|
|      4| 0.6769489| 11.19809| 102.55271|  5.858108| 1.950217| 16.48568| 5.891302| 0.1182976|
|      5| 0.9905899| 10.68006|  77.91477|  4.311527| 2.566907| 15.97012| 3.171183| 0.1607319|
|      6| 1.2709904| 10.13674| 111.59231|  6.687595| 1.792238| 17.29547| 2.655728| 0.1036247|

### Create a dataset for concentration-time curve


```r
MyConcTime <- caffConcTime(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyConcTime), format = 'markdown') 
```



| Subject| Time|     Conc|
|-------:|----:|--------:|
|       1|  0.0|  0.00000|
|       1|  0.1| 10.56098|
|       1|  0.2| 12.23167|
|       1|  0.3| 12.42149|
|       1|  0.4| 12.36527|
|       1|  0.5| 12.26878|

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



| subjid|     TmaxS|     CmaxS|      AUCS|       AI|     Aavss|     Cavss|   Cmaxss|   Cminss|
|------:|---------:|---------:|---------:|--------:|---------:|---------:|--------:|--------:|
|      1| 0.4228888| 12.241703| 123.41987| 1.405190| 160.49262| 10.284989| 17.97255| 5.182431|
|      2| 0.2861979| 16.547542| 103.63985| 1.154710|  99.29284|  8.636654| 20.04592| 2.685781|
|      3| 0.9787169| 11.241748|  84.62726| 1.185618| 107.63136|  7.052272| 15.50460| 2.427368|
|      4| 2.3797153|  9.859835| 102.37905| 1.258957| 126.20893|  8.531587| 16.98542| 3.493756|
|      5| 0.1894007| 13.778195| 127.75498| 1.363783| 151.03300| 10.646248| 19.18650| 5.117917|
|      6| 0.8330730| 12.832415| 132.46113| 1.390690| 157.19726| 11.038427| 19.49029| 5.475459|

### Create a dataset for concentration-time curve


```r
MyConcTimeMulti <- caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
knitr::kable(head(MyConcTimeMulti), format = 'markdown')
```



| Subject| Time|      Conc|
|-------:|----:|---------:|
|       1|  0.0|  0.000000|
|       1|  0.1|  6.246054|
|       1|  0.2|  9.688779|
|       1|  0.3| 11.549864|
|       1|  0.4| 12.519062|
|       1|  0.5| 12.985793|

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

