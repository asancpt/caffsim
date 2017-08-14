


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
knitr::kable(head(MyDataset), format = "markdown")
```



|      Tmax|     Cmax|       AUC| Half_life|       CL|        V|       Ka|        Ke|
|---------:|--------:|---------:|---------:|--------:|--------:|--------:|---------:|
| 1.5932082| 10.78304| 101.26248|  5.279877| 1.975065| 15.04777| 1.760984| 0.1312531|
| 2.0916257| 12.86940| 175.74298|  7.871994| 1.138025| 12.92717| 1.416190| 0.0880336|
| 0.4921188| 11.86278| 124.11671|  6.901047| 1.611387| 16.04654| 9.302930| 0.1004195|
| 0.6908504| 10.17830|  48.35470|  2.769650| 4.136103| 16.53038| 4.400363| 0.2502121|
| 2.0047057| 10.22826|  98.64327|  5.085895| 2.027508| 14.87979| 1.236351| 0.1362592|
| 1.1338165| 14.59544|  85.88897|  3.186989| 2.328588| 10.70878| 2.296390| 0.2174466|

### Create a dataset for concentration-time curve


```r
MyConcTime <- caffConcTime(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyConcTime), format = "markdown")
```



| Subject| Time|      Conc|
|-------:|----:|---------:|
|       1|  0.0|  0.000000|
|       1|  0.1|  6.577377|
|       1|  0.2|  9.164757|
|       1|  0.3| 10.103392|
|       1|  0.4| 10.362305|
|       1|  0.5| 10.342533|

### Create a concentration-time curve


```r
caffPlot(MyConcTime)
```

<img src="assets/figures/MyPlotMyConcTime-1.png" style="display: block; margin: auto;" />

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

<img src="assets/figures/MyPlotPub-1.png" style="display: block; margin: auto;" />

## Multiple dose

### Create a PK dataset for caffeine multiple doses


```r
MyDatasetMulti <- caffDatasetMulti(Weight = 20, Dose = 200, N = 20, Tau = 12)
knitr::kable(head(MyDatasetMulti), format = "markdown")
```



|     TmaxS|     CmaxS|      AUCS|       AI|    Aavss|     Cavss|   Cmaxss|   Cminss|
|---------:|---------:|---------:|--------:|--------:|---------:|--------:|--------:|
| 0.5158465| 14.957443| 137.90585| 1.335630| 144.5057| 11.492154| 21.19963| 5.327244|
| 0.6093528| 14.631043| 132.44702| 1.316633| 140.0501| 11.037252| 20.70942| 4.980344|
| 2.4233186| 11.047738| 117.37331| 1.272119| 129.4152|  9.781109| 19.18918| 4.104760|
| 0.7263908|  9.032753|  76.01314| 1.263379| 127.2897|  6.334428| 12.54797| 2.615900|
| 0.7195809|  7.929042|  70.60036| 1.297770| 135.5795|  5.883363| 11.23971| 2.578924|
| 0.5069677| 11.059353|  76.27684| 1.179214| 105.9351|  6.356403| 14.12180| 2.146198|

### Create a dataset for concentration-time curve


```r
MyConcTimeMulti <- caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
knitr::kable(head(MyConcTimeMulti), format = "markdown")
```



| Subject| Time|     Conc|
|-------:|----:|--------:|
|       1|  0.0|  0.00000|
|       1|  0.2| 12.94468|
|       1|  0.4| 12.37024|
|       1|  0.6| 11.81864|
|       1|  0.8| 11.29163|
|       1|  1.0| 10.78813|

### Create a concentration-time curve


```r
caffPlotMulti(MyConcTimeMulti)
```

<img src="assets/figures/MyPlotMultiMyConcTimeMulti-1.png" style="display: block; margin: auto;" />

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

<img src="assets/figures/MyPlotMultiPub-1.png" style="display: block; margin: auto;" />
