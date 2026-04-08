# Pull live data from the Brooklyn Botanical Garden
# Rscript combined_and_save.R
# https://www.bbg.org/collections/cherries

# Setup ----

# Data wrangling
library(dplyr) # A Grammar of Data Manipulation CRAN v1.1.4

# Utils
library(readr) # Read Rectangular Text Data CRAN v2.1.5
library(here) # A Simpler Way to Find Your Files CRAN v1.0.1
library(stringr)
library(purrr)
library(lubridate)


# Read data ----

# Read all data all at once
bbgdata <- here("data-raw") |>
  list.files(pattern = "bbg_tree_bloom") |>
  # map_chr(\(x) str_c("data-raw/", x)) |>
  map(
    read_csv,
    col_types = list(
      date = col_date(),
      alt = col_character(),
      tree = col_character(),
      id = col_character(),
      bloom = col_character()
    )
  ) |>
  list_rbind()

# Checks
unique(bbgdata$date)
dim(bbgdata)
bbgdata |>
  mutate(year = year(date)) |>
  count(year) |>
  arrange(year)

# Save out data ----

usethis::use_data(bbgdata, overwrite = TRUE)
