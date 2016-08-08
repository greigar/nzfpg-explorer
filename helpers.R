# helpers.R
library(ggplot2) # for nice plot
library(feather) # for loading data
library(dplyr)   # for filtering

finalprices <- read_feather("data/finalprices.feather")
generation  <- read_feather("data/generation_aggr.feather")

prices <- function(node, trading_period_min, trading_period_max, price_min, price_max, trading_date_min, trading_date_max) {

  dplyr::filter(finalprices,
                  Node           == node                         &
                  Trading_period >= trading_period_min           &
                  Trading_period <= trading_period_max           &
                  Price          >= price_min                    &
                  Price          <= price_max                    &
                  Trading_date   >= as.Date(trading_date_min) &
                  Trading_date   <= as.Date(trading_date_max)) %>%
    ggplot(aes(x=Trading_date, y=Trading_period)) + 
      geom_tile(aes(fill=Price), colour="grey") + 
      scale_fill_gradient(low="white", high="red")
}

kwhs <- function(node, trading_period_min, trading_period_max, trading_date_min, trading_date_max) {

  dplyr::filter(generation,
                  Node           == node                         &
                  Trading_period >= trading_period_min           &
                  Trading_period <= trading_period_max           &
                  Trading_date   >= as.Date(trading_date_min) &
                  Trading_date   <= as.Date(trading_date_max)) %>%
    ggplot(aes(Trading_date, Trading_period)) + 
      geom_point(aes(size = kwh, colour = kwh)) + 
      scale_colour_gradient(low = "green", high = "red")
}

