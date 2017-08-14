library(shiny)
library(ggplot2)
library(dplyr)
library(markdown)
library(mgcv)
library(psych)
library(ggforce)

CaffSigma <- matrix(c(0.1599, 6.095e-2, 9.650e-2, 
                      6.095e-2, 4.746e-2, 1.359e-2, 
                      9.650e-2, 1.359e-2, 1.004), nrow = 3)
CaffMu <- c(0,0,0)
Seed <- sample.int(10000, size = 1)
#set.seed(20140523+1)
#BWT = 25; Dose = 80

round_df <- function(x, digits) {
  # round all numeric variables
  # x: data frame 
  # digits: number of digits to round
  numeric_columns <- sapply(x, mode) == 'numeric'
  x[numeric_columns] <-  round(x[numeric_columns], digits)
  x
}

Dataset <- function(BWT, Dose, Num){
  #set.seed(20140523+1)
  MVN <- rmvn(Num, CaffMu, CaffSigma);  
  MVNdata <- data.frame(MVN, stringsAsFactors = FALSE) %>% 
    select(eta1 = X1, eta2 = X2, eta3 = X3) %>% 
    mutate(CL = 0.09792 * BWT * exp(eta1), # L/hr
           V  = 0.7219 * BWT * exp(eta2), # L, TVV =THETA[2] * (1 + ABST*THETA[7]) [1] 0.7218775
           Ka = 4.268 * exp(eta3), # /hr
           Ke = CL / V) %>%  
    mutate(Tmax = (log(Ka) - log(Ke)) / (Ka - Ke),
           Cmax = Dose / V * Ka / (Ka - Ke) * (exp(-Ke * Tmax) - exp(-Ka * Tmax)), 
           AUC  = Dose / CL, # mg/h/L
           Half_life = 0.693 / Ke) %>% select(Tmax, Cmax, AUC, Half_life, CL, V, Ka, Ke)
  return(MVNdata)
}

DatasetMulti <- function(BWT, Dose, Num, Tau){
  #set.seed(20140523+1)
  MVN <- rmvn(Num, CaffMu, CaffSigma);  
  MVNdata <- data.frame(MVN, stringsAsFactors = FALSE) %>% 
    select(eta1 = X1, eta2 = X2, eta3 = X3) %>% 
    mutate(CL = 0.09792 * BWT * exp(eta1), # L/hr
           V  = 0.7219 * BWT * exp(eta2), # L, TVV =THETA[2] * (1 + ABST*THETA[7]) [1] 0.7218775
           Ka = 4.268 * exp(eta3), # /hr
           Ke = CL / V) %>%  
    mutate(Tmax = (log(Ka) - log(Ke)) / (Ka - Ke),
           Cmax = Dose / V * Ka / (Ka - Ke) * (exp(-Ke * Tmax) - exp(-Ka * Tmax)), 
           Cssav = Dose / (CL * Tau), 
           AI = 1/(1-exp(-1*Ke*Tau)),
           AUC  = Dose / CL, # mg/h/L
           Half_life = 0.693 / Ke) %>% select(Tmax, Cmax, Cssav, AI, AUC, Half_life, CL, V, Ka, Ke)
  return(MVNdata)
}

Simul <- function(df){
  MVNSimulRaw <- describe(df, quant = c(.25, .75)) 
  MVNSimulRaw[, "Parameters"] <- row.names(MVNSimulRaw)
  MVNSimul <- MVNSimulRaw %>% select(Parameters, median, sd, min, Q0.25, mean, Q0.75, max)
  return(MVNSimul)
}

shinyServer(function(input, output, session) {
  
  output$showdata <- renderDataTable({
    ### Start ###
    
    set.seed(Seed)
    showdataTable <- round_df(Dataset(input$concBWT, input$concDose, input$concNum), 2) %>% 
      mutate(SUBJID = row_number()) %>% 
      select(9, 1:8)
    return(showdataTable)
  }, options = list(pageLength = 10))
  
  output$showdataall <- renderTable({
    ### Start ###
    
    if (input$showme == FALSE)
      return(NULL)
    
    set.seed(Seed)
    showall <- round_df(Dataset(input$concBWT, input$concDose, input$concNum), 2) %>% 
      mutate(SUBJID = as.character(row_number())) %>% 
      select(9, 1:8)
    return(showall)
  })
  
  output$plot <- renderPlot({
    #ggDset <- Dataset(20,300,10) %>% #(i, input$Dose, 100) %>% 
    #                       select(Tmax, Cmax, AUC, Half_life, CL, V) %>% 
    #  mutate(BWT)
    ggDset <- data.frame()
    Rnorm <- c(23, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 84)
    for (i in 1:length(Rnorm)){
      ggDset <- bind_rows(
        ggDset,
        Dataset(Rnorm[i], input$cmaxDose, input$cmaxNum) %>% select(Tmax, Cmax, AUC, Half_life, CL, V) %>% 
          mutate(BWT = Rnorm[i])
      )
    }
    p <- ggplot(ggDset, aes(x=factor(BWT), y=Cmax, colour=Cmax)) +
      xlab("Body Weight (kg)") + ylab("Cmax (mg/L)") +
      geom_hline(yintercept = 80, colour="red") + 
      geom_hline(yintercept = 40, colour="blue") + 
      geom_hline(yintercept = 10, colour="green") +
      scale_colour_gradient(low="navy", high="red", space="Lab") + theme_linedraw()
    
    #if (input$pformat == "Sina") print(p + geom_sina(binwidth = 3, size = 1))
    if (input$pformat == "Jitter") print(p + geom_jitter(position = position_jitter(width = .1)))
    if (input$pformat == "Point") print(p + geom_point())
    if (input$pformat == "Boxplot") print(p + geom_boxplot())
    
  })
  
  output$aucplot <- renderPlot({
    #ggDset <- Dataset(20,300,10) %>% #(i, input$Dose, 100) %>% 
    #                       select(Tmax, Cmax, AUC, Half_life, CL, V) %>% 
    #  mutate(BWT)
    ggDset <- data.frame()
    Rnorm <- c(23, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 84)
    for (i in 1:length(Rnorm)){
      ggDset <- bind_rows(
        ggDset,
        Dataset(Rnorm[i], input$aucDose, input$aucNum) %>% select(Tmax, Cmax, AUC, Half_life, CL, V) %>% 
          mutate(BWT = Rnorm[i])
      )
    }
    p <- ggplot(ggDset, aes(x=factor(BWT), y=AUC, colour=AUC)) +
      xlab("Body Weight (kg)") + ylab("AUC (mg*hr/L)") + theme_linedraw()
    
    #if (input$paucformat == "Sina") print(p + geom_sina(binwidth = 4))
    if (input$paucformat == "Jitter") print(p + geom_jitter(position = position_jitter(width = .1)))
    if (input$paucformat == "Point") print(p + geom_point())
    if (input$paucformat == "Boxplot") print(p + geom_boxplot())
    
  })
  output$overlimit <- renderTable({
    Subject <- seq(1, input$concNum, length.out = input$concNum) # 
    Time <- seq(0,30, by = 0.1)
    Grid <- expand.grid(x = Subject, y = Time) %>% select(Subject=x, Time=y)
    
    set.seed(Seed)
    ggConc <- Dataset(input$concBWT, input$concDose, input$concNum) %>% select(CL, V, Ka, Ke) %>% 
      mutate(Subject = row_number()) %>% 
      left_join(Grid, by = "Subject") %>% 
      mutate(Conc = input$concDose / V * Ka / (Ka - Ke) * (exp(-Ke * Time) - exp(-Ka * Time))) %>% 
      mutate(Conc40 = ifelse(Conc >=40, 0.1, 0),
             Conc80 = ifelse(Conc >=80, 0.1, 0)) %>% 
      select(Subject, Conc40, Conc80) %>% group_by(Subject) %>% 
      summarise(MeanConc80 = sum(Conc80), MeanConc40 = sum(Conc40)) %>% select(-Subject)
    OverLimitRaw <- describe(ggConc, quant = c(.25, .75)) 
    OverLimitRaw[, "Index"] <- row.names(OverLimitRaw)
    OverLimit <- OverLimitRaw %>% select(Index, median, sd, min, Q0.25, mean, Q0.75, max)  
    OverLimit[OverLimit == "MeanConc40"] <- ">40mg/L (hr)"
    OverLimit[OverLimit == "MeanConc80"] <- ">80mg/L (hr)"
    return(OverLimit)
  })
  output$concplot <- renderPlot({
    
    Subject <- seq(1, input$concNum, length.out = input$concNum) # 
    Time <- seq(0,24, by = 0.1)
    Grid <- expand.grid(x = Subject, y = Time) %>% select(Subject=x, Time=y)
    
    set.seed(Seed)
    ggConc <- Dataset(input$concBWT, input$concDose, input$concNum) %>% select(CL, V, Ka, Ke) %>% 
      mutate(Subject = row_number()) %>% 
      left_join(Grid, by = "Subject") %>% 
      mutate(Conc = input$concDose / V * Ka / (Ka - Ke) * (exp(-Ke * Time) - exp(-Ka * Time)))
    
    p <- ggplot(ggConc, aes(x=Time, y=Conc)) + 
      xlab("Time (hour)") + ylab("Concentration (mg/L)") +
      scale_x_continuous(breaks = seq(from = 0, to = 24, by = 4)) +
      #scale_color_gradient2() +
      #scale_colour_gradient(low="navy", high="red", space="Lab") +
      geom_line(aes(group = Subject, colour = Conc)) + 
      stat_summary(fun.y = "mean", colour = "#F0E442", size = 1, geom = "line") +
      geom_hline(yintercept = 80, colour="red") + 
      geom_hline(yintercept = 40, colour="blue") + 
      geom_hline(yintercept = 10, colour="green") + theme_linedraw()
    if (input$Log == FALSE) print(p) else print(p + scale_y_log10())#limits = c(0.1, max(80, ggConc$Conc))))
  })
  
  output$conccontents <- renderTable({
    ### Start ###
    set.seed(Seed)
    ConcUnit <- Simul(Dataset(input$concBWT, input$concDose, input$concNum))
    ConcUnit[ConcUnit == "Tmax"] <- "Tmax (hr)"
    ConcUnit[ConcUnit == "Cmax"] <- "Cmax (mg/L)"
    ConcUnit[ConcUnit == "AUC"] <- "AUC (mg*hr/L)"
    ConcUnit[ConcUnit == "Half_life"] <- "Half_life (hr)"
    ConcUnit[ConcUnit == "CL"] <- "CL (L/hr)"
    ConcUnit[ConcUnit == "V"] <- "V (L)"
    ConcUnit[ConcUnit == "Ka"] <- "Ka (1/hr)"
    ConcUnit[ConcUnit == "Ke"] <- "Ke (1/hr)"
    
    #        select(Tmax, Cmax, AUC, Half_life, CL, V, Ka, Ke)
    return(ConcUnit)
  })
  
  output$supercontents <- renderTable({
    ### Start ###
    set.seed(Seed)
    ConcUnit <- Simul(DatasetMulti(input$superBWT, input$superDose, input$superNum, input$superTau))
    ConcUnit[ConcUnit == "Tmax"] <- "Tmax (hr)"
    ConcUnit[ConcUnit == "Cmax"] <- "Cmax (mg/L)"
    ConcUnit[ConcUnit == "Cssav"] <- "Cav,ss (mg/L)"
    ConcUnit[ConcUnit == "AUC"] <- "AUC (mg*hr/L)"
    ConcUnit[ConcUnit == "Half_life"] <- "Half_life (hr)"
    ConcUnit[ConcUnit == "CL"] <- "CL (L/hr)"
    ConcUnit[ConcUnit == "V"] <- "V (L)"
    ConcUnit[ConcUnit == "Ka"] <- "Ka (1/hr)"
    ConcUnit[ConcUnit == "Ke"] <- "Ke (1/hr)"
    
    return(ConcUnit)
  })
  
  output$superplot <- renderPlot({
    Subject <- seq(1, input$superNum, length.out = input$superNum) # 
    Time <- seq(0, 96, length.out = 481) # 
    Grid <- expand.grid(x = Subject, y = Time) %>% select(Subject=x, Time=y)
    
    set.seed(Seed)
    ## Prep for Superposition
    ggsuper <- Dataset(input$superBWT, input$superDose, input$superNum) %>% select(CL, V, Ka, Ke) %>% 
      mutate(Subject = row_number()) %>% 
      left_join(Grid, by = "Subject") %>% 
      mutate(Conc = input$superDose / V * Ka / (Ka - Ke) * (exp(-Ke * Time) - exp(-Ka * Time))) %>% 
      group_by(Subject) %>% 
      mutate(ConcOrig = Conc, 
             ConcTemp = 0)
    ## Superposition
    for (i in 1:input$superRepeat){
      Frame <- input$superTau * 5 * i
      ggsuper <- ggsuper %>% 
        mutate(Conc = Conc + ConcTemp) %>% 
        mutate(ConcTemp = lag(ConcOrig, n = Frame, default = 0))
    }
    ## Plot
    p <- ggplot(ggsuper, aes(x=Time, y=Conc)) + #, group=Subject, colour = Conc)) + #Subject)) +
      xlab("Time (hour)") + ylab("Concentration (mg/L)") +
      scale_x_continuous(breaks = seq(0, 96, 12)) +
      #scale_colour_gradient(low="navy", high="red", space="Lab") +
      geom_line(aes(group = Subject, colour = Conc)) + 
      stat_summary(fun.y = "mean", colour = "#F0E442", size = 1, geom = "line") +
      geom_hline(yintercept = 80, colour="red") + 
      geom_hline(yintercept = 40, colour="blue") + 
      geom_hline(yintercept = 10, colour="green") + theme_linedraw()
    if (input$superLog == FALSE) print(p) else print(p + scale_y_log10())#limits = c(0.1, max(80, ggsuper$Conc))))
  })
})
