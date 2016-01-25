library(shiny)
library(shinyjs)
library(npregfast)



shinyServer(function(input, output) {
  
  
  output$distPlot <- renderPlot({
    
    data(barnacle)
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
    
  
      
    fit <- frfast(form, data = barnacle, nboot = 100, kernel = input$kernel,
                  h0 = h0, h = h)
    plot(fit, der = as.numeric(input$der), points = input$show_points, 
         CIcol = input$colci, col = input$colmu, CIlwd = 2, 
         ablinecol = "#24281A")
    
  })
  
  output$text <- renderText({print(as.numeric(input$der))})
  output$text2 <- renderText({0 %in% as.numeric(input$der)})
  
  
  # hide the loading message
  hide("loading-content", TRUE, "fade")
})
