# ui.R
library(feather)
nodes  <- read_feather("data/union_nodes.feather")
config <- readRDS("data/nzfpg_config.rds")

shinyUI(fluidPage(
  titlePanel("Final Prices"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Final Prices per Node"),
    
      selectInput("node", label = "Choose a node", choices = nodes, selected = "ARA2201"),
    
      sliderInput("range", label = "Period:", min = 1, max = 50, value = c(10, 40)),

      sliderInput("price", label = "Price:", min = config$min_price, max = config$max_price,
                                             value = c(config$from_price, config$to_price)),

      dateRangeInput("trading_date", label = "Date:", start = config$from_date, end = config$to_date,
                                                      min   = config$min_date,  max = config$max_date)
    ),
  
    mainPanel(
      tabsetPanel(
        tabPanel("Price",      plotOutput("priceplot")),
        tabPanel("PriceHex",   plotOutput("pricehex")),
        tabPanel("Generation", plotOutput("genplot"))
      )
    )
  )
))
