# Code to pull archival website snapshots from The Internet Archive
# https://archive.org

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
library(here)
library(lubridate)


# Read current records -----

url <- "https://web.archive.org/web/20160317064133/https://www.bbg.org/collections/cherries"
archived_date <- "2016-03-16"
year <- year(archived_date)

# Read in records so far
message("Reading in records so far.")
archived_file <- here("data-raw", glue("bbg_tree_bloom_{year}.csv"))
if (file.exists(archived_file)) {
  records <- read_csv(archived_file)
} else {
  message("No records found!")
}

print(date <- Sys.Date())


# Webpages ----
# https://web.archive.org/web/20240513105238/https://www.bbg.org/collections/cherries

# Scrape website ----

# Get archived webpages and let JavaScript code load elements
flowers <- read_html_live(url)

message(glue("Current date: {date}"))
message(glue(
  "{html_text(html_elements(flowers, 'figcaption'))} <- Should be same"
))

# Parse results ----
message("Get all annotated trees and form them into a nice data frame")
# Inspiration: https://stackoverflow.com/a/34513555/2468369
df_flowers <-
  flowers %>%
  # html_nodes("span.location") %>%
  html_element("div#cherrymap") |>
  html_elements("a") |>
  map(html_attrs) %>%
  map_df(~ as.list(.))

# Pre-process data
message("Wrangling bloom data...")
bloom_lvls <- c("Prebloom", "First Bloom", "Peak Bloom", "Post-Peak Bloom")
new_records <-
  df_flowers %>%
  separate_wider_delim(
    cols = class,
    delim = " ",
    # names = c("tree", "location", "bloom", "tooltip")
    names = c("tree", "location", "bloom")
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
    patterns = c(tree = "^[a-z_]*_", id = "[0-9]*$")
  ) %>%
  mutate(
    tree = str_remove(tree, pattern = regex("_$")),
    date = archived_date,
    id = as.integer(id),
    bloom = bloom %>% fct_expand(bloom_lvls) %>% fct_relevel(bloom_lvls),
  ) %>%
  select(tree, id, bloom, date)
message("Done!")


# Augment live data to archived data ----

# Pull in data from live feed to help augment archived data
live_file <- here("data-raw", glue("bbg_tree_bloom_2026.csv"))
if (file.exists(live_file)) {
  message("Previous records found!")
  live_records <- read_csv(live_file)
} else {
  message("No records found!")
}
live_trees <-
  live_records |>
  select(alt, tree, id) |>
  distinct()

# Add metadata to trees
message("Adding metadata to flower data and rearranging columns...")
new_records <-
  new_records |>
  mutate(id = as.character(id)) |>
  left_join(live_trees, by = join_by(tree, id)) |>
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


# Add to running record ----

# Add to existing data if there exists a file
if (exists("records")) {
  records <- bind_rows(records |> mutate(id = as.character(id)), new_records)
} else {
  records <- new_records
}
message("Unique dates now:")
print(glue("{unique(records$date)}"))
message(glue("Current date: {date} <-- Should be last date"))


# Write out results ----

write_csv(x = records, file = archived_file)
