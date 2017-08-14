


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
head(MyDataset)
```

<div class="kable-table">

      Tmax       Cmax         AUC   Half_life          CL           V          Ka          Ke
----------  ---------  ----------  ----------  ----------  ----------  ----------  ----------
 1.4309324   18.27318   203.56075    6.650544   0.9825077    9.428875    2.251887   0.1042020
 0.4885094   11.67240    91.28898    5.069805   2.1908450   16.027644    8.619832   0.1366916
 0.6917703   12.11631    83.29850    4.256876   2.4010035   14.748592    5.158553   0.1627954
 0.2234860   10.73329    38.98148    2.356780   5.1306416   17.448473   18.929386   0.2940453
 0.3704422   14.20042   118.05924    5.498651   1.6940648   13.441660   12.545139   0.1260309
 0.6769637   14.09958   127.45686    5.775839   1.5691584   13.078220    5.865480   0.1199826

</div>

### Create a dataset for concentration-time curve


```r
MyConcTime <- caffConcTime(Weight = 20, Dose = 200, N = 20)
head(MyConcTime)
```

<div class="kable-table">

 Subject   Time       Conc
--------  -----  ---------
       1    0.0   0.000000
       1    0.1   1.446710
       1    0.2   2.701914
       1    0.3   3.789089
       1    0.4   4.728855
       1    0.5   5.539316

</div>

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
MyDatasetMulti <- caffDatasetMulti(Weight = 20, Dose = 200, N = 20, Tau = 12)
head(MyDatasetMulti)
```

<div class="kable-table">

     TmaxS       CmaxS        AUCS         AI       Aavss       Cavss     Cmaxss     Cminss
----------  ----------  ----------  ---------  ----------  ----------  ---------  ---------
 0.9947726   11.239218   102.71644   1.292808   134.39508    8.559703   16.43369   3.722067
 0.7125730   14.066074   135.77984   1.351564   148.21048   11.314986   20.59385   5.356802
 1.4087801   11.320406   124.17216   1.390557   157.16687   10.347680   18.27244   5.132063
 0.4442671   10.177146    98.42169   1.373538   153.27558    8.201807   14.66909   3.989305
 0.5283142    9.895771    61.27219   1.135101    93.76948    5.106016   12.33619   1.468268
 0.6771583    9.276368    47.52950   1.069582    73.04048    3.960792   11.57600   0.753084

</div>

### Create a dataset for concentration-time curve


```r
MyConcTimeMulti <- caffConcTimeMulti(Weight = 20, Dose = 200, N = 20, Tau = 12, Repeat = 10)
head(MyConcTimeMulti)
```

<div class="kable-table">

 Subject   Time       Conc
--------  -----  ---------
       1    0.0    0.00000
       1    0.2   10.92767
       1    0.4   13.52807
       1    0.6   13.98399
       1    0.8   13.89084
       1    1.0   13.66024

</div>

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
