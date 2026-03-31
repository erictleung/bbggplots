# Cherry Blossom Blooming Status Color Palette

Color palette used on the official Brooklyn Botanic Gardens website
tracker.

## Usage

``` r
bbgcolors(name)
```

## Source

<https://www.bbg.org/collections/cherries>

## Arguments

- name:

  string for what color information to gather

## Details

Values can be any of the following:

- all:

  "all"

- Pre-bloom:

  "bloom0", "pre", "prebloom"

- First bloom:

  "bloom1", "first", "first_bloom"

- Peak bloom:

  "bloom2", "peak", "peak_bloom"

- Post-peak bloom:

  "bloom3", "post", "postpeak_bloom"

## Examples

``` r
bbgcolors("all")


require(ggplot2)
#> Loading required package: ggplot2
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
    geom_point(color = bbgcolors("first"))
```
