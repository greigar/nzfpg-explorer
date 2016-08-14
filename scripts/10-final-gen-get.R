library(lubridate) # for date arithmetic
library(magrittr)  # for piping %>%

month_range <- 0:11                  # range of months to download
year_ago    <- Sys.Date() - years(1) # start from date

old_dir  <- getwd()
data_dir <- "~/data/electricity/downloads"
dir.create(data_dir, recursive=TRUE, showWarnings=FALSE)
setwd(data_dir)

base_url <- "http://www.emi.ea.govt.nz/Datasets/Wholesale/"
urls <- c(paste0(base_url, "Final_pricing/Final_prices/<month>_Final_prices.csv"),
          paste0(base_url, "Generation/Generation_MD/<month>_Generation_MD.csv"))

download <- function(download_period, url_type) {
  month_year   <- format(year_ago + months(download_period), "%Y%m")
  csv_data_url <- sub("<month>", month_year, url_type)
  file_name    <- basename(csv_data_url)

  download.file(csv_data_url, file_name)
}

lapply(urls, function(url)
               lapply(month_range, function(download_period) download(download_period, url)))

setwd(old_dir)
