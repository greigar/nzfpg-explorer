# helpers.R
library(ggplot2) # for nice plot
library(feather) # for loading data
library(dplyr)   # for filtering
library(hexbin)  # for geom_hex

finalprices <- read_feather("data/finalprices.feather")
generation  <- read_feather("data/generation_aggr.feather")

create_filter_formula <- function(node, trading_period_min, trading_period_max, price_min, price_max, trading_date_min, trading_date_max) {
  ~ Node           == node                      &
    Trading_period >= trading_period_min        &
    Trading_period <= trading_period_max        &
    Price          >= price_min                 &
    Price          <= price_max                 &
    Trading_date   >= as.Date(trading_date_min) &
    Trading_date   <= as.Date(trading_date_max)
}

prices <- function(filter_formula) {
  dplyr::filter_(finalprices, filter_formula) %>%
    ggplot(aes(x=Trading_date, y=Trading_period)) + 
      geom_tile(aes(fill=Price), colour="grey") + 
      scale_fill_gradient(low="white", high="red")
}

pricehex <- function(filter_formula) {
  dplyr::filter_(finalprices, filter_formula) %>%
    ggplot(aes(x=Trading_period, y=Price)) + 
      geom_hex(binwidth=c(1,10))  + 
      geom_smooth(color="white", se=F)
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

