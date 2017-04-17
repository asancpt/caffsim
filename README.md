


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
| 0.8107159| 11.825709| 103.74446|  5.487952| 1.927814| 15.26659| 4.5466571| 0.1262766|
| 0.9437568| 10.871493|  71.34713|  3.834897| 2.803196| 15.51222| 3.2387631| 0.1807089|
| 1.0632196| 11.995621| 191.43411| 10.295538| 1.044746| 15.52124| 3.8806768| 0.0673107|
| 1.4997904|  9.448541|  78.29334|  4.575526| 2.554496| 16.86603| 1.8029281| 0.1514580|
| 2.7669409| 12.938048| 148.35886|  5.664566| 1.348083| 11.01920| 0.8018213| 0.1223395|
| 0.7004863|  7.447735|  67.33372|  5.758812| 2.970280| 24.68295| 5.6034382| 0.1203373|

### Create a dataset for concentration-time curve


```r
MyConcTime <- ConcTime(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyConcTime), format = "markdown")
```



| Subject| Time|      Conc|
|-------:|----:|---------:|
|       1|  0.0|  0.000000|
|       1|  0.1|  5.568253|
|       1|  0.2|  8.377897|
|       1|  0.3|  9.752320|
|       1|  0.4| 10.380720|
|       1|  0.5| 10.622008|

### Create a concentration-time curve


```r
Plot(MyConcTime)
```

<img src="Figures/MyPlotMyConcTime-1.png" style="display: block; margin: auto;" />

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

<img src="Figures/MyPlotPub-1.png" style="display: block; margin: auto;" />

## Multiple dose

### Create a PK dataset for caffeine multiple doses


```r
MyDatasetMulti <- DatasetMulti(Weight = 20, Dose = 200, N = 20, Tau = 12)
knitr::kable(head(MyDatasetMulti), format = "markdown")
```



|     TmaxS|    CmaxS|      AUCS|       AI|     Aavss|     Cavss|   Cmaxss|    Cminss|
|---------:|--------:|---------:|--------:|---------:|---------:|--------:|---------:|
| 1.0555879| 13.14951| 176.40173| 1.606035| 204.78857| 14.700144| 23.00894| 8.6823945|
| 2.0282514| 11.49687| 125.47653| 1.331292| 143.49219| 10.456378| 19.36208| 4.8182540|
| 1.2128837| 12.64804| 119.42226| 1.296532| 135.28433|  9.951855| 19.03556| 4.3536552|
| 0.8960638| 15.90481| 153.63180| 1.337576| 144.95968| 12.802650| 23.57744| 5.9504468|
| 0.7942288| 10.96006| 106.00448| 1.346524| 147.04176|  8.833706| 16.14516| 4.1549125|
| 1.2072415| 11.38633|  63.23708| 1.058868|  69.06829|  5.269757| 16.12424| 0.8964275|

### Create a dataset for concentration-time curve


```r
MyConcTimeMulti <- ConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
knitr::kable(head(MyConcTimeMulti), format = "markdown")
```



| Subject| Time|      Conc|
|-------:|----:|---------:|
|       1|  0.0|  0.000000|
|       1|  0.2| 10.503041|
|       1|  0.4| 10.144504|
|       1|  0.6|  9.766257|
|       1|  0.8|  9.402012|
|       1|  1.0|  9.051352|

### Create a concentration-time curve


```r
PlotMulti(MyConcTimeMulti)
```

<img src="Figures/MyPlotMultiMyConcTimeMulti-1.png" style="display: block; margin: auto;" />

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

<img src="Figures/MyPlotMultiPub-1.png" style="display: block; margin: auto;" />
