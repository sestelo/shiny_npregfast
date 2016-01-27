library(shiny)
library(shinyjs)
library(npregfast)
library(miniUI)
library(wesanderson)



shinyServer(function(input, output) {
  
  data  <- barnacle
  # For storing which rows have been excluded
  vals <- reactiveValues(
    keeprows = rep(TRUE, nrow(data))
  )
  
  
  output$distPlot <- renderPlot({
    
    # Plot the kept and excluded points as two separate data sets
    keep    <- data[ vals$keeprows, , drop = FALSE]
    exclude <- data[!vals$keeprows, , drop = FALSE]
    
    
    
    if(input$type == "with"){
      form <- DW ~ RC : F
    }else{
      form <- DW ~ RC
    }
    
    if(input$selband == "cv"){
      h0 = -1
      h = -1
    }else{
      h0 = input$band
      h = input$band
    }
    
    if(input$poly == 1) {der <- as.numeric(input$der1)}
    if(input$poly == 2) {der <- as.numeric(input$der2)}
    if(input$poly == 3) {der <- as.numeric(input$der3)}
    
  
    fit <- frfast(form, data = keep, nboot = 100, kernel = input$kernel,
                  h0 = h0, h = h, p = input$poly)
    plot(fit, der = der, points = input$show_points, 
         CIcol = input$colci, col = input$colmu, CIlwd = 2, 
         ablinecol = "#24281A", pch = 16)
    
  })
  
  # Toggle points that are clicked
  observeEvent(input$plot1_click, {
    res <- nearPoints(data, input$plot1_click, allRows = TRUE,
                      xvar = "RC", yvar = "DW")
    
    vals$keeprows <- xor(vals$keeprows, res$selected_)
  })
  
  # Toggle points that are brushed, when button is clicked
  observeEvent(input$exclude_toggle, {
    res <- brushedPoints(data, input$plot1_brush, allRows = TRUE,
                         xvar = "RC", yvar = "DW")
    
    vals$keeprows <- xor(vals$keeprows, res$selected_)
  })
  
  # Reset all points
  observeEvent(input$exclude_reset, {
    vals$keeprows <- rep(TRUE, nrow(data))
  })
  
  
  
  
  
  # hide the loading message
  hide("loading-content", TRUE, "fade")
})
