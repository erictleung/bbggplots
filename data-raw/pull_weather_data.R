library(rjson)
library(stringr)

url <- "https://archive-api.open-meteo.com/v1/archive?"
coordinates <- "latitude=40.669247&longitude=-73.964357"
start <- "&start_date=2026-03-17"
end <- "&end_date=2026-03-31"
metrics <- "&daily=temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset,daylight_duration,sunshine_duration,rain_sum,showers_sum,snowfall_sum,precipitation_sum,wind_speed_10m_max,wind_gusts_10m_max,wind_direction_10m_dominant"
units <- "&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch"
tz <- "&timezone=America%2FNew_York"

json_file <- str_c(
  url,
  coordinates,
  start,
  end,
  metrics,
  units,
  tz
)

json_data <-
  json_file |>
  readLines() |>
  paste(collapse = "") |>
  fromJSON()

as.data.frame(json_data$daily)
