library(lubridate) # for date arithmetic
library(magrittr)  # for piping %>%

# setwd("shiny-apps/nzfpg-explorer")
dir.create("data/downloads", recursive=TRUE, showWarnings=FALSE)
setwd("data")

base_url <- "http://www.emi.ea.govt.nz/Datasets/download?directory=%2FDatasets%2FWholesale%2F"
url_fp   <- paste0(base_url, "Final_pricing%2FFinal_prices%2F")
url_gen  <- paste0(base_url, "Generation%2FGeneration_MD%2F")

year_ago <- Sys.Date() - years(1)

read_write <- function(url, file_name) {
  csv_data_url <- paste0(url,  file_name)
  print(file_name)
  read.csv(csv_data_url, stringsAsFactors = FALSE) %>% write.csv(paste0("downloads/",file_name), row.names = FALSE, quote = FALSE)
}

for(ix in 0:11) {
  month_year <- format(year_ago + months(ix), "%Y%m")

  file_name_fp  <- paste0(month_year, "_Final_prices.csv") 
  file_name_gen <- paste0(month_year, "_Generation_MD.csv") 

  read_write(url_fp,  file_name_fp)
  read_write(url_gen, file_name_gen)
}

# setwd("../../..")
