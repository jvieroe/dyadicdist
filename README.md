
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dyadicdist

<!-- badges: start -->

<!-- badges: end -->

The purpose of `dyadicdist` is to provide quick and easy calculation of
dyadic distances between geo-referenced points.

The main contribution of `dyadicdist::ddist()` is that the output is
stored as a long dyadic `tibble` with dimensions `((N * N), 2)` (number
of rows and columns vary with specified options) as opposed to a wide
`matrix` with dimensions `N * N`.

## Quick example

A simple example with no additional illustrates the workings of
`dyadicdist::ddist()`. It takes as input a `data.frame` or a `tibble`
and returns a `tibble` with dyadic distances for any combination of
points `i` and `j` (see more below)

``` r
library(dyadicdist)
library(tidyverse)

df <- tibble::tribble(
  ~city_name, ~idvar, ~latitude, ~longitude,
  "copenhagen", 5, 55.68, 12.58,
  "stockholm", 2, 59.33, 18.07,
  "oslo", 51, 59.91, 10.75
)

dyadicdist::ddist(data = df,
                  id = "idvar")
#> # A tibble: 9 x 6
#>   distance city_name_1 idvar_1 city_name_2 idvar_2 match_id
#>      <dbl> <chr>         <dbl> <chr>         <dbl> <chr>   
#> 1       0  copenhagen        5 copenhagen        5 5_5     
#> 2  521455. copenhagen        5 stockholm         2 5_2     
#> 3  482648. copenhagen        5 oslo             51 5_51    
#> 4  521455. stockholm         2 copenhagen        5 2_5     
#> 5       0  stockholm         2 stockholm         2 2_2     
#> 6  416439. stockholm         2 oslo             51 2_51    
#> 7  482648. oslo             51 copenhagen        5 51_5    
#> 8  416439. oslo             51 stockholm         2 51_2    
#> 9       0  oslo             51 oslo             51 51_51
```

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
if(!require("devtools")) install.packages("devtools")
library(devtools)
devtools::install_github("jvieroe/dyadicdist")
```

## Working example: US cities

Below, I describe some of the key features and important options of
`dyadicdist::ddist()`.

Let’s use some data on the 100 largest US cities as a working example\!

``` r
library(tidyverse)
library(magrittr)
library(janitor)
library(rvest)
```

First, get the city data using `rvest`:

``` r
city_url <- "https://www.latlong.net/category/cities-236-15.html"

cities <- city_url %>%
   read_html() %>%
   html_nodes("table")

cities <- rbind(html_table(cities[[1]])) %>% 
  janitor::clean_names()

cities <- cities %>% 
  mutate(city = sapply(strsplit(as.character(cities$place_name),","), "[", 1),
         state = sapply(strsplit(as.character(cities$place_name),","), "[", 2),
         country = sapply(strsplit(as.character(cities$place_name),","), "[", 3)) %>% 
  select(-place_name)

cities <- cities %>% 
  mutate(id = row_number())

# Inspect it!
cities
#> # A tibble: 100 x 6
#>    latitude longitude city         state country    id
#>       <dbl>     <dbl> <chr>        <chr> <chr>   <int>
#>  1     44.7     -73.5 Plattsburgh  " NY" " USA"      1
#>  2     41.3     -73.9 Peekskill    " NY" " USA"      2
#>  3     43.1     -75.7 Oneida       " NY" " USA"      3
#>  4     40.9     -73.8 New Rochelle " NY" " USA"      4
#>  5     40.9     -73.8 Mount Vernon " NY" " USA"      5
#>  6     41.5     -74.4 Middletown   " NY" " USA"      6
#>  7     43.2     -78.7 Lockport     " NY" " USA"      7
#>  8     42.8     -78.8 Lackawanna   " NY" " USA"      8
#>  9     41.9     -74.0 Kingston     " NY" " USA"      9
#> 10     43.0     -74.4 Johnstown    " NY" " USA"     10
#> # ... with 90 more rows
```

Let’s have a look at the data from a more obvious point of view: the
cities’ geographic location\!

``` r
# Plot the cities
library(sf)
library(rnaturalearth)
library(rgeos)

usa <- rnaturalearth::ne_countries() %>% 
  sf::st_as_sf() %>% 
  filter(admin == "United States of America")

usa <- usa %>% 
  st_crop(.,
          st_bbox(c(xmin = -128,
                    xmax = -57,
                    ymin = 20,
                    ymax = 50),
                  crs = st_crs(usa)))

city_sf <- cities %>% 
  st_as_sf(.,
           coords = c("longitude", "latitude"),
           crs = 4326)

ggplot() +
  geom_sf(data = usa,
          fill = "grey25",
          color = "white") +
  geom_sf(data = city_sf,
          size = 2,
          shape = 21,
          fill = "chartreuse3", color = "NA",
          alpha = .55) +
  geom_sf(data = city_sf,
          size = 2,
          shape = 21,
          fill = "NA", color = "chartreuse3",
          alpha = 1.0) +
  theme_void() +
  theme(panel.background = element_rect(fill = "#0D1117"),
        plot.background = element_rect(fill = "#0D1117"))
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="85%" style="display: block; margin: auto;" />

## Basic functionality

`dyadicdist::ddist()` has certain key inputs. It takes a `data.frame` or
`tibble` with specified latitude and longitude variables as input.
Furthermore, it requires the specification of a unique id variable which
can be either `numeric`, `integer`, `factor`, or `character`.

``` r
dyadicdist::ddist(cities,
                  id = "id")
#> # A tibble: 10,000 x 10
#>    distance city_1      state_1 country_1  id_1 city_2   state_2 country_2  id_2
#>       <dbl> <chr>       <chr>   <chr>     <int> <chr>    <chr>   <chr>     <int>
#>  1       0  Plattsburgh " NY"   " USA"        1 Plattsb~ " NY"   " USA"        1
#>  2  380730. Plattsburgh " NY"   " USA"        1 Peekski~ " NY"   " USA"        2
#>  3  250647. Plattsburgh " NY"   " USA"        1 Oneida   " NY"   " USA"        3
#>  4  420792. Plattsburgh " NY"   " USA"        1 New Roc~ " NY"   " USA"        4
#>  5  421712. Plattsburgh " NY"   " USA"        1 Mount V~ " NY"   " USA"        5
#>  6  369616. Plattsburgh " NY"   " USA"        1 Middlet~ " NY"   " USA"        6
#>  7  452578. Plattsburgh " NY"   " USA"        1 Lockport " NY"   " USA"        7
#>  8  479240. Plattsburgh " NY"   " USA"        1 Lackawa~ " NY"   " USA"        8
#>  9  310860. Plattsburgh " NY"   " USA"        1 Kingston " NY"   " USA"        9
#> 10  201598. Plattsburgh " NY"   " USA"        1 Johnsto~ " NY"   " USA"       10
#> # ... with 9,990 more rows, and 1 more variable: match_id <chr>
```

As a default, latitude/longitude are specified as `"latitude"` and
`"longitude"`, respectively, and don’t need manual inputs. If necessary
their variable names can be specified in the `ddist()` call:

``` r
cities_new <- cities %>% 
  rename(lat = latitude,
         lon = longitude)

dyadicdist::ddist(cities_new,
                  id = "id",
                  latitude = "lat",
                  longitude = "lon") %>% 
  head(2)
#> # A tibble: 2 x 10
#>   distance city_1      state_1 country_1  id_1 city_2    state_2 country_2  id_2
#>      <dbl> <chr>       <chr>   <chr>     <int> <chr>     <chr>   <chr>     <int>
#> 1       0  Plattsburgh " NY"   " USA"        1 Plattsbu~ " NY"   " USA"        1
#> 2  380730. Plattsburgh " NY"   " USA"        1 Peekskill " NY"   " USA"        2
#> # ... with 1 more variable: match_id <chr>
```

## Output specification

As a default, `ddist()` returns the full list of dyadic distances
between any points `i` and `j`. This includes

  - dyads between any observation and itself, i.e. dyads of type `(i,i)`
    (see example above)
  - duplicated dyads, i.e. both `(i,j)` and `(j,i)`

Both of these are optional however.

  - Sort out `(i,i)` dyads (the diagonal in a distance matrix) by
    specifying `diagonal = FALSE`
  - Sort out duplicated dyads by specifying `duplicates = FALSE`

Let’s compare the outputs\!

  - The default call should return a `tibble` where the number of dyads
    is equal to `nrow(cities) * nrow(cities)`
  - With `diagonal = FALSE` the number of dyads should be equal to
    `nrow(cities) * (nrow(cities)-1)`
  - with `duplicates = FALSE` the number of dyads should be equal to
    `(nrow(cities) * nrow(cities)/2)`
  - With `diagonal = FALSE` and `duplicates = FALSE` the number of dyads
    should be equal to `(nrow(cities) * (nrow(cities)-1)/2)`

<!-- end list -->

``` r
# --- calculate desired length of tibble
# default call
nrow(cities)*nrow(cities)
#> [1] 10000
# diagonal = FALSE
nrow(cities) * (nrow(cities)-1)
#> [1] 9900
# duplicates = FALSE
(nrow(cities) * nrow(cities)/2)
#> [1] 5000
# diagonal = FALSE and duplicates = FALSE
(nrow(cities) * (nrow(cities)-1)/2)
#> [1] 4950
```

``` r
# --- calculate desired length of tibble
#  default call
dyadicdist::ddist(cities,
                  id = "id") %>% 
  nrow()
#> [1] 10000
#  diagonal = FALSE
dyadicdist::ddist(cities,
                  id = "id",
                  diagonal = FALSE) %>% 
  nrow()
#> [1] 9900
#  duplicates = FALSE
dyadicdist::ddist(cities,
                  id = "id",
                  duplicates = FALSE) %>% 
  nrow()
#> [1] 5050
#  diagonal = FALSE and duplicates = FALSE
dyadicdist::ddist(cities,
                  id = "id",
                  diagonal = FALSE,
                  duplicates = FALSE) %>% 
  nrow()
#> [1] 4950
```
