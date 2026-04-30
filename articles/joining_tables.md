# Joining tables together

This vignette demonstrates how to join tables together using the `dplyr`
package. We will use the `bbgdata` and `treepositions` data frames from
the `bbggplots` package to show how to merge information about the
trees’ bloom statuses with their spatial positions in the garden.

``` r
library(bbggplots)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

Here, we can pull data for 2025-04-14, which is the date of peak bloom
for the cherry trees in that year. We will then join this data with the
`treepositions` data frame to get the spatial coordinates of each tree.

``` r
bbgdata |>
    filter(date == "2025-04-14") |>
    mutate(id = as.character(id)) |>
    left_join(treepositions, by = join_by(tree == tree, id == id))
#> # A tibble: 152 × 9
#>    date       alt                    tree  id    bloom id_full style   top  left
#>    <date>     <chr>                  <chr> <chr> <chr> <chr>   <chr> <dbl> <dbl>
#>  1 2025-04-14 Prunus ‘Taki-nioi’     taki… 163   Firs… taki_n… posi…  40.2  45.4
#>  2 2025-04-14 Prunus pendula ‘Pendu… pend… 128   Peak… pendul… posi…  19.3  72.4
#>  3 2025-04-14 Prunus pendula ‘Pendu… yae_… 126   Peak… yae_be… posi…  13.6  75.1
#>  4 2025-04-14 Prunus × sieboldii     sieb… 160   Firs… siebol… posi…  40.8  57.6
#>  5 2025-04-14 Prunus ‘Hata-zakura’   hata… 106   Firs… hataza… posi…  81.7  39.6
#>  6 2025-04-14 Prunus ‘Ariake’        aria… 154   Firs… ariake… posi…  20.5  59.8
#>  7 2025-04-14 Prunus ‘Ukon’          ukon  162   Preb… ukon_1… posi…  36.1  53.6
#>  8 2025-04-14 Prunus × sieboldii     sieb… 161   Firs… siebol… posi…  38.2  58.2
#>  9 2025-04-14 Prunus ‘Fudan-zakura’  fuda… 107   Post… fudan_… posi…  26.3  34.9
#> 10 2025-04-14 Prunus ‘Shirotae’      shir… 153   Firs… shirot… posi…  30.7  83.6
#> # ℹ 142 more rows
```

Note, each of the tree positions here, which are encoded in the `top`
and `left` columns, are in percentage coordinates corresponding to the
background image of the garden map. Moreover, `top` here maps to the
inverted y-axis (meaning positive values should be plotted with the
negative complement to visualize normally) and `left` maps to the
x-axis, which is a common convention for plotting images in R. This is
something to keep in mind when plotting the data later on.

``` r
sessionInfo()
#> R version 4.6.0 (2026-04-24)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.4 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
#> 
#> locale:
#>  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
#>  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
#>  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
#> [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
#> 
#> time zone: UTC
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] dplyr_1.2.1          bbggplots_0.0.0.9000
#> 
#> loaded via a namespace (and not attached):
#>  [1] vctrs_0.7.3        cli_3.6.6          knitr_1.51         rlang_1.2.0       
#>  [5] xfun_0.57          generics_0.1.4     S7_0.2.2           textshaping_1.0.5 
#>  [9] jsonlite_2.0.0     glue_1.8.1         htmltools_0.5.9    ragg_1.5.2        
#> [13] sass_0.4.10        scales_1.4.0       rmarkdown_2.31     grid_4.6.0        
#> [17] tibble_3.3.1       evaluate_1.0.5     jquerylib_0.1.4    fastmap_1.2.0     
#> [21] yaml_2.3.12        lifecycle_1.0.5    compiler_4.6.0     RColorBrewer_1.1-3
#> [25] fs_2.1.0           pkgconfig_2.0.3    farver_2.1.2       systemfonts_1.3.2 
#> [29] digest_0.6.39      R6_2.6.1           utf8_1.2.6         tidyselect_1.2.1  
#> [33] pillar_1.11.1      magrittr_2.0.5     bslib_0.10.0       tools_4.6.0       
#> [37] gtable_0.3.6       pkgdown_2.2.0      ggplot2_4.0.3      cachem_1.1.0      
#> [41] desc_1.4.3
```
