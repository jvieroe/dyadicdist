
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dyadicdist

<!-- badges: start -->

<!-- badges: end -->

The goal of dyadicdist is to quickly calculate distance between
geographic points and store these as dyads

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
if(!require("devtools")) install.packages("devtools")
library(devtools)
devtools::install_github("jvieroe/dyadicdist")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(tidyverse)
library(magrittr)
library(janitor)
library(rvest)

city_url <- "https://www.latlong.net/category/cities-236-15.html"

cities <- city_url %>%
   read_html() %>%
   html_nodes("table")

cities <- rbind(html_table(cities[[1]])) %>% 
  janitor::clean_names()

cities <- cities %>% 
  mutate(city = sapply(strsplit(as.character(cities$place_name),","), "[", 1),
         state = sapply(strsplit(as.character(cities$place_name),","), "[", 2),
         country = sapply(strsplit(as.character(cities$place_name),","), "[", 3))

cities <- cities %>% 
  mutate(id = row_number())

cities
#> # A tibble: 100 x 7
#>    place_name            latitude longitude city         state country    id
#>    <chr>                    <dbl>     <dbl> <chr>        <chr> <chr>   <int>
#>  1 Plattsburgh, NY, USA      44.7     -73.5 Plattsburgh  " NY" " USA"      1
#>  2 Peekskill, NY, USA        41.3     -73.9 Peekskill    " NY" " USA"      2
#>  3 Oneida, NY, USA           43.1     -75.7 Oneida       " NY" " USA"      3
#>  4 New Rochelle, NY, USA     40.9     -73.8 New Rochelle " NY" " USA"      4
#>  5 Mount Vernon, NY, USA     40.9     -73.8 Mount Vernon " NY" " USA"      5
#>  6 Middletown, NY, USA       41.5     -74.4 Middletown   " NY" " USA"      6
#>  7 Lockport, NY, USA         43.2     -78.7 Lockport     " NY" " USA"      7
#>  8 Lackawanna, NY, USA       42.8     -78.8 Lackawanna   " NY" " USA"      8
#>  9 Kingston, NY, USA         41.9     -74.0 Kingston     " NY" " USA"      9
#> 10 Johnstown, NY, USA        43.0     -74.4 Johnstown    " NY" " USA"     10
#> # ... with 90 more rows
```

``` r
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

cit_sf <- cities %>% 
  st_as_sf(.,
           coords = c("longitude", "latitude"),
           crs = 4326)

ggplot() +
  geom_sf(data = usa,
          fill = "grey85",
          color = "white") +
  geom_sf(data = cit_sf,
          size = 4,
          shape = 21,
          fill = "darkred", color = "NA",
          alpha = .6) +
  theme_minimal() +
  theme(panel.background = element_rect(fill = "#0D1117",
                                        color = "#0D1117"),
        axis.text = element_blank(),
        axis.title = element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.margin=grid::unit(c(0,0,0,0),
                               "mm"),
        plot.background = element_rect(fill = "#0D1117"))
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="85%" style="display: block; margin: auto;" />

``` r
#library(dyadicdist)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```
