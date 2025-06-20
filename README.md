
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bbggplots

<!-- badges: start -->

[![R Build
Status](https://github.com/erictleung/bbggplots/actions/workflows/R-CMD-check.yml/badge.svg)](https://github.com/erictleung/bbggplots/actions/workflows/R-CMD-check.yml)
[![License
CC0](https://img.shields.io/cran/l/pixarfilms)](https://img.shields.io/cran/l/pixarfilms)
[![Project Type Toy
Badge](https://img.shields.io/badge/project%20type-toy-blue)](https://project-types.github.io/#toy)
<!-- badges: end -->

> R data package to explore the cheery blossoms at the Brooklyn Botanic
> Garden

## Installation

You can install the development version of `bbggplots` from GitHub with:

``` r
remotes::install_github("erictleung/bbggplots")
```

## Example

``` r
library(bbggplots)
bbgdata
#> # A tibble: 3,328 × 5
#>    date       alt                                  tree                id bloom 
#>    <date>     <chr>                                <chr>            <dbl> <chr> 
#>  1 2025-04-14 Prunus ‘Taki-nioi’                   taki_nioi          163 First…
#>  2 2025-04-14 Prunus pendula ‘Pendula Rosea ’      pendula            128 Peak …
#>  3 2025-04-14 Prunus pendula ‘Pendula Plena Rosea’ yae_beni_shidare   126 Peak …
#>  4 2025-04-14 Prunus × sieboldii                   sieboldii          160 First…
#>  5 2025-04-14 Prunus ‘Hata-zakura’                 hatazakura         106 First…
#>  6 2025-04-14 Prunus ‘Ariake’                      ariake             154 First…
#>  7 2025-04-14 Prunus ‘Ukon’                        ukon               162 Prebl…
#>  8 2025-04-14 Prunus × sieboldii                   sieboldii          161 First…
#>  9 2025-04-14 Prunus ‘Fudan-zakura’                fudan_zakura       107 Post-…
#> 10 2025-04-14 Prunus ‘Shirotae’                    shirotae           153 First…
#> # ℹ 3,318 more rows
```

## Documentation

You can find information about the data sets and more
[here](https://erictleung.com/bbggplots/). And , a list of vignettes
showcasing some analyses you can do with this package can be found
[here](https://erictleung.com/bbggplots/articles/).

## Data

This data here within is not constrained to exploring just within R.

Here are direct links to each data set.

    https://raw.githubusercontent.com/erictleung/bbggplots/main/data-raw/bbg_tree_bloom_2025.csv

## Feedback

If you have any feedback or suggestions on other data that can be added,
please file an issue
[here](https://github.com/erictleung/bbggplots/issues).

## Code of Conduct

Please note that the {bbggplots} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## Acknowledgments

- [Brooklyn Botanic Garden](https://bbg.org/)
