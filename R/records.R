#' @importFrom tibble tibble
NULL


#' Brooklyn Botanic Gardens Cherry Blossom Status
#'
#' A data set containing historical data for the Brooklyn Botanic Garden.
#'
#' The data serves as an archive for the more visual map of the cherry blossom
#' trees that the official website shows.
#'
#' @format A data frame with 27 rows and 3 variables:
#' \describe{
#'   \item{date}{date of bloom status}
#'   \item{alt}{full genus and species tree name}
#'   \item{tree}{tree species}
#'   \item{id}{unique integer ID}
#'   \item{bloom}{one of four bloom states: "Prebloom", "First Bloom",
#'       "Peak Bloom", "Post-Peak Bloom"}
#' }
#' @source \url{https://www.bbg.org/collections/cherries}
#' @examples
#' bbgdata
"bbgdata"
