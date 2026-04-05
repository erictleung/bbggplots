#' @importFrom tibble tibble
NULL


#' Brooklyn Botanic Gardens Cherry Blossom Status
#'
#' A data set containing historical data for the Brooklyn Botanic Garden.
#'
#' The data serves as an archive for the more visual map of the cherry blossom
#' trees that the official website shows.
#'
#' Note: data pulled from 2024 and earlier are retroactively pulled using a
#' snapshot from \url{https://archive.org}, so data is only available based on
#' whether someone saved the page (i.e., there can be missing data).
#'
#' @format A data frame with five column variables:
#' \describe{
#'   \item{date}{date of bloom status}
#'   \item{alt}{string of full genus and species tree name}
#'   \item{tree}{string of tree species}
#'   \item{id}{string of unique integer ID}
#'   \item{bloom}{string of one of four bloom states:
#'       "Prebloom",
#'       "First Bloom",
#'       "Peak Bloom",
#'       "Post-Peak Bloom"
#'   }
#' }
#' @source \url{https://www.bbg.org/collections/cherries}
#' @examples
#' bbgdata
"bbgdata"
