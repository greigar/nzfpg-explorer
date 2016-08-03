library(reshape2)  # for melt-ing
library(dplyr)     # for changing data frames and aggregation
library(feather)   # for writing out results
library(lubridate) # for date arithmetic in the config file

setwd("shiny-apps/nzfpg-explorer")

# __________________________________________________
#
# Read data in from the CSV files
# __________________________________________________

# Nice function to load up multiple files into one data frame
# From http://www.r-bloggers.com/merging-multiple-data-files-into-one-data-frame/
#      http://www.r-bloggers.com/author/tony-cookson/
multmerge = function(thepath, filter){
  filenames = list.files(path = thepath, filter, full.names = TRUE)
  datalist  = lapply(filenames, function(x) {read.csv(file = x, header = TRUE, stringsAsFactors = FALSE)})
  Reduce(function(x,y) {rbind(x, y)}, datalist)
}

generation  <- multmerge("data/downloads", "*Generation_MD.csv")
finalprices <- multmerge("data/downloads", "*Final_prices.csv")

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
  transmute(Trading_date   = as.POSIXct(Trading_date), 
            Trading_period = as.integer(substr(variable, 3, 4) ), 
            Node           = POC_Code, 
            kwh            = value, 
            Fuel_Code      = Fuel_Code)

finalprices <- finalprices %>%
  transmute(Trading_date   = as.POSIXct(Trading_date), 
            Trading_period = as.integer(Trading_period),
            Node           = Node,
            Price          = Price) 

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
nzfpg_config <- list("min_price"  = min(finalprices$Price),
                     "max_price"  = max(finalprices$Price),
                     "min_date"   = min(finalprices$Trading_date),
                     "max_date"   = max(finalprices$Trading_date),
                     "from_date"  = max_date - months(1),
                     "to_date"    = max_date,
                     "from_price" = min_price,
                     "to_price"   = quantile(finalprices$Price)[[3]])

saveRDS(nzfpg_config, file = "data/nzfpg_config.rds")

