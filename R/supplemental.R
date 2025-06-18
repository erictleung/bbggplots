#' @importFrom tibble tibble
NULL


#' Tree Positions
#'
#' Coordinates to help visualize where each tree is in the gardens.
#'
#' @format A data frame with 151 rows and 6 variables:
#' \describe{
#'   \item{id_full}{unique ID of the tree}
#'   \item{tree}{tree species}
#'   \item{id}{ID number of tree}
#'   \item{style}{CSS position styling information}
#'   \item{top}{number for percent from top}
#'   \item{left}{number for percent from left}
#' }
#' @source \url{https://www.bbg.org/collections/cherries}
#' @examples
#' treepositions
"treepositions"


#' Cherry Blossom Blooming Status Color Palette
#'
#' Color palette used on the official Brooklyn Botanic Gardens website tracker.
#'
#' Values can be any of the following: "all",
#' "bloom0", "pre", "prebloom",
#' "bloom1", "first", "first_bloom",
#' "bloom2", "peak", "peak_bloom",
#' "bloom3", "post", "postpeak_bloom".
#'
#' @param name string for what color information to gather
#'
#' @source \url{https://www.bbg.org/collections/cherries}
#' @examples
#' bbgcolors
bbgcolors <- function(name) {
  # Colors for plotting
  prebloom <- "#CFC673"
  first_bloom <- "#EC008C"
  peak_bloom <- "#CD9CC7"
  postpeak_bloom <- "#007647"

  opts <- c(
    "all",
    "bloom0", "pre", "prebloom",
    "bloom1", "first", "first_bloom",
    "bloom2", "peak", "peak_bloom",
    "bloom3", "post", "postpeak_bloom"
  )
  if (!name %in% opts) {
    stop("Invalid name.")
  }

  if (name %in% c("bloom0", "pre", "prebloom")) {
    out <- prebloom
  } else if (name %in% c("bloom1", "first", "first_bloom")) {
    out <- first_bloom
  } else if (name %in% c("bloom2", "peak", "peak_bloom")) {
    out <- peak_bloom
  } else if (name %in% c("bloom3", "post", "postpeak_bloom")) {
    out <- postpeak_bloom
  } else if (name == "all") {
    out <- c(prebloom, first_bloom, peak_bloom, postpeak_bloom)
  }

  structure(out, class = "palette", name = name)
}


#' @export
print.palette <- function(x, ...) {
  # Code source:
  # https://github.com/ciannabp/inauguration

  n <- length(x)
  old <- graphics::par(mar = c(0.5, 0.5, 0.5, 0.5))
  on.exit(graphics::par(old))

  graphics::image(
    1:n,
    1,
    as.matrix(1:n),
    col = x,
    ylab = "",
    xaxt = "n",
    yaxt = "n",
    bty = "n"
  )

  graphics::rect(0,
    0.9,
    n + 1,
    1.1,
    col = grDevices::rgb(1, 1, 1, 0.8),
    border = NA
  )
  graphics::text((n + 1) / 2,
    1,
    labels = attr(x, "name"),
    cex = 1,
    col = "#32373D"
  )
}
