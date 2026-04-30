#' Plot garden map with bloom statuses
#'
#' Recreate the garden map with bloom statuses for a given date. If no date is
#' provided, defaults to the most recent date in the data.
#'
#' @param date Date to plot. Defaults to the most recent date in the data.
#'
#' @return A ggplot object.
#'
#' @importFrom rlang .data
#'
#' @examples
#' plot_map()
#' plot_map("2025-04-14")  # Plot a specific date with data
#' plot_map("2025-01-01")  # This will throw an error since the date is not in the data
#' @export
plot_map <- function(date) {
  if (missing(date)) {
    date <- max(bbggplots::bbgdata$date)
  } else if (!date %in% bbggplots::bbgdata$date) {
    all_dates <-
      bbgdata$date |>
      unique() |>
      as.Date()

    diff_dates <- all_dates - as.Date({{ date }})

    closest_suggestion <- all_dates[which(
      abs(diff_dates) == min(abs(diff_dates))
    )]

    stop(
      "Try another date like ",
      closest_suggestion,
      " or use plot_map() to plot the most recent date."
    )
  }

  # Get SVGs and background image
  firstbloom_svg <-
    system.file("extdata", "cherry-firstbloom.svg", package = "bbggplots") |>
    readLines(warn = FALSE) |>
    paste(collapse = "\n")
  peakbloom_svg <-
    system.file("extdata", "cherry-peakbloom.svg", package = "bbggplots") |>
    readLines(warn = FALSE) |>
    paste(collapse = "\n")
  postbloom_svg <-
    system.file("extdata", "cherry-postbloom.svg", package = "bbggplots") |>
    readLines(warn = FALSE) |>
    paste(collapse = "\n")
  prebloom_svg <-
    system.file("extdata", "cherry-prebloom.svg", package = "bbggplots") |>
    readLines(warn = FALSE) |>
    paste(collapse = "\n")
  bg <-
    system.file("extdata", "cherrymap.png", package = "bbggplots") |>
    png::readPNG()

  # Create icons dataframe
  icons_df <- data.frame(
    bloom = c('Prebloom', 'First Bloom', 'Peak Bloom', 'Post-Peak Bloom'),
    svg = c(prebloom_svg, firstbloom_svg, peakbloom_svg, postbloom_svg),
    stringsAsFactors = FALSE
  )

  # Set up parameters for plotting
  p_size <- 5
  bg_dim <- dim(bg)

  # Plot the garden map!
  bbggplots::bbgdata |>
    dplyr::filter(date == {{ date }}) |>
    dplyr::mutate(id = as.character(.data$id)) |>
    dplyr::left_join(
      bbggplots::treepositions,
      by = c("tree", "id")
    ) |>
    dplyr::mutate(
      x = (.data$left / 100 * bg_dim[2]) + p_size,
      y = (-.data$top / 100 * bg_dim[1]) - p_size
    ) |>
    merge(icons_df) |>
    ggplot2::ggplot() +
    ggpubr::background_image(bg) +
    ggsvg::geom_point_svg(
      aes(x = .data$x, y = .data$y, svg = I(.data$svg)),
      size = p_size
    ) +
    ggplot2::scale_x_continuous(
      expand = c(0, 0),
      limits = c(0, 550)
    ) +
    ggplot2::scale_y_continuous(
      expand = c(0, 0),
      limits = c(0, -498)
    ) +
    # Maintain 1:1 ratio and allow drawing outside limits
    ggplot2::coord_fixed(clip = "off") +
    ggplot2::theme(
      axis.title.x = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank()
    )
}
