


# `caffsim` R package: Simulation of Plasma Caffeine Concentrations by Using Population Pharmacokinetic Model

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.842649.svg)](https://doi.org/10.5281/zenodo.842649) 
![CRAN downloads](http://cranlogs.r-pkg.org/badges/grand-total/caffsim)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/caffsim)](https://cran.r-project.org/package=caffsim)

> Simulate plasma caffeine concentrations using population pharmacokinetic model described in Lee, Kim, Perera, McLachlan and Bae (2015) <doi:10.1007/s00431-015-2581-x>.

- Github: <https://github.com/asancpt/caffsim>
- Package vignettes and references by `pkgdown`: <http://asancpt.github.io/caffsim> 

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



| subjid|      Tmax|      Cmax|       AUC| Half_life|       CL|        V|         Ka|        Ke|
|------:|---------:|---------:|---------:|---------:|--------:|--------:|----------:|---------:|
|      1| 0.5655111| 11.291824|  60.24647|  3.281173| 3.319696| 15.71789|  6.1820434| 0.2112049|
|      2| 0.4701949| 15.171198|  94.54809|  3.979272| 2.115326| 12.14640|  8.4236385| 0.1741524|
|      3| 0.9499244|  6.863754|  62.81142|  5.643536| 3.184134| 25.93041|  3.7110212| 0.1227954|
|      4| 0.7614789| 11.856222| 102.84659|  5.457355| 1.944644| 15.31402|  4.9329239| 0.1269846|
|      5| 0.3671727| 12.045754|  49.60140|  2.586212| 4.032145| 15.04759| 10.1722397| 0.2679595|
|      6| 5.3930577| 10.938642| 179.10142|  6.224503| 1.116686| 10.03003|  0.2867746| 0.1113342|

### Create a dataset for concentration-time curve


```r
MyConcTime <- caffConcTime(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyConcTime), format = 'markdown') 
```



| Subject| Time|      Conc|
|-------:|----:|---------:|
|       1|  0.0|  0.000000|
|       1|  0.1|  3.597156|
|       1|  0.2|  6.177010|
|       1|  0.3|  8.016618|
|       1|  0.4|  9.317695|
|       1|  0.5| 10.227099|

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



| subjid|     TmaxS|     CmaxS|      AUCS|       AI|    Aavss|     Cavss|    Cmaxss|   Cminss|
|------:|---------:|---------:|---------:|--------:|--------:|---------:|---------:|--------:|
|      1| 1.3690238|  6.210796|  44.68358| 1.135524|  93.8910|  3.723632|  8.988038| 1.072718|
|      2| 0.3001011| 13.655855|  97.01756| 1.206465| 113.0584|  8.084797| 17.218958| 2.946721|
|      3| 0.2680477| 18.231856| 101.79732| 1.116443|  88.2919|  8.483110| 21.409005| 2.232919|
|      4| 0.3863132| 11.076209|  78.16780| 1.197577| 110.7613|  6.513983| 14.056833| 2.319103|
|      5| 1.1767955|  7.361027|  74.13932| 1.344519| 146.5760|  6.178277| 11.310903| 2.898302|
|      6| 0.5523147| 16.182537| 187.47985| 1.507252| 183.2668| 15.623321| 25.644911| 8.630565|

### Create a dataset for concentration-time curve


```r
MyConcTimeMulti <- caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
knitr::kable(head(MyConcTimeMulti), format = 'markdown')
```



| Subject| Time|     Conc|
|-------:|----:|--------:|
|       1|  0.0| 0.000000|
|       1|  0.1| 1.151194|
|       1|  0.2| 2.198578|
|       1|  0.3| 3.150142|
|       1|  0.4| 4.013281|
|       1|  0.5| 4.794837|

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

