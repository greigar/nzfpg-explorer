# server.R
source("helpers.R")
    
shinyServer(
  function(input, output) {

    create_params <- function(input) {
      args                    <- input$node
      args$trading_period_min <- input$range[1]
      args$trading_period_max <- input$range[2]
      args$trading_date_min   <- input$trading_date[1]
      args$trading_date_max   <- input$trading_date[2]
      args
    }

    create_params_prices <- function(input) {
      args <- create_params(input)
      args$price_min <- input$price[1]
      args$price_max <- input$price[2]
      args
    }

    output$priceplot <- renderPlot({
      args <- create_params_prices(input)
      filter_formula <- do.call(create_filter_formula, args)
      prices(filter_formula)
    })

    output$pricehex  <- renderPlot({
      args <- create_params_prices(input)
      filter_formula <- do.call(create_filter_formula, args)
      pricehex(filter_formula)
    })

    output$genplot <- renderPlot({
      args <- create_params(input)
      do.call(kwhs, args)
    })

  }
)
