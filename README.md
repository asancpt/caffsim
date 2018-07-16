
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
knitr::kable(head(MyDataset), format = 'markdown')
```

|  subjid|       Tmax|       Cmax|        AUC|  Half\_life|        CL|         V|          Ka|         Ke|
|-------:|----------:|----------:|----------:|-----------:|---------:|---------:|-----------:|----------:|
|       1|  0.8148501|   9.765873|   71.47865|    4.470317|  2.798038|  18.04923|   4.2055795|  0.1550226|
|       2|  2.7379512|  14.332675|  179.09632|    6.453709|  1.116718|  10.39967|   0.8725796|  0.1073801|
|       3|  0.7986741|  14.452012|  116.14283|    4.983874|  1.722018|  12.38430|   4.4896411|  0.1390485|
|       4|  0.9658179|  12.432690|   91.96398|    4.403226|  2.174765|  13.81815|   3.3117453|  0.1573846|
|       5|  2.4169272|   8.871359|   79.49317|    4.145907|  2.515939|  15.05173|   0.8303826|  0.1671528|
|       6|  0.3910168|  17.203294|  123.96316|    4.714693|  1.613382|  10.97634|  11.2377919|  0.1469873|

### Create a dataset for concentration-time curve

``` r
MyConcTime <- caffConcTime(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyConcTime), format = 'markdown') 
```

|  Subject|  Time|       Conc|
|--------:|-----:|----------:|
|        1|   0.0|   0.000000|
|        1|   0.1|   9.489546|
|        1|   0.2|  10.656723|
|        1|   0.3|  10.701944|
|        1|   0.4|  10.597074|
|        1|   0.5|  10.473274|

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
knitr::kable(head(MyDatasetMulti), format = 'markdown') 
```

|  subjid|      TmaxS|      CmaxS|       AUCS|        AI|     Aavss|      Cavss|    Cmaxss|     Cminss|
|-------:|----------:|----------:|----------:|---------:|---------:|----------:|---------:|----------:|
|       1|  2.5410437|   7.959171|  107.93585|  1.482683|  177.8429|   8.994654|  14.96656|   4.872315|
|       2|  0.3409232|  14.956262|  142.55354|  1.371243|  152.7488|  11.879462|  21.28429|   5.762396|
|       3|  1.2735338|  10.061808|   92.61971|  1.274929|  130.0956|   7.718309|  15.09633|   3.255408|
|       4|  2.2509568|  14.122122|  210.43792|  1.615348|  206.7975|  17.536494|  27.33941|  10.414629|
|       5|  0.5459366|  16.922085|  125.89823|  1.211267|  114.2896|  10.491519|  22.19204|   3.870690|
|       6|  1.7910321|  13.647522|  165.30180|  1.442395|  168.8732|  13.775150|  23.48256|   7.202304|

### Create a dataset for concentration-time curve

``` r
MyConcTimeMulti <- caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
knitr::kable(head(MyConcTimeMulti), format = 'markdown')
```

|  Subject|  Time|      Conc|
|--------:|-----:|---------:|
|        1|   0.0|  0.000000|
|        1|   0.1|  2.452554|
|        1|   0.2|  4.448573|
|        1|   0.3|  6.067268|
|        1|   0.4|  7.374178|
|        1|   0.5|  8.423533|

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
