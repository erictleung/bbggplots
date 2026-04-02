# Pull live data from the Brooklyn Botanical Garden
# Rscript data-raw/combined_and_save.R
# https://www.bbg.org/collections/cherries

# Setup ----

# Data wrangling
library(dplyr) # A Grammar of Data Manipulation CRAN v1.1.4

# Utils
library(readr) # Read Rectangular Text Data CRAN v2.1.5
library(here) # A Simpler Way to Find Your Files CRAN v1.0.1
library(stringr)
library(purrr)


# Read data ----

# Read all data all at once
bbgdata <- here("data-raw") |>
  list.files(pattern = "bbg_tree_bloom") |>
  map_chr(\(x) str_c("data-raw/", x)) |>
  map_dfr(read_csv)

# Checks
unique(bbgdata$date)

# Save out data ----

usethis::use_data(bbgdata, overwrite = TRUE)
