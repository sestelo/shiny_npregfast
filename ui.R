library(shiny)
library(shinyjs)
library(wesanderson)


shinyUI(fluidPage(
  title = "Demo of npregfast",
  tags$head(includeCSS(file.path('style', 'style.css'))),   
  useShinyjs(),
  
  fluidRow(id = "title-row",
      column(12,
        h1("Demo of",em(a("npregfast", href = "https://github.com/sestelo/npregfast"))),
        h4("Example with", a("barnacle", href = "https://github.com/sestelo/npregfast/blob/master/man/barnacle.Rd")," data set"),
        div("Created by", a("Marta Sestelo", href = "http://sestelo.github.io"),
            "and", a("Nora M. Villanueva",href = "http://noramvillanueva.github.io"), HTML("&bull;"),
            "Code on", a("GitHub", href = "https://github.com/sestelo/shiny_npregfast/")
            )
      )
  ),
  
  
  
  div(id = "loading-content", h2("Loading...")),
  
  fluidRow(id = "app-content",
           column(3, wellPanel(
             class = "settings",
             h4(class = "settings-title", "Estimation"),
             
             selectInput(inputId = "type", 
                         label = "Factor-by-curve interaction?",
                         choices = c("Without" = "without", "With" = "with")),
             
             selectInput(inputId = "kernel",
                         label = "Choose a kernel:",
                         choices = c("Epanechnikov" = "epanech", 
                                     "Gaussian" = "gaussian",
                                     "Triangular" = "triang")),
             
             radioButtons(inputId = "selband",
                          label = "Bandwidth selection:",
                          choices = c("Cross-validation" = "cv", 
                                      "Manual" = "man"),
                          selected = "cv"),
             
             conditionalPanel(
               condition = "input.selband == 'man'",
               sliderInput(inputId = "band",
                           label = "Bandwidth selection:",
                           min = 0,
                           max = 1,
                           value = 0.5,
                           step = 0.1, 
                           ticks = TRUE))
             
           )),
           
           
           
           
           
           column(3, wellPanel(
             class = "settings",
             h4(class = "settings-title", "Graphical"),
             
             checkboxGroupInput(inputId = "der",
                          label = "Output:",
                          choices = c("Conditional mean" = 0, 
                                      "First derivative" = 1,
                                      "Second derivative" = 2),
                          selected = 0),
             
             
             
             div(id = "marginal-settings",
                 shinyjs::colourInput("colmu", "Line color", "#D67236", 
                                      showColour = "background",
                                      palette = "limited",
                                      allowedCols = unlist(wes_palettes),
                                      allowTransparent = FALSE),
                 
                 
                 shinyjs::colourInput("colci", "CI color", "#5B1A18", 
                                      showColour = "background",
                                      palette = "limited",
                                      allowedCols = unlist(wes_palettes),
                                      allowTransparent = FALSE)
                 
             ),
             
             
          
             conditionalPanel(
               condition ="input.der.length > 1 & ",
             checkboxInput("show_points", "Show data points", TRUE))
             
             
           )),
           
           
           
           column(6,
                  plotOutput("distPlot", height = "550px", width = "100%"),
                  textOutput({"text"}),
                  textOutput({"text2"})
                  
                  
           )
  )
))







