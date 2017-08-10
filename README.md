


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



|      Tmax|      Cmax|      AUC| Half_life|       CL|        V|        Ka|        Ke|
|---------:|---------:|--------:|---------:|--------:|--------:|---------:|---------:|
| 0.7506950| 10.904556| 99.33949|  5.768755| 2.013298| 16.75934|  5.118124| 0.1201299|
| 0.9756280|  9.535194| 78.96550|  5.015262| 2.532751| 18.32960|  3.430260| 0.1381782|
| 0.8869807| 14.091555| 81.22170|  3.319075| 2.462396| 11.79347|  3.331590| 0.2087931|
| 0.6458470| 12.058570| 95.70897|  5.032268| 2.089668| 15.17427|  5.975385| 0.1377113|
| 0.2466091|  8.607292| 72.15405|  5.635830| 2.771847| 22.54208| 20.959415| 0.1229632|
| 0.2747344| 12.558457| 67.17518|  3.511209| 2.977290| 15.08498| 16.252669| 0.1973679|

### Create a dataset for concentration-time curve


```r
MyConcTime <- caffConcTime(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyConcTime), format = "markdown")
```



| Subject| Time|     Conc|
|-------:|----:|--------:|
|       1|  0.0| 0.000000|
|       1|  0.1| 5.117929|
|       1|  0.2| 7.721610|
|       1|  0.3| 9.025087|
|       1|  0.4| 9.656359|
|       1|  0.5| 9.940279|

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



|     TmaxS|     CmaxS|      AUCS|       AI|     Aavss|     Cavss|   Cmaxss|    Cminss|
|---------:|---------:|---------:|--------:|---------:|---------:|--------:|---------:|
| 0.9236100| 12.730981| 122.83645| 1.334606| 144.26677| 10.236371| 18.89986| 4.7384847|
| 2.2515756| 12.207227| 158.30692| 1.464930| 173.90274| 13.192243| 22.17966| 7.0392348|
| 0.2178431| 12.469114|  83.51313| 1.185915| 107.70968|  6.959427| 15.29319| 2.3974994|
| 0.6228740|  7.487806|  43.61323| 1.108450|  85.86370|  3.634436|  9.36417| 0.9161845|
| 4.0027303|  9.990159| 146.93629| 1.413289| 162.32568| 12.244691| 21.27733| 6.2221419|
| 0.7494883|  9.448188|  55.46029| 1.103058|  84.19326|  4.621691| 12.08503| 1.1291008|

### Create a dataset for concentration-time curve


```r
MyConcTimeMulti <- caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
knitr::kable(head(MyConcTimeMulti), format = "markdown")
```



| Subject| Time|     Conc|
|-------:|----:|--------:|
|       1|  0.0| 0.000000|
|       1|  0.2| 2.974553|
|       1|  0.4| 5.015058|
|       1|  0.6| 6.390925|
|       1|  0.8| 7.294470|
|       1|  1.0| 7.862957|

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
