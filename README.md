
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CodeFactor](https://www.codefactor.io/repository/github/jvieroe/dyadicdist/badge)](https://www.codefactor.io/repository/github/jvieroe/dyadicdist)

# dyadicdist

<!-- badges: start -->

<!-- badges: end -->

The purpose of `dyadicdist` is to provide quick and easy calculation of
dyadic distances between geo-referenced points.

The main contribution of `dyadicdist::ddist()` and
`dyadicdist::ddist_sf()` is that the output is stored as a long dyadic
`tibble` as opposed to a wide `matrix`.

This is a very early development version. Please don’t hesitate to let
me know of any errors and/or deficiencies you might come across.

## Quick example

A simple example with no additional illustrates the workings of
`ddist()`. It takes as input a `data.frame` or a `tibble` and returns a
`tibble` with dyadic distances for any combination of points i and j
(see more below)

``` r
library(tidyverse)
library(dyadicdist)

df <- tibble::tribble(
  ~city_name, ~idvar, ~latitude, ~longitude,
  "copenhagen", 5, 55.68, 12.58,
  "stockholm", 2, 59.33, 18.07,
  "oslo", 51, 59.91, 10.75
)

ddist(data = df,
      id = "idvar")
#> # A tibble: 9 x 7
#>   distance distance_units city_name_1 idvar_1 city_name_2 idvar_2 match_id
#>      <dbl> <chr>          <chr>         <dbl> <chr>         <dbl> <chr>   
#> 1       0  m              copenhagen        5 copenhagen        5 5_5     
#> 2  521455. m              copenhagen        5 stockholm         2 5_2     
#> 3  482648. m              copenhagen        5 oslo             51 5_51    
#> 4  521455. m              stockholm         2 copenhagen        5 2_5     
#> 5       0  m              stockholm         2 stockholm         2 2_2     
#> 6  416439. m              stockholm         2 oslo             51 2_51    
#> 7  482648. m              oslo             51 copenhagen        5 51_5    
#> 8  416439. m              oslo             51 stockholm         2 51_2    
#> 9       0  m              oslo             51 oslo             51 51_51
```

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
if(!require("devtools")) install.packages("devtools")
library(devtools)
devtools::install_github("jvieroe/dyadicdist")
```

## Working example: `ddist()`

Below, I describe some of the key features of `dyadicdist`. Let’s use
some data on the 100 largest US cities as a working example:

``` r
cities <- dyadicdist::cities
usa <- dyadicdist::usa
```

Let’s have a look at the cities’ geographic location in the US:

``` r
library(sf)

city_sf <- cities %>%
  st_as_sf(.,
           coords = c("longitude", "latitude"),
           crs = 4326)

ggplot() +
  geom_sf(data = usa,
          fill = "grey25", color = "white") +
  geom_sf(data = city_sf,
          size = 2.5, shape = 21, alpha = .55,
          fill = "chartreuse3", color = "NA") +
  geom_sf(data = city_sf,
          size = 2.5, shape = 21, alpha = 1.0,
          fill = "NA", color = "chartreuse3") +
  theme_void() +
  theme(panel.background = element_rect(fill = "#0D1117"),
        plot.background = element_rect(fill = "#0D1117"))
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="85%" style="display: block; margin: auto;" />

## Basic functionality

`ddist()` has **two key inputs**. It requires a `data.frame` or `tibble`
with specified latitude and longitude variables. Furthermore, it
requires the specification of a unique id variable which can be either
`numeric`, `integer`, `factor`, or `character`.

``` r
ddist(cities,
      id = "id")
#> # A tibble: 10,000 x 11
#>    distance distance_units city_1      state_1 country_1  id_1 city_2    state_2
#>       <dbl> <chr>          <chr>       <chr>   <chr>     <int> <chr>     <chr>  
#>  1       0  m              Schenectady NY      USA         431 Schenect~ NY     
#>  2   31869. m              Schenectady NY      USA         431 Saratoga~ NY     
#>  3  204716. m              Schenectady NY      USA         431 Rye       NY     
#>  4  133700. m              Schenectady NY      USA         431 Rome      NY     
#>  5   24559. m              Schenectady NY      USA         431 Renssela~ NY     
#>  6  213131. m              Schenectady NY      USA         431 Plattsbu~ NY     
#>  7  169132. m              Schenectady NY      USA         431 Peekskill NY     
#>  8  144114. m              Schenectady NY      USA         431 Oneida    NY     
#>  9  210578. m              Schenectady NY      USA         431 New Roch~ NY     
#> 10  211070. m              Schenectady NY      USA         431 Mount Ve~ NY     
#> # ... with 9,990 more rows, and 3 more variables: country_2 <chr>, id_2 <int>,
#> #   match_id <chr>
```

As a default, latitude/longitude are specified as `"latitude"` and
`"longitude"`, respectively, and don’t need manual inputs. If necessary
their variable names can be specified in the `ddist()` call:

``` r
cities_new <- cities %>%
  rename(lat = latitude,
         lon = longitude)

ddist(cities_new,
      id = "id",
      latitude = "lat",
      longitude = "lon") %>%
  head(2)
#> # A tibble: 2 x 11
#>   distance distance_units city_1      state_1 country_1  id_1 city_2     state_2
#>      <dbl> <chr>          <chr>       <chr>   <chr>     <int> <chr>      <chr>  
#> 1       0  m              Schenectady NY      USA         431 Schenecta~ NY     
#> 2   31869. m              Schenectady NY      USA         431 Saratoga ~ NY     
#> # ... with 3 more variables: country_2 <chr>, id_2 <int>, match_id <chr>
```

## Output specification

By default, `ddist()` returns the full list of dyadic distances between
any points i and j, including j = i.

In total, this amount to `nrow(data) * nrow(data)` dyads and includes by
default:

  - dyads between any observation and itself, i.e. dyads of type (i,i)
    (see example above)
  - duplicated dyads, i.e. both (i,j) and (j,i)

Both of these inclusions are optional, however.

  - Sort out (i,i) dyads (the diagonal in a distance matrix) by
    specifying `diagonal = FALSE`
      - returns a `tibble` with `nrow(data) * (nrow(data)-1)` dyads
  - Sort out duplicated dyads by specifying `duplicates = FALSE`
      - returns a `tibble` with `(nrow(data) *
        (nrow(data)-1)/2)+nrow(data)` dyads
  - Sort out both by specifying `diagonal = FALSE` **and** `duplicates =
    FALSE`
      - returns a `tibble` with `(nrow(data) * (nrow(data)-1)/2)` dyads

## CRS transformations

By default `ddist()` assumes unprojected coordinates in basic
latitude/longitude format (EPSG code `4326`) when converting the raw
data provided in the `data` argument to a spatial feature. This is
consistent with the default when converting latitude/longitude data to
spatial features in the `sf` package (see `sf::st_as_sf()`). You can
apply a different CRS by providing a valid EPSG code of type `numeric`
with the `crs` argument.

Additionally, `ddist()` allows you to transform the CRS before
calculating dyadic distances using the `crs_transform` and `new_crs`
arguments:

``` r
ddist(cities,
      id = "id",
      crs_transform = T,
      new_crs = 3359)
#> # A tibble: 10,000 x 11
#>    distance distance_units city_1      state_1 country_1  id_1 city_2    state_2
#>       <dbl> <chr>          <chr>       <chr>   <chr>     <int> <chr>     <chr>  
#>  1       0  US_survey_foot Schenectady NY      USA         431 Schenect~ NY     
#>  2  105468. US_survey_foot Schenectady NY      USA         431 Saratoga~ NY     
#>  3  675517. US_survey_foot Schenectady NY      USA         431 Rye       NY     
#>  4  443781. US_survey_foot Schenectady NY      USA         431 Rome      NY     
#>  5   81318. US_survey_foot Schenectady NY      USA         431 Renssela~ NY     
#>  6  706757. US_survey_foot Schenectady NY      USA         431 Plattsbu~ NY     
#>  7  558267. US_survey_foot Schenectady NY      USA         431 Peekskill NY     
#>  8  478389. US_survey_foot Schenectady NY      USA         431 Oneida    NY     
#>  9  694798. US_survey_foot Schenectady NY      USA         431 New Roch~ NY     
#> 10  696411. US_survey_foot Schenectady NY      USA         431 Mount Ve~ NY     
#> # ... with 9,990 more rows, and 3 more variables: country_2 <chr>, id_2 <int>,
#> #   match_id <chr>
```

For a list of supported CRS transformations, see `rgdal::make_EPSG()`.

Note that the choice of CRS may impact your results considerably. For
more information on choosing an appropriate CRS, see
[here](https://www.earthdatascience.org/courses/earth-analytics/spatial-data-r/intro-to-coordinate-reference-systems/),
[here](https://docs.qgis.org/3.4/en/docs/gentle_gis_introduction/coordinate_reference_systems.html),
[here](https://www.nceas.ucsb.edu/sites/default/files/2020-04/OverviewCoordinateReferenceSystems.pdf),
and
[here](http://www.geo.hunter.cuny.edu/~jochen/gtech201/lectures/lec6concepts/map%20coordinate%20systems/how%20to%20choose%20a%20projection.htm)

## Spatial input data with `ddist_sf()`

To measure dyadic distances with an object of class `sf` use
`ddist_sf()`:

``` r
cities %>%
  st_as_sf(.,
           coords = c("longitude", "latitude"),
           crs = 4326) %>%
  ddist_sf(.,
           id = "id")
#> # A tibble: 10,000 x 11
#>    distance distance_units city_1      state_1 country_1  id_1 city_2    state_2
#>       <dbl> <chr>          <chr>       <chr>   <chr>     <int> <chr>     <chr>  
#>  1       0  m              Schenectady NY      USA         431 Schenect~ NY     
#>  2   31869. m              Schenectady NY      USA         431 Saratoga~ NY     
#>  3  204716. m              Schenectady NY      USA         431 Rye       NY     
#>  4  133700. m              Schenectady NY      USA         431 Rome      NY     
#>  5   24559. m              Schenectady NY      USA         431 Renssela~ NY     
#>  6  213131. m              Schenectady NY      USA         431 Plattsbu~ NY     
#>  7  169132. m              Schenectady NY      USA         431 Peekskill NY     
#>  8  144114. m              Schenectady NY      USA         431 Oneida    NY     
#>  9  210578. m              Schenectady NY      USA         431 New Roch~ NY     
#> 10  211070. m              Schenectady NY      USA         431 Mount Ve~ NY     
#> # ... with 9,990 more rows, and 3 more variables: country_2 <chr>, id_2 <int>,
#> #   match_id <chr>
```

With the exception of `crs`, `longitude`, and `latitude` (all of which
are inherently provided in an object of class `sf`), `ddist_sf()` takes
the same optional arguments as `ddist()`.

# Acknowledgements

  - The R Core Team for developing and maintaining the language
  - The authors of the amazing `sf` package. `sf` has greatly reduced
    barriers to entry for anyone working with spatial data in `R` and
    those who wish to do so
      - Edzer Pebesma ([edzer](https://github.com/edzer))
      - Roger Bivand ([rsbivand](https://github.com/rsbivand))
      - Etienne Racine ([etiennebr](https://github.com/etiennebr))
      - Michael Sumner ([mdsumner](https://github.com/mdsumner))
      - Ian Cook ([ianmcook](https://github.com/ianmcook))
      - Tim Keitt ([thk686](https://github.com/thk686))
      - Robin Lovelace
        ([Robinlovelace](https://github.com/Robinlovelace))
      - Hadley Wickham ([hadley](https://github.com/hadley))
      - Jeroen Ooms ([jeroen](https://github.com/jeroen))
      - Kirill Müller ([krlmlr](https://github.com/krlmlr))
      - Thomas Lin Pedersen ([thomasp85](https://github.com/thomasp85))
      - Dan Baston ([dbaston](https://github.com/dbaston))
      - Dewey Dunnington ([paleolimbot](https://github.com/paleolimbot))
  - [Natural Earth](https://www.naturalearthdata.com/) for the
    `dyadicdist::usa` data
  - [LatLong.net](https://www.latlong.net/category/cities-236-15.html)
    for the `dyadicdist::cities` data
