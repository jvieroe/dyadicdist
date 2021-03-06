% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ddist_xy_sf.R
\name{ddist_xy_sf}
\alias{ddist_xy_sf}
\title{Calculate dyadic distances between points \code{i} and \code{j} from separate spatial datasets}
\usage{
ddist_xy_sf(
  x = NULL,
  y = NULL,
  ids = NULL,
  crs_transform = FALSE,
  new_crs = NULL
)
}
\arguments{
\item{x}{an object of class \code{sf} (\verb{"sf" "data.frame"} or \verb{"sf" "tbl_df" "tbl" "data.frame"})}

\item{y}{an object of class \code{sf} (\verb{"sf" "data.frame"} or \verb{"sf" "tbl_df" "tbl" "data.frame"})}

\item{ids}{variables uniquely identifying geospatial points in data \code{x} and \code{y}. Can be of type numeric, integer, character, or factor}

\item{crs_transform}{a logical value indicating whether to transform the CRS. Defaults to FALSE}

\item{new_crs}{a valid EPSG for a new CRS. See \code{rgdal::make_EPSG()} or \url{https://epsg.org/home.html}}
}
\value{
a long \link[tibble]{tibble} with dyads and dyadic distances incl. a distance unit indicator
}
\description{
This function calculates the geodesic distance between any dyads (pairs of points \code{i} and \code{j}) from spatial datasets \code{x} and \code{y} and stores the result in a long tibble
}
\author{
Jeppe Vierø
}
