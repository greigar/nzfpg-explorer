# server.R
source("helpers.R")
    
shinyServer(
  function(input, output) {

    output$priceplot <- renderPlot({
      args                    <- input$node
      args$trading_period_min <- input$range[1]
      args$trading_period_max <- input$range[2]
      args$price_min          <- input$price[1]
      args$price_max          <- input$price[2]
      args$trading_date_min   <- input$trading_date[1]
      args$trading_date_max   <- input$trading_date[2]
      do.call(prices, args)
    })

    output$genplot <- renderPlot({
      args                    <- input$node
      args$trading_period_min <- input$range[1]
      args$trading_period_max <- input$range[2]
      args$trading_date_min   <- input$trading_date[1]
      args$trading_date_max   <- input$trading_date[2]
      do.call(kwhs, args)
    })

  }
)
