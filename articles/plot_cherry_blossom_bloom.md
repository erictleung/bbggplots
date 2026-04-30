# Plot cherry blossom bloom statuses

``` r
library(bbggplots)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(ggplot2)
library(ggsvg)
library(ggpubr)
```

``` r
firstbloom_svg <-
    system.file("extdata", "cherry-firstbloom.svg", package="bbggplots") |>
    readLines(warn = FALSE) |>
    paste(collapse = "\n")
peakbloom_svg <-
    system.file("extdata", "cherry-peakbloom.svg", package="bbggplots") |>
    readLines(warn = FALSE) |>
    paste(collapse = "\n")
postbloom_svg <-
    system.file("extdata", "cherry-postbloom.svg", package="bbggplots") |>
    readLines(warn = FALSE) |>
    paste(collapse = "\n")
prebloom_svg <-
    system.file("extdata", "cherry-prebloom.svg", package="bbggplots") |>
    readLines(warn = FALSE) |>
    paste(collapse = "\n")
bg <-
    system.file("extdata", "cherrymap.png", package="bbggplots") |>
    png::readPNG()
```

``` r
icons_df <- data.frame(
  bloom = c('Prebloom', 'First Bloom', 'Peak Bloom', 'Post Bloom'),
  svg  = c( prebloom_svg, firstbloom_svg, peakbloom_svg, postbloom_svg),
  stringsAsFactors = FALSE
)
```

``` r
p_size <- 5
bg_dim <- dim(bg)
bbgdata |>
    filter(date == "2025-04-14") |>
    mutate(id = as.character(id)) |>
    left_join(treepositions, by = join_by(tree == tree, id == id)) |>
    mutate(
        x = (left / 100 * bg_dim[2]) + p_size,
        y = (-top / 100 * bg_dim[1]) - p_size
    ) |>
    merge(icons_df) |>
    ggplot() +
    background_image(bg) +
    geom_point_svg(
        aes(x = x, y = y, svg = I(svg)),
        size = p_size
    ) + 
    scale_x_continuous(
        expand = c(0, 0),
        limits = c(0, 550)
    ) +
    scale_y_continuous(
        expand = c(0, 0),
        limits = c(0, -498)
    ) +
    # Maintain 1:1 ratio and allow drawing outside limits
    coord_fixed(clip = "off") +
    theme_minimal()
```

![](plot_cherry_blossom_bloom_files/figure-html/unnamed-chunk-4-1.png)
