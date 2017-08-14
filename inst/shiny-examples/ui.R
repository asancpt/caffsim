# setup ----

# input <- list()
# input$concBWT <- 50; input$concDose <- 200; input$concNum <- 20
# input$cmaxDose <- 50; input$cmaxNum <- 20
# input$aucDose <- 50; input$aucNum <- 20
# input$Log <- FALSE
# input$superBWT <- 20; input$superDose <- 500; input$superNum <- 20; input$superTau <- 5; input$superRepeat <- 3

shinyUI(
  navbarPage(
    title = "Caffeine Concentration Predictor",
    tabPanel(
      
      # single ----
      
      title = "Single",
      sidebarLayout(
        sidebarPanel(
          sliderInput(
            inputId = "concBWT",  
            label = "Body Weight (kg)", 
            min = 20, max = 100, value = 50, step = 1, round=0),
          
          sliderInput('concDose', 'Caffeine Dose (mg)', min=50, max=2000,
                      value=250, step=50),
          
          helpText('Red Bull®, 80 mg / Monster® and Rockstar®, 160 mg / 5 h Energy Extra
                         Strength® 242 mg'),
          
          sliderInput('concNum', 'Simulations N', min=5, max=2000,
                      value=20, step=5),
          checkboxInput(inputId = "Log", label = "Log scale")
        ),
        
        mainPanel(
          tags$h3("Concentration-time Curves of Caffeine"),
          plotOutput("concplot"),
          includeMarkdown("reference.md"),
          tags$h3("Duration of Toxic Concentration"),
          tableOutput("overlimit"),
          #helpText('Duration of Toxic Action'),
          tags$h3("Descriptive Statistics of PK parameters"),
          tableOutput("conccontents"),
          tags$h3("Individual PK parameters"),
          dataTableOutput("showdata"),
          checkboxInput(inputId = "showme", label = "Show me all the data entries together."),
          tableOutput("showdataall")
        )
      )
    ),
    
    # multiple ----
    
    tabPanel(
      title = "Multiple",
      sidebarLayout(
        sidebarPanel(
          sliderInput(
            inputId = "superBWT",  
            label = "Body Weight (kg)", 
            min = 20, max = 100, value = 50, step = 1, round=0),
          
          sliderInput('superDose', 'Caffeine Dose (mg)', min=50, max=2000,
                      value=250, step=50),
          
          helpText('Red Bull®, 80 mg / Monster® and Rockstar®, 160 mg / 5 h Energy Extra
                         Strength® 242 mg'),
          
          sliderInput('superTau', 'Interval (hr)', min=0, max=48,
                      value=4, step=1),
          
          sliderInput('superRepeat', 'Repeat (times)', min=1, max=24,
                      value=6, step=1),
          
          sliderInput('superNum', 'Simulations N', min=5, max=2000,
                      value=20, step=5),
          
          checkboxInput(inputId = "superLog", label = "Log scale")
        ),
        
        mainPanel(
          tags$h3("Concentration-time Curves of Caffeine"),
          plotOutput("superplot"),
          includeMarkdown("reference.md"),
          tags$h3("Descriptive Statistics of PK parameters"),
          tableOutput("supercontents")
          
        )
      )
    ),
    
    # Cmax ----
    
    tabPanel(
      title = "Cmax",
      sidebarLayout(
        sidebarPanel(
          sliderInput('cmaxDose', 'Caffeine Dose (mg)', min=50, max=2000,
                      value=250, step=50),
          
          helpText('Red Bull®, 80 mg / Monster® and Rockstar®, 160 mg / 5 h Energy Extra
                         Strength® 242 mg'),
          
          sliderInput('cmaxNum', 'Simulations N', min=5, max=2000,
                      value=20, step=5),
          radioButtons(
            inputId = "pformat", label = "Plot Format",
            choices = c(#"Sina" = "Sina", 
              "Jitter" = "Jitter",
              "Point" = "Point",
              "Boxplot" = "Boxplot"),
            selected = "Jitter")
          
        ),
        
        mainPanel(
          tags$h3("Cmax plot"),
          
          plotOutput("plot"),
          includeMarkdown("reference.md")
        )
      )
    ),
    
    # AUC ----
    
    tabPanel(
      title = "AUC",
      sidebarLayout(
        sidebarPanel(
          sliderInput('aucDose', 'Caffeine Dose (mg)', min=50, max=2000,
                      value=250, step=50),
          
          helpText('Red Bull®, 80 mg / Monster® and Rockstar®, 160 mg / 5 h Energy Extra
                         Strength® 242 mg'),
          
          sliderInput('aucNum', 'Simulations N', min=5, max=2000,
                      value=20, step=5),
          radioButtons(
            inputId = "paucformat", label = "Plot Format",
            choices = c(#"Sina" = "Sina",
              "Jitter" = "Jitter",
              "Point" = "Point",
              "Boxplot" = "Boxplot"),
            selected = "Jitter")
        ),
        
        mainPanel(
          tags$h3("AUC plot"),
          plotOutput("aucplot")
          
        )
      )
    ),
    
    # help ----
    
    tabPanel(
      title = "Help", 
      withMathJax(includeMarkdown("README.md"))
    ),
    
    # contact ----
    
    tabPanel(
      title = "Contact", 
      includeMarkdown("CONTACT.md"),
      # includeHTML("disqus.html"),
      includeMarkdown("app.md")
    )
  )
)
