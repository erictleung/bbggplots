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

# Keep a log of all the archived pages for reference
urls <- list(
  list(
    date = "2016-03-16",
    url = "https://web.archive.org/web/20160317064133/https://www.bbg.org/collections/cherries"
  ),
  list(
    date = "2016-03-18",
    url = "https://web.archive.org/web/20160319000709/https://www.bbg.org/collections/cherries"
  ),
  list(
    date = "2016-03-24",
    url = "https://web.archive.org/web/20160324145416/https://www.bbg.org/collections/cherries"
  ),
  list(
    date = "2016-03-26",
    url = "https://web.archive.org/web/20160328084212/https://www.bbg.org/collections/cherries"
  ),
  list(
    date = "2016-03-29",
    url = "https://web.archive.org/web/20160330054149/https://www.bbg.org/collections/cherries"
  ),
  list(
    date = "2016-03-31",
    url = "https://web.archive.org/web/20160331180404/https://www.bbg.org/collections/cherries"
  ),
  list(
    date = "2016-04-01",
    url = "https://web.archive.org/web/20160403200531/https://www.bbg.org/collections/cherries"
  ),
  list(
    date = "2016-04-08",
    url = "https://web.archive.org/web/20160408190954/https://www.bbg.org/collections/cherries"
  ),
  list(
    date = "2016-04-12",
    url = "https://web.archive.org/web/20160413034235/https://www.bbg.org/collections/cherries"
  ),
  list(
    date = "2016-04-15",
    url = "https://web.archive.org/web/20160418110550/https://www.bbg.org/collections/cherries"
  )
)

# Look at latest archived link above
archived_date <- urls[[length(urls)]]$date
url <- urls[[length(urls)]]$url
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


# Scrape website ----

# Get archived webpages and let JavaScript code load elements
# b <- ChromoteSession$new()
# b$go_to(url)
flowers <- read_html_live(url)
message(glue(
  # "{html_text(html_elements(flowers, 'figcaption'))}"
  '{flowers |> html_elements("footnote") |> html_text() |> stringr::str_trim()}'
))
message(glue("^Should match the date of the archived page: {archived_date}"))

# Parse results ----
message("Get all annotated trees and form them into a nice data frame")
# Inspiration: https://stackoverflow.com/a/34513555/2468369
df_flowers <-
  flowers |>
  # html_nodes("span.location") |>
  html_element("div#cherrymap") |>
  # html_elements("a") |>
  html_elements("span") |>
  map(html_attrs) |>
  map_df(~ as.list(.))
message("Taking a peak of the data pulled so far...")
print(df_flowers)

# Pre-process data
message("Wrangling bloom data...")
bloom_lvls <- c("Prebloom", "First Bloom", "Peak Bloom", "Post-Peak Bloom")
new_records <-
  df_flowers %>%
  separate_wider_delim(
    cols = class,
    delim = " ",
    names = c("tree", "location", "bloom", "tooltip")
    # names = c("tree", "location", "bloom")
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
print(new_records)
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
print(live_trees)

# Add metadata to trees
message("Adding metadata to flower data and rearranging columns...")
new_records <-
  new_records |>
  mutate(
    id = as.character(id),
    date = as.Date(date),
    bloom = as.character(bloom)
  ) |>
  left_join(live_trees, by = join_by(tree, id)) |>
  select(date, alt, tree, id, bloom)
print(new_records)
message("Done!")


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
    select(date, prebloom, first_bloom, peak_bloom, post_peak_bloom)
)


# Write out results ----

write_csv(x = records, file = archived_file)
