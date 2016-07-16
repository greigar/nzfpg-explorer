# nzfpg-explorer
Shiny R app for NZ electricity final prices and generation

## The following R packages are required:

* ggplot2
* feather
* dplyr
* lubridate
* magrittr
* reshape2
* shiny

## Running

Assuming a shiny-apps directory exists...

Download data from EA-EMI:

`source("shiny-apps/nzfpg-explorer/scripts/10-final-gen-get.R")`

Clean the data:

`source("shiny-apps/nzfpg-explorer/scripts/20-final-gen-tidy.R")`

Run the Shiny app:

`runApp("nzfpg-explorer")`

