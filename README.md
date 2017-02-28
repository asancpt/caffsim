
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



|      Tmax|      Cmax|       AUC| Half_life|       CL|        V|        Ka|        Ke|
|---------:|---------:|---------:|---------:|--------:|--------:|---------:|---------:|
| 0.2539833| 17.680240| 118.29584|  4.457227| 1.690677| 10.87407| 19.096767| 0.1554778|
| 1.0644268| 11.620089|  70.63320|  3.388330| 2.831530| 13.84438|  2.589347| 0.2045256|
| 0.4590229| 16.047516| 160.35382|  6.598865| 1.247242| 11.87645| 10.039489| 0.1050181|
| 0.7249304| 13.496061|  96.22296|  4.408768| 2.078506| 13.22316|  4.902585| 0.1571868|
| 1.4334136|  8.526557|  63.96069|  4.073485| 3.126921| 18.38018|  1.825772| 0.1701246|
| 0.4025910| 10.476575|  77.92633|  4.867491| 2.566527| 18.02676| 10.922971| 0.1423731|

### Create a dataset for concentration-time curve


```r
MyConcTime <- ConcTime(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyConcTime), format = "markdown")
```



| Subject| Time|     Conc|
|-------:|----:|--------:|
|       1|  0.0|  0.00000|
|       1|  0.1| 11.51244|
|       1|  0.2| 14.20294|
|       1|  0.3| 14.75282|
|       1|  0.4| 14.78400|
|       1|  0.5| 14.69018|

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



|     TmaxS|    CmaxS|      AUCS|       AI|     Aavss|     Cavss|   Cmaxss|    Cminss|
|---------:|--------:|---------:|--------:|---------:|---------:|--------:|---------:|
| 0.3432663| 11.35506|  68.20700| 1.135968|  94.01817|  5.683916| 13.70653|  1.640578|
| 2.3153848| 18.72135| 249.82825| 1.487824| 178.98059| 20.819021| 34.54074| 11.325130|
| 0.7554904| 12.40716| 158.15032| 1.579434| 199.03260| 13.179193| 20.87333|  7.657625|
| 0.1939916| 10.70869|  62.45631| 1.134930|  93.72022|  5.204693| 12.57930|  1.495529|
| 0.8306713| 11.34022|  94.96526| 1.252683| 124.66935|  7.913772| 15.87051|  3.201296|
| 0.2248505| 11.28915|  93.69680| 1.292196| 134.24871|  7.808066| 14.99987|  3.391825|

### Create a dataset for concentration-time curve


```r
MyConcTimeMulti <- ConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
knitr::kable(head(MyConcTimeMulti), format = "markdown")
```



|       CL|        V|       Ka|        Ke| Subject| Time|      Conc|  ConcOrig| ConcTemp|
|--------:|--------:|--------:|---------:|-------:|----:|---------:|---------:|--------:|
| 1.979636| 14.12621| 4.535184| 0.1401393|       1|  0.0|  0.000000|  0.000000|        0|
| 1.979636| 14.12621| 4.535184| 0.1401393|       1|  0.2|  8.307596|  8.307596|        0|
| 1.979636| 14.12621| 4.535184| 0.1401393|       1|  0.4| 11.431917| 11.431917|        0|
| 1.979636| 14.12621| 4.535184| 0.1401393|       1|  0.6| 12.469999| 12.469999|        0|
| 1.979636| 14.12621| 4.535184| 0.1401393|       1|  0.8| 12.671998| 12.671998|        0|
| 1.979636| 14.12621| 4.535184| 0.1401393|       1|  1.0| 12.542454| 12.542454|        0|

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
