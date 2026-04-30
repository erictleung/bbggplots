# Plot garden map with bloom statuses

Recreate the garden map with bloom statuses for a given date. If no date
is provided, defaults to the most recent date in the data.

## Usage

``` r
plot_map(date)
```

## Arguments

- date:

  Date to plot. Defaults to the most recent date in the data.

## Value

A ggplot object.

## Examples

``` r
# Base example to plot the most recent date in the data
plot_map()


# Plot a specific date with data
plot_map("2025-04-14")


if (FALSE) { # \dontrun{
# This will throw an error since the date is not in the data
plot_map("2025-01-01")
} # }
```
