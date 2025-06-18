# Pull live data from the Brooklyn Botanical Garden
# https://www.bbg.org/collections/cherries


# Setup ----

# Data wrangling
library(dplyr) # A Grammar of Data Manipulation CRAN v1.1.4

# Utils
library(readr) # Read Rectangular Text Data CRAN v2.1.5
library(here) # A Simpler Way to Find Your Files CRAN v1.0.1


# Read data ----

records <- read_csv(here("data-raw/bbg_tree_bloom_2025.csv"))


# Save out data ----

bbgdata <- records

usethis::use_data(bbgdata, overwrite = TRUE)
