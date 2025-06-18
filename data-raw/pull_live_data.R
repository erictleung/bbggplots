# Pull live data from the Brooklyn Botanical Garden
# https://www.bbg.org/collections/cherries


# Setup ----

# Web
library(rvest) # Easily Harvest (Scrape) Web Pages CRAN v1.0.4
library(chromote) # Headless Chrome Web Browser Interface CRAN v0.5.0

# Data wrangling
library(dplyr) # A Grammar of Data Manipulation CRAN v1.1.4
library(tidyr) # Tidy Messy Data CRAN v1.3.1
library(stringr) # Simple, Consistent Wrappers for Common String Operations CRAN v1.5.1

# Utils
library(purrr) # Functional Programming Tools CRAN v1.0.2
library(readr) # Read Rectangular Text Data CRAN v2.1.5
library(forcats) # Tools for Working with Categorical Variables (Factors) CRAN v1.0.0
library(glue) # Interpreted String Literals CRAN v1.7.0
library(here) # A Simpler Way to Find Your Files CRAN v1.0.1

# Variables
date <- Sys.Date()
year <- format(date, "%Y")
data_file <- here("data-raw", glue("bbg_tree_bloom_{year}.csv"))


# Read current records -----

# Read in records so far
message("Reading in records so far.")
if (file.exists(data_file)) {
  records <- read_csv(data_file)
}


# Scrape website ----

# Get live webpage and let JavaScript code load elements
flowers <- read_html_live("https://www.bbg.org/collections/cherries")

message(glue("Current date: {date}"))
message(glue("{html_text(html_elements(flowers, 'figcaption'))} <- Should be same"))


# Parse results ----

message("Get all annotated trees and form them into a nice data frame")
# Inspiration: https://stackoverflow.com/a/34513555/2468369
df_flowers <-
  flowers %>%
  html_nodes("span.location") %>%
  map(html_attrs) %>%
  map_df(~ as.list(.))

# Pre-process data
bloom_lvls <- c("Prebloom", "First Bloom", "Peak Bloom", "Post-Peak Bloom")
new_records <-
  df_flowers %>%
  separate_wider_delim(
    cols = class,
    delim = " ",
    names = c("tree", "location", "bloom", "tooltip")
  ) %>%
  mutate(bloom = case_when(
    bloom == "bloom0" ~ "Prebloom",
    bloom == "bloom1" ~ "First Bloom",
    bloom == "bloom2" ~ "Peak Bloom",
    bloom == "bloom3" ~ "Post-Peak Bloom",
    TRUE ~ "N/A"
  )) %>%
  separate_wider_regex(
    cols = tree,
    patterns = c(tree = "^[a-z_]*_", id = "[0-9]*$")
  ) %>%
  mutate(
    tree = str_remove(tree, pattern = regex("_$")),
    date = date,
    id = as.integer(id),
    bloom = bloom %>% fct_expand(bloom_lvls) %>% fct_relevel(bloom_lvls),
  ) %>%
  select(tree, id, bloom, date)


# Get all the data to see over time ----

new_records <-
  new_records %>%
  select(date, tree, id, bloom) %>%
  left_join(records %>% distinct(alt, tree, id), by = join_by(tree, id)) %>%
  select(date, alt, tree, id, bloom)

# Basic checks before joining
dim(new_records) # Should be 152 (sometimes 151)
dim(records)
unique(records$date) # Check that it should be days up until yesterday
records %>% count(alt, tree, id) %>% count(n) # Check counts for days

# Add to existing data if there exists a file
if (exists("records")) {
  records <- bind_rows(records, new_records)
} else {
  records <- new_records
}
message("Unique dates now:")
print(glue("{unique(records$date)}"))
message(glue("Current date: {date} <-- Should be last date"))


# Write out results ----

write_csv(x = records, file = data_file)

usethis::use_data(records, overwrite = TRUE)
