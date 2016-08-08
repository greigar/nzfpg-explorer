library(reshape2)  # for melt-ing
library(dplyr)     # for changing data frames and aggregation
library(feather)   # for writing out results
library(readr)     # for csv reading
library(lubridate) # for date arithmetic in the config file

# setwd("shiny-apps/nzfpg-explorer")

# __________________________________________________
#
# Read data in from the CSV files
# __________________________________________________

# Generation file column spec
gen_cols <- cols(.default     = col_double(),
                 Site_Code    = col_character(),
                 POC_Code     = col_character(),
                 Nwk_Code     = col_character(),
                 Gen_Code     = col_character(),
                 Fuel_Code    = col_character(),
                 Tech_Code    = col_character(),
                 Trading_date = col_date(format = ""),
                 TP49         = col_double(),
                 TP50         = col_double())

# Final prices file column spec
fp_cols <- cols(Trading_date   = col_date(format = ""),
                Trading_period = col_integer(),
                Node           = col_character(),
                Price          = col_double())

# Nice function to load up multiple files into one data frame
# From http://www.r-bloggers.com/merging-multiple-data-files-into-one-data-frame/
#      http://www.r-bloggers.com/author/tony-cookson/
multmerge = function(thepath, filter, col_spec){
  filenames = list.files(path = thepath, filter, full.names = TRUE)
  datalist  = lapply(filenames, function(x) {read_csv(file = x, col_types = col_spec)})
  Reduce(function(x,y) {rbind(x, y)}, datalist)
}

generation  <- multmerge("data/downloads", "*Generation_MD.csv", gen_cols)
finalprices <- multmerge("data/downloads", "*Final_prices.csv",  fp_cols)

# __________________________________________________
#
# Tidy it up 
# __________________________________________________

# Get nodes that are in both final prices and generation
fpnodes     <- sort(unique(finalprices$Node))
gnnodes     <- sort(unique(generation$POC_Code))
union_nodes <- union(fpnodes, gnnodes)

# Transform into tidy data
generation <- generation %>%
  melt(id=1:7, na.rm = TRUE) %>%
  transmute(Trading_date   = Trading_date, 
            Trading_period = as.integer(substr(variable, 3, 4) ), 
            Node           = POC_Code, 
            kwh            = value, 
            Fuel_Code      = Fuel_Code)

# Aggregate Generation based on date, period and node only
generation_aggr <- generation %>%
  group_by(Trading_date, Trading_period, Node) %>%
  summarise(kwh = sum(kwh))

# __________________________________________________
#
# Write out data for use in the Shiny application
# __________________________________________________

# fast feather format
write_feather(as.data.frame(union_nodes, stringsAsFactors = FALSE), "data/union_nodes.feather")
write_feather(finalprices,     "data/finalprices.feather")
write_feather(generation_aggr, "data/generation_aggr.feather")


# Create the config file to drive the min/max parameters
max_date   <- max(finalprices$Trading_date)
min_price  <- min(finalprices$Price)

nzfpg_config <- list("min_price"  = min_price,
                     "max_price"  = max(finalprices$Price),
                     "min_date"   = min(finalprices$Trading_date),
                     "max_date"   = max_date,
                     "from_date"  = max_date - 14,
                     "to_date"    = max_date,
                     "from_price" = min_price,
                     "to_price"   = quantile(finalprices$Price)[[3]])

saveRDS(nzfpg_config, file = "data/nzfpg_config.rds")

