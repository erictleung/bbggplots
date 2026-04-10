# Pull live data from the Brooklyn Botanical Garden
# Usage: Rscript pull_live_data.R
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
message("Looking for: ", data_file)
if (file.exists(data_file)) {
  message("Previous records found!")
  records <- read_csv(data_file)
} else {
  message("No records found!")
}

# Scrape website ----

# Get live webpage and let JavaScript code load elements
message("Reading HTML from Brooklyn Botanic Garden's website...")
flowers <- read_html_live("https://www.bbg.org/collections/cherries")
Sys.sleep(3)
message("Completed!")

message(glue("Current date: {date}"))
message(glue(
  "{html_text(html_elements(flowers, 'figcaption'))} <- Should be same"
))


# Parse results ----

message("Getting all annotated trees and form them into a nice data frame...")
# Inspiration: https://stackoverflow.com/a/34513555/2468369
df_flowers <-
  flowers %>%
  html_nodes("span.location") %>%
  map(html_attrs) %>%
  map_df(~ as.list(.))
message("Done!")

# Get metadata and names for trees
message("Getting flowers metadata...")
df_flowers_meta <-
  flowers %>%
  html_elements("div.tooltip-content") %>%
  map(\(x) {
    data.frame(
      # Grab alt name
      alt = x %>%
        html_element("h4") %>%
        html_text2(),

      # Grab unique identifier
      tree = x %>%
        html_attr("id") %>%
        stringr::str_remove("_[0-9]+-tooltip"),

      # Grab unique identifier
      id = x %>%
        html_attr("id") %>%
        stringr::str_extract("[0-9]+") %>%
        as.integer()
    )
  }) %>%
  list_rbind()
message("Done!")

# Pre-process data
message("Wrangling bloom data...")
bloom_lvls <- c("Prebloom", "First Bloom", "Peak Bloom", "Post-Peak Bloom")
new_records <-
  df_flowers %>%
  separate_wider_delim(
    cols = class,
    delim = " ",
    names = c("tree", "location", "bloom", "tooltip")
  ) %>%
  mutate(
    bloom = case_when(
      bloom == "bloom0" ~ "Prebloom",
      bloom == "bloom1" ~ "First Bloom",
      bloom == "bloom2" ~ "Peak Bloom",
      bloom == "bloom3" ~ "Post-Peak Bloom",
      TRUE ~ "N/A"
    )
  ) %>%
  separate_wider_regex(
    cols = tree,
    patterns = c(tree = "^[a-z_]*_", id = "[0-9-]*$")
  ) %>%
  mutate(
    tree = str_remove(tree, pattern = regex("_$")),
    date = date,
    id = as.character(id),
    bloom = bloom %>% fct_expand(bloom_lvls) %>% fct_relevel(bloom_lvls),
  ) %>%
  select(tree, id, bloom, date)
message("Done!")

# Adds metadata to trees
message("Adding metadata to flower data and rearranging columns...")
new_records <-
  new_records %>%
  left_join(
    df_flowers_meta |> mutate(id = as.character(id)),
    by = join_by(tree, id)
  ) %>%
  select(date, alt, tree, id, bloom)
message("Done!")

# Get all the data to see over time ----

# Basic checks before joining
dim(new_records) # Should be 152 (sometimes 151)
if (exists("records")) {
  print(dim(records))
  print(unique(records$date)) # Check that it should be days up until yesterday
  print(records %>% count(alt, tree, id) %>% count(n)) # Check counts for days
}

# Add to existing data if there exists a file
if (exists("records")) {
  records <- bind_rows(records |> mutate(id = as.character(id)), new_records)
} else {
  records <- new_records
}
message("Unique dates now:")
print(glue("{unique(records$date)}"))
message(glue("Current date: {date} <-- Should be last date"))


# TEMP ----

# Add in tree information for new tree
records <-
  records |>
  mutate(
    alt = if_else(
      id == "81-2026",
      "Prunus pendula ‘Pendula plena rosea’",
      alt
    )
  )


# Write out results ----

write_csv(x = records, file = data_file)
