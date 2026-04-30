# Brooklyn Botanic Gardens Cherry Blossom Status

A data set containing historical data for the Brooklyn Botanic Garden.

## Usage

``` r
bbgdata
```

## Format

A data frame with five column variables:

- date:

  date of bloom status

- alt:

  string of full genus and species tree name

- tree:

  string of tree species

- id:

  string of unique integer ID

- bloom:

  string of one of four bloom states: "Prebloom", "First Bloom", "Peak
  Bloom", "Post-Peak Bloom"

## Source

<https://www.bbg.org/collections/cherries>

## Details

The data serves as an archive for the more visual map of the cherry
blossom trees that the official website shows.

Note: data pulled from 2024 and earlier are retroactively pulled using a
snapshot from <https://archive.org>, so data is only available based on
whether someone saved the page (i.e., there can be missing data).

## Examples

``` r
bbgdata
#> # A tibble: 8,494 × 5
#>    date       alt                        tree              id    bloom   
#>    <date>     <chr>                      <chr>             <chr> <chr>   
#>  1 2016-03-16 Prunus ‘Kanzan’            kanzan            50    Prebloom
#>  2 2016-03-16 Prunus ‘Snow Goose’        prunus_snow_goose 147   Prebloom
#>  3 2016-03-16 Prunus × sieboldii         sieboldii         161   Prebloom
#>  4 2016-03-16 Prunus × sieboldii         sieboldii         160   Prebloom
#>  5 2016-03-16 Prunus × subhirtella       subhirtella       159   Prebloom
#>  6 2016-03-16 Prunus ‘Ukon’              ukon              158   Prebloom
#>  7 2016-03-16 Prunus serrulata ‘Horinji’ horinji           157   Prebloom
#>  8 2016-03-16 Prunus × yedoensis         yedoensis         156   Prebloom
#>  9 2016-03-16 Prunus ‘Ariake’            ariake            154   Prebloom
#> 10 2016-03-16 Prunus ‘Shirotae’          shirotae          153   Prebloom
#> # ℹ 8,484 more rows
```
