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
plot_map()

plot_map(as.Date("2025-04-14"))
```
