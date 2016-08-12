library(lubridate) # for date arithmetic
library(magrittr)  # for piping %>%
library(readr)     # for reading csv

old_dir  <- getwd()
data_dir <- "~/data/electricity/downloads"
dir.create(data_dir, recursive=TRUE, showWarnings=FALSE)
setwd(data_dir)

base_url <- "http://www.emi.ea.govt.nz/Datasets/Wholesale/"
url_fp   <- paste0(base_url, "Final_pricing/Final_prices/")
url_gen  <- paste0(base_url, "Generation/Generation_MD/")

year_ago <- Sys.Date() - years(2) + months(5)

read_write <- function(url, file_name) {
  csv_data_url <- paste0(url,  file_name)
  print(csv_data_url)
  read.csv(csv_data_url, stringsAsFactors = FALSE) %>%
    write.csv(file_name, row.names = FALSE, quote = FALSE)
}

for(ix in 0:11) {
  month_year <- format(year_ago + months(ix), "%Y%m")

  file_name_fp  <- paste0(month_year, "_Final_prices.csv") 
  file_name_gen <- paste0(month_year, "_Generation_MD.csv") 

  read_write(url_fp,  file_name_fp)
  read_write(url_gen, file_name_gen)
}

setwd(old_dir)
