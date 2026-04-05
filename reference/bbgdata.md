# Brooklyn Botanic Gardens Cherry Blossom Status

A data set containing historical data for the Brooklyn Botanic Garden.

## Usage

``` r
bbgdata
```

## Format

A data frame with 27 rows and 3 variables:

- date:

  date of bloom status

- alt:

  full genus and species tree name

- tree:

  tree species

- id:

  unique integer ID

- bloom:

  one of four bloom states: "Prebloom", "First Bloom", "Peak Bloom",
  "Post-Peak Bloom"

## Source

<https://www.bbg.org/collections/cherries>

## Details

The data serves as an archive for the more visual map of the cherry
blossom trees that the official website shows.

## Examples

``` r
bbgdata
#> # A tibble: 4,387 × 5
#>    date       alt                                  tree             id    bloom 
#>    <date>     <chr>                                <chr>            <chr> <chr> 
#>  1 2025-04-14 Prunus ‘Taki-nioi’                   taki_nioi        163   First…
#>  2 2025-04-14 Prunus pendula ‘Pendula Rosea ’      pendula          128   Peak …
#>  3 2025-04-14 Prunus pendula ‘Pendula Plena Rosea’ yae_beni_shidare 126   Peak …
#>  4 2025-04-14 Prunus × sieboldii                   sieboldii        160   First…
#>  5 2025-04-14 Prunus ‘Hata-zakura’                 hatazakura       106   First…
#>  6 2025-04-14 Prunus ‘Ariake’                      ariake           154   First…
#>  7 2025-04-14 Prunus ‘Ukon’                        ukon             162   Prebl…
#>  8 2025-04-14 Prunus × sieboldii                   sieboldii        161   First…
#>  9 2025-04-14 Prunus ‘Fudan-zakura’                fudan_zakura     107   Post-…
#> 10 2025-04-14 Prunus ‘Shirotae’                    shirotae         153   First…
#> # ℹ 4,377 more rows
```
