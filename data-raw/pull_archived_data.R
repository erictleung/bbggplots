# Code to pull archival website snapshots from The Internet Archive
# https://archive.org

# Setup ----

# Data wrangling
library(dplyr) # A Grammar of Data Manipulation CRAN v1.1.4
library(tidyr) # Tidy Messy Data CRAN v1.3.1
library(stringr) # Simple, Consistent Wrappers for Common String Operations CRAN v1.5.1

# Utils
library(purrr) # Functional Programming Tools CRAN v1.0.2
library(readr) # Read Rectangular Text Data CRAN v2.1.5
library(forcats) # Tools for Working with Categorical Variables (Factors) CRAN v1.0.0
library(glue) # Interpreted String Literals CRAN v1.7.0
library(here)
library(lubridate)


# Read current records -----

# Keep a log of all the archived pages for reference
urls <-
  "data-raw/archive.json" |>
  readLines() |>
  fromJSON() |>
  as.data.frame()

# Look at latest archived link above
archived_date <- last(urls)$date
year <- year(archived_date)

print(glue("Looking at {archived_date} and adding to {year} data"))

# Read in records so far
message(glue("Reading in records so far for {year}..."))
archived_file <- here("data-raw", glue("bbg_tree_bloom_{year}.csv"))
if (file.exists(archived_file)) {
  message("Data found!")
  records <- read_csv(
    archived_file,
    col_types = list(
      date = col_date(),
      alt = col_character(),
      tree = col_character(),
      id = col_character(),
      bloom = col_character()
    )
  )
  print(records)
} else {
  message("No records found!")
}

# Parse results ----
message("Get all annotated trees and form them into a nice data frame")
in_file <- here("data-raw", glue("cherries_{archived_date}.json"))
if (file.exists(in_file)) {
  df_flowers <-
    in_file |>
    read_json(simplifyVector = TRUE) |>
    as.data.frame()
  colnames(df_flowers) <- c(
    "id",
    "tree_name_html",
    "alt",
    "tree",
    "tree_id",
    "x",
    "y",
    "bloom",
    "tooltip_img",
    "full_image"
  )
  message("Taking a peak of the data pulled so far...")
  print(df_flowers)
} else {
  message("No records found!")
}

# Pre-process data
message("Wrangling bloom data...")
new_records <-
  df_flowers |>
  mutate(
    date = as.Date(archived_date),
    id = as.character(id),
    bloom = bloom |> fct_expand(bloom_lvls) |> fct_relevel(bloom_lvls),
  ) |>
  mutate(alt = str_remove_all(alt, "<em>")) |>
  mutate(alt = str_remove_all(alt, "</em>")) |>
  mutate(alt = str_replace(alt, "&#215;", "×")) |>
  select(date, alt, tree, id, bloom)
print(new_records)
message("Done!")

message("Checking any missing metadata...")
new_records |>
  filter(is.na(alt) | is.na(tree) | is.na(id)) |>
  print()


# Get all the data to see over time ----

# Basic checks before joining
dim(new_records) # Should be 152 (sometimes 151)
if (exists("records")) {
  message("Checking existing records...")
  print(dim(records))
  print(unique(records$date)) # Check that it should be days up until yesterday
  print(records %>% count(alt, tree, id) %>% count(n)) # Check counts for days
}


# Add to running record ----

# Add to existing data if there exists a file
if (exists("records")) {
  records <- bind_rows(records |> mutate(id = as.character(id)), new_records)
} else {
  records <- new_records
}
message("Unique dates now:")
print(glue("{unique(records$date)}"))
message("Check on changes in bloom status...")
print(
  records |>
    group_by(date, bloom) |>
    count() |>
    pivot_wider(id_cols = date, values_from = n, names_from = bloom) |>
    janitor::clean_names() |>
    mutate(total = rowSums(across(where(is.numeric)), na.rm = TRUE)) |>
    select(date, prebloom, first_bloom, peak_bloom, post_peak_bloom, total)
)


# Write out results ----

write_csv(x = records, file = archived_file)

file.remove(here("data-raw", glue("cherries_{archived_date}.json")))
