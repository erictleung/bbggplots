% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/supplemental.R
\name{bbgcolors}
\alias{bbgcolors}
\title{Cherry Blossom Blooming Status Color Palette}
\source{
\url{https://www.bbg.org/collections/cherries}
}
\usage{
bbgcolors(name)
}
\arguments{
\item{name}{string for what color information to gather}
}
\description{
Color palette used on the official Brooklyn Botanic Gardens website tracker.
}
\details{
Values can be any of the following:
\describe{
\item{all}{"all"}
\item{Pre-bloom}{"bloom0", "pre", "prebloom"}
\item{First bloom}{"bloom1", "first", "first_bloom"}
\item{Peak bloom}{"bloom2", "peak", "peak_bloom"}
\item{Post-peak bloom}{"bloom3", "post", "postpeak_bloom"}
}
}
\examples{
bbgcolors("all")

require(ggplot2)
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
    geom_point(color = bbgcolors("first"))
}
