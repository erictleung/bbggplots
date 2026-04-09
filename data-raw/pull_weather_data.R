# Load libraries -----
library(rjson)
library(stringr)
library(glue)

# STRING WORKS
# https://archive-api.open-meteo.com/v1/archive?latitude=40.669247&longitude=-73.964357&start_date=2026-03-17&end_date=2026-03-31&daily=temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset,daylight_duration,sunshine_duration,uv_index_max,rain_sum,showers_sum,uv_index_clear_sky_max,snowfall_sum,precipitation_sum,wind_speed_10m_max,wind_gusts_10m_max,wind_direction_10m_dominant&timezone=America/New_York&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch

# Setup ----
url <- "https://archive-api.open-meteo.com/v1/archive?"
coordinates <- "latitude=40.669247&longitude=-73.964357"
start_tmp <- "&start_date="
end_tmp <- "&end_date="
metrics <- "&daily=temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset,daylight_duration,sunshine_duration,rain_sum,showers_sum,snowfall_sum,precipitation_sum,wind_speed_10m_max,wind_gusts_10m_max,wind_direction_10m_dominant"
units <- "&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch"
tz <- "&timezone=America//New_York"

# UPDATE Read in data to pull dates for
year <- 2016
data_file <- here("data-raw", glue("bbg_tree_bloom_{year}.csv"))
records_of_interest <-
  data_file |>
  read_csv(col_select = "date") |>
  unique() |>
  pull()

# Add in data
start <- str_c(start_tmp, records_of_interest[1])
end <- str_c(end_tmp, records_of_interest[length(records_of_interest)])

# Join URL together
json_file <- str_c(
  url,
  coordinates,
  start,
  end,
  metrics,
  tz,
  units
)

# PICK UP HERE
# https://rguides.dev/guides/r-http-requests-httr/
request("https://httpbin.org/get") |>
  req_url_query(name = "Alice", age = 30) |>
  req_perform() |>
  resp_body_json()

# Pull in data and format into a data frame
json_data <-
  json_file |>
  readLines() |>
  paste(collapse = "") |>
  fromJSON()

# Convert daily data into a data frame
bbg_weather_data <- as.data.frame(json_data$daily)


# Save out data ----

write_csv(
  x = bbg_weather_data,
  file = here("data-raw", glue("bbg_weather_data_{year}.csv"))
)
usethis::use_data(bbg_weather_data, overwrite = TRUE)
