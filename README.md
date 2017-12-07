---
output: 
  html_document: 
    self_contained: no
    keep_md: yes
    df_print: kable
editor_options: 
  chunk_output_type: console
---



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



| subjid|      Tmax|      Cmax|       AUC| Half_life|        CL|        V|         Ka|        Ke|
|------:|---------:|---------:|---------:|---------:|---------:|--------:|----------:|---------:|
|      1| 2.9003970| 12.734147| 169.58615|  6.895391| 1.1793416| 11.73452|  0.8272927| 0.1005019|
|      2| 1.5941340| 16.584026| 224.44514|  8.196288| 0.8910863| 10.53911|  2.0995056| 0.0845505|
|      3| 1.7302444| 11.044962|  88.01492|  4.131165| 2.2723420| 13.54606|  1.3897981| 0.1677493|
|      4| 0.4804426| 11.266602|  96.16397|  5.571876| 2.0797811| 16.72191|  9.0472181| 0.1243746|
|      5| 1.0591154|  8.077437|  52.87396|  3.725028| 3.7825806| 20.33221|  2.7180825| 0.1860389|
|      6| 0.2847157| 12.728310|  65.24625|  3.349133| 3.0653101| 14.81404| 15.3275430| 0.2069192|

### Create a dataset for concentration-time curve


```r
MyConcTime <- caffConcTime(Weight = 20, Dose = 200, N = 20)
knitr::kable(head(MyConcTime), format = 'markdown') 
```



| Subject| Time|     Conc|
|-------:|----:|--------:|
|       1|  0.0|  0.00000|
|       1|  0.1| 17.66372|
|       1|  0.2| 19.40917|
|       1|  0.3| 19.37823|
|       1|  0.4| 19.15167|
|       1|  0.5| 18.90612|

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



| subjid|     TmaxS|     CmaxS|      AUCS|       AI|     Aavss|     Cavss|   Cmaxss|    Cminss|
|------:|---------:|---------:|---------:|--------:|---------:|---------:|--------:|---------:|
|      1| 1.6342263| 16.124255| 323.02779| 2.081215| 304.77046| 26.918982| 36.68836| 19.060022|
|      2| 0.2280164| 11.513295|  92.47913| 1.273485| 129.74616|  7.706594| 15.09689|  3.242108|
|      3| 0.5284876| 11.809599|  82.99510| 1.185982| 107.72745|  6.916258| 15.19668|  2.383098|
|      4| 0.6356576| 20.062061| 312.47832| 1.810135| 248.25251| 26.039860| 37.89499| 16.960094|
|      5| 0.9068711|  9.236732|  55.60042| 1.101123|  83.58654|  4.633368| 12.18209|  1.118752|
|      6| 1.7245049| 11.479680| 136.29292| 1.430291| 166.15773| 11.357743| 19.51289|  5.870285|

### Create a dataset for concentration-time curve


```r
MyConcTimeMulti <- caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
knitr::kable(head(MyConcTimeMulti), format = 'markdown')
```



| Subject| Time|      Conc|
|-------:|----:|---------:|
|       1|  0.0|  0.000000|
|       1|  0.1|  5.744079|
|       1|  0.2|  9.105649|
|       1|  0.3| 11.044072|
|       1|  0.4| 12.132754|
|       1|  0.5| 12.714412|

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

