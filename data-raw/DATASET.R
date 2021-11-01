## code to prepare `cities` dataset goes here

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
         country = sapply(strsplit(as.character(cities$place_name),","), "[", 3)) %>%
  select(-place_name)

cities <- cities %>%
  mutate(id = base::sample.int((nrow(.)*5),
                               nrow(.),
                               replace = FALSE))

cities <- cities %>%
  mutate(city = stringr::str_trim(city, side = "both"),
         state = stringr::str_trim(state, side = "both"),
         country = stringr::str_trim(country, side = "both"))

cities <- cities %>%
  mutate(country = "USA") %>%
  mutate(state = ifelse(state == "Illinois", "IL", state)) %>%
  mutate(state = ifelse(state == "Il", "IL", state)) %>%
  mutate(state = ifelse(state == "South Dakota", "SD", state))


usethis::use_data(cities, overwrite = TRUE, internal = TRUE)



## code to prepare `us` dataset goes here
library(sf)
library(rnaturalearth)
library(rgeos)

# get map data on  the US
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

usa <- usa %>%
  select(sovereignt) %>%
  rename(country_name = sovereignt)

usethis::use_data(usa, overwrite = TRUE, internal = TRUE)
