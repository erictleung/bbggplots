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
#'   \item{number}{order of release}
#'   \item{film}{name of film}
#'   \item{release_date}{date film premiered}
#'   \item{run_time}{film length in minutes}
#'   \item{film_rating}{rating based on Motion Picture Association (MPA) film
#'   rating system}
#'   \item{plot}{brief description of the movie plot}
#' }
#' @source \url{https://www.bbg.org/collections/cherries}
#' @examples
#' bbgdata
"bbgdata"
