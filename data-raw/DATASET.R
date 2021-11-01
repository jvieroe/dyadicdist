## code to prepare `cities` dataset goes here
library(magrittr)

city_url <- "https://www.latlong.net/category/cities-236-15.html"

cities <- city_url %>%
  rvest::read_html() %>%
  rvest::html_nodes("table")

cities <- rbind(rvest::html_table(cities[[1]])) %>%
  janitor::clean_names()

cities <- cities %>%
  dplyr::mutate(city = sapply(strsplit(as.character(cities$place_name),","), "[", 1),
         state = sapply(strsplit(as.character(cities$place_name),","), "[", 2),
         country = sapply(strsplit(as.character(cities$place_name),","), "[", 3)) %>%
  dplyr::select(-place_name)

cities <- cities %>%
  dplyr::mutate(id = base::sample.int((nrow(.)*5),
                               nrow(.),
                               replace = FALSE))

cities <- cities %>%
  dplyr::mutate(city = stringr::str_trim(city, side = "both"),
         state = stringr::str_trim(state, side = "both"),
         country = stringr::str_trim(country, side = "both"))

cities <- cities %>%
  dplyr::mutate(country = "USA") %>%
  dplyr::mutate(state = ifelse(state == "Illinois", "IL", state)) %>%
  dplyr::mutate(state = ifelse(state == "Il", "IL", state)) %>%
  dplyr::mutate(state = ifelse(state == "South Dakota", "SD", state))


usethis::use_data(cities, overwrite = TRUE, internal = FALSE)


## code to prepare `us` dataset goes here
library(sf)
library(rgeos)

# get map data on  the US
usa <- rnaturalearth::ne_countries() %>%
  sf::st_as_sf() %>%
  dplyr::filter(admin == "United States of America")

usa <- usa %>%
  sf::st_crop(.,
              sf::st_bbox(c(xmin = -128,
                            xmax = -57,
                            ymin = 20,
                            ymax = 50),
                          crs = sf::st_crs(usa)))

usa <- usa %>%
  dplyr::select(sovereignt) %>%
  dplyr::rename(country_name = sovereignt)

usethis::use_data(usa, overwrite = TRUE, internal = FALSE)


