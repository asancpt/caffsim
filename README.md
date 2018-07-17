
`caffsim` R package: Simulation of Plasma Caffeine Concentrations by Using Population Pharmacokinetic Model
===========================================================================================================

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.842649.svg)](https://doi.org/10.5281/zenodo.842649) ![CRAN downloads](http://cranlogs.r-pkg.org/badges/grand-total/caffsim) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/caffsim)](https://cran.r-project.org/package=caffsim)

> Simulate plasma caffeine concentrations using population pharmacokinetic model described in Lee, Kim, Perera, McLachlan and Bae (2015) <doi:10.1007/s00431-015-2581-x> and the package was published <doi:10.12793/tcp.2017.25.3.141>.

-   Github: <https://github.com/asancpt/caffsim>
-   Package vignettes and references by `pkgdown`: <http://asancpt.github.io/caffsim>

Installation
------------

``` r
install.pacakges("devtools")
devtools::install_github("asancpt/caffsim")

# Simply create single dose dataset
caffsim::caffPkparam(Weight = 20, Dose = 200, N = 20) 

# Simply create multiple dose dataset
caffsim::caffPkparamMulti(Weight = 20, Dose = 200, N = 20, Tau = 12) 
```

Single dose
-----------

### Create a PK dataset for caffeine single dose

``` r
library(caffsim)
MyDataset <- caffPkparam(Weight = 20, Dose = 200, N = 20)
head(MyDataset)
```

|  subjid|       Tmax|       Cmax|        AUC|  Half\_life|        CL|         V|         Ka|         Ke|
|-------:|----------:|----------:|----------:|-----------:|---------:|---------:|----------:|----------:|
|       1|  0.8280930|  13.335522|  121.27917|    5.698692|  1.649088|  13.56081|  4.4757503|  0.1216069|
|       2|  1.0631884|  13.222350|  102.72473|    4.584636|  1.946951|  12.88032|  2.9438438|  0.1511571|
|       3|  0.9040046|  13.256365|  141.39768|    6.735279|  1.414450|  13.74707|  4.2080522|  0.1028911|
|       4|  3.2011071|   7.114357|   87.96181|    5.872755|  2.273714|  19.26835|  0.6519732|  0.1180025|
|       5|  0.9744961|  18.013340|  187.64545|    6.507388|  1.065840|  10.00842|  3.7652988|  0.1064943|
|       6|  1.4385993|  11.941306|   90.93579|    4.150480|  2.199354|  13.17226|  1.8320498|  0.1669687|

### Create a dataset for concentration-time curve

``` r
MyConcTime <- caffConcTime(Weight = 20, Dose = 200, N = 20)
head(MyConcTime)
```

|  Subject|  Time|       Conc|
|--------:|-----:|----------:|
|        1|   0.0|   0.000000|
|        1|   0.1|   5.016257|
|        1|   0.2|   7.902223|
|        1|   0.3|   9.528637|
|        1|   0.4|  10.410870|
|        1|   0.5|  10.853953|

### Create a concentration-time curve

``` r
caffPlot(MyConcTime)
```

![](assets/figures/MyPlotMyConcTime-1.png)

### Create plots for publication (according to the amount of caffeine)

-   `cowplot` package is required

``` r
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

![](assets/figures/MyPlotPub-1.png)

Multiple dose
-------------

### Create a PK dataset for caffeine multiple doses

``` r
MyDatasetMulti <- caffPkparamMulti(Weight = 20, Dose = 200, N = 20, Tau = 12)
head(MyDatasetMulti)
```

|  subjid|      TmaxS|      CmaxS|       AUCS|        AI|      Aavss|      Cavss|    Cmaxss|    Cminss|
|-------:|----------:|----------:|----------:|---------:|----------:|----------:|---------:|---------:|
|       1|  0.9664585|  14.703388|  141.32115|  1.328525|  142.84450|  11.776762|  21.86039|  5.405757|
|       2|  0.2565093|  13.064267|   42.73852|  1.018749|   49.95629|   3.561543|  14.49576|  0.266784|
|       3|  0.5276978|  11.294587|   70.89055|  1.140096|   95.19688|   5.907546|  14.12055|  1.735146|
|       4|  2.1577932|  12.770296|  158.96644|  1.434045|  167.00113|  13.247203|  22.70353|  6.871722|
|       5|  0.8676687|  13.745241|  100.02531|  1.177838|  105.56857|   8.335443|  18.56117|  2.802492|
|       6|  0.7153650|   7.514485|   61.63854|  1.249716|  123.93837|   5.136545|  10.33718|  2.065554|

### Create a dataset for concentration-time curve

``` r
MyConcTimeMulti <- caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
head(MyConcTimeMulti)
```

|  Subject|  Time|      Conc|
|--------:|-----:|---------:|
|        1|   0.0|  0.000000|
|        1|   0.1|  1.661130|
|        1|   0.2|  3.052089|
|        1|   0.3|  4.214337|
|        1|   0.4|  5.182992|
|        1|   0.5|  5.987805|

### Create a concentration-time curve

``` r
caffPlotMulti(MyConcTimeMulti)
```

![](assets/figures/MyPlotMultiMyConcTimeMulti-1.png)

### Create plots for publication (according to dosing interval)

-   `cowplot` package is required

``` r
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

![](assets/figures/MyPlotMultiPub-1.png)

Interactive shiny app
---------------------

``` r
caffShiny()
```
