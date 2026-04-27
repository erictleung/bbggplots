# Tree Positions

Coordinates to help visualize where each tree is in the gardens.

## Usage

``` r
treepositions
```

## Format

A data frame with 151 rows and 6 variables:

- id_full:

  unique ID of the tree

- tree:

  tree species

- id:

  ID number of tree

- style:

  CSS position styling information

- top:

  number for percent from top

- left:

  number for percent from left

## Source

<https://www.bbg.org/collections/cherries>

## Examples

``` r
treepositions
#> # A tibble: 153 × 6
#>    id_full              tree             id      style                 top  left
#>    <chr>                <chr>            <chr>   <chr>               <dbl> <dbl>
#>  1 pendula_82           pendula          82      position: absolute…  21.5  3.27
#>  2 pendula_78           pendula          78      position: absolute…  21.5  0   
#>  3 ukon_162             ukon             162     position: absolute…  36.1 53.6 
#>  4 ukon_155             ukon             155     position: absolute…   1.2 81.1 
#>  5 taki_nioi_163        taki_nioi        163     position: absolute…  40.2 45.4 
#>  6 pendula_81           pendula          81      position: absolute…  21.5 30.6 
#>  7 pendula_81-2026      pendula          81-2026 position: absolute…  21.5 30.6 
#>  8 shogetsu_140         shogetsu         140     position: absolute…  80.3 69.4 
#>  9 sieboldii_161        sieboldii        161     position: absolute…  38.2 58.2 
#> 10 yae_beni_shidare_126 yae_beni_shidare 126     position: absolute…  13.6 75.1 
#> # ℹ 143 more rows
```
