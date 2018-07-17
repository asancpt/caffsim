
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
|       1|  0.2444945|  10.244873|   73.99342|    4.832740|  2.702943|  18.84938|  20.425808|  0.1433969|
|       2|  1.6472994|  10.325239|  111.75991|    6.248489|  1.789550|  16.13562|   1.804037|  0.1109068|
|       3|  1.3032554|   9.885904|   94.43513|    5.640402|  2.117856|  17.23746|   2.405027|  0.1228636|
|       4|  0.5653782|  12.872081|  143.03957|    7.298371|  1.398214|  14.72538|   7.919218|  0.0949527|
|       5|  1.4494859|  11.884657|  108.24482|    5.203813|  1.847663|  13.87431|   2.003498|  0.1331716|
|       6|  0.4786689|   6.346586|   34.08360|    3.373099|  5.867924|  28.56146|   7.804011|  0.2054490|

### Create a dataset for concentration-time curve

``` r
MyConcTime <- caffConcTime(Weight = 20, Dose = 200, N = 20)
head(MyConcTime)
```

|  Subject|  Time|      Conc|
|--------:|-----:|---------:|
|        1|   0.0|  0.000000|
|        1|   0.1|  5.859353|
|        1|   0.2|  8.296127|
|        1|   0.3|  9.253273|
|        1|   0.4|  9.571682|
|        1|   0.5|  9.615264|

### Create a concentration-time curve

``` r
caffPlot(MyConcTime)
```

![](README_files/figure-markdown_github/MyPlotMyConcTime-1.png)

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

![](README_files/figure-markdown_github/MyPlotPub-1.png)

Multiple dose
-------------

### Create a PK dataset for caffeine multiple doses

``` r
MyDatasetMulti <- caffPkparamMulti(Weight = 20, Dose = 200, N = 20, Tau = 12)
head(MyDatasetMulti)
```

|  subjid|      TmaxS|      CmaxS|       AUCS|        AI|     Aavss|      Cavss|    Cmaxss|     Cminss|
|-------:|----------:|----------:|----------:|---------:|---------:|----------:|---------:|----------:|
|       1|  1.2873291|  12.765341|  133.34867|  1.362487|  150.7342|  11.112389|  20.04719|   5.333515|
|       2|  5.5838436|  10.181435|  213.25042|  1.744547|  234.3983|  17.770868|  26.39750|  11.266068|
|       3|  2.4336995|  11.220361|  143.88301|  1.436229|  167.4912|  11.990251|  20.52039|   6.232704|
|       4|  2.5286374|   8.855724|  113.71990|  1.428269|  165.7031|   9.476659|  16.30272|   4.888400|
|       5|  0.9151676|  15.523376|  189.91775|  1.527100|  187.6255|  15.826479|  25.70902|   8.873824|
|       6|  0.9451444|   9.077402|   65.24636|  1.166641|  102.5588|   5.437197|  12.34425|   1.763228|

### Create a dataset for concentration-time curve

``` r
MyConcTimeMulti <- caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
head(MyConcTimeMulti)
```

|  Subject|  Time|      Conc|
|--------:|-----:|---------:|
|        1|   0.0|  0.000000|
|        1|   0.1|  2.246175|
|        1|   0.2|  3.967582|
|        1|   0.3|  5.278256|
|        1|   0.4|  6.267589|
|        1|   0.5|  7.005656|

### Create a concentration-time curve

``` r
caffPlotMulti(MyConcTimeMulti)
```

![](README_files/figure-markdown_github/MyPlotMultiMyConcTimeMulti-1.png)

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

![](README_files/figure-markdown_github/MyPlotMultiPub-1.png)

Interactive shiny app
---------------------

``` r
caffShiny()
```
