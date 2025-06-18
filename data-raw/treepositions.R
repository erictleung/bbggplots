# Code to scrape the Brooklyn Botanical Garden's website and track tree bloom
# https://www.bbg.org/collections/cherries

# NOTE: this script only needs to be run once

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
library(here) # CRAN v1.0.1


# Scrape website ----
# Get live webpage and let JavaScript code load elements
flowers <- read_html_live("https://www.bbg.org/collections/cherries")

# Get positions of trees in the Brooklyn Botanical Garden ----
# Only needs to be run once

flower_pos <-
  flowers %>%
  html_nodes("div") %>%
  map(html_attrs) %>%
  map_df(~ as.list(.))

treepositions <-
  flower_pos %>%
  filter(!is.na(id), !is.na(style), is.na(class)) %>%
  rename(id_full = id) %>%
  mutate(
    top = str_extract(style, "top: ([0-9.]+)%;", group = 1),
    left = str_extract(style, "left: ([0-9.]+)%;", group = 1),
    tree = str_extract(id_full, "^[a-z_]+[a-z]"),
    id = str_extract(id_full, "[0-9]+$")
  ) %>%
  select(id_full, tree, id, style, top, left)


# Write out information ----

write_csv(treepositions, file = here("data-raw/bbg_flower_positions.csv"))

usethis::use_data(treepositions, overwrite = TRUE)
