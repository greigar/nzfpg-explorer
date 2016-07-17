# ui.R
library(feather)
nodes <- read_feather("data/union_nodes.feather")

shinyUI(fluidPage(
  titlePanel("Final Prices"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Final Prices per Node"),
    
      selectInput("node", label = "Choose a node", choices = nodes, selected = "ARA2201"),
    
      sliderInput("range", label = "Period:", min = 1, max = 50, value = c(10, 40)),

      sliderInput("price", label = "Price:", min = 0, max = 6000, value = c(0, 40)),

      dateRangeInput("trading_date", label = "Date:", start = "2014-12-01", end = "2015-01-01",
                                                      min   = "2014-12-01", max = "2015-07-01")
    ),
  
    mainPanel(
              h4("Price"),
              plotOutput("priceplot"),
              h4("Generation"),
              plotOutput("genplot")
    )
  )
))
