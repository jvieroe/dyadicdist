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


## code to prepare test data goes here
df <- dyadicdist::cities

df_sf <- df %>%
  sf::st_as_sf(coords = c("longitude", "latitude"),
               crs = 4326)

df_1 <- df %>%
  filter(state == "CA")

df_2 <- df %>%
  filter(state == "TX")

df_sf_1 <- df_sf %>%
  filter(state == "CA")

df_sf_2 <- df_sf %>%
  filter(state == "TX")

kc <- df %>%
  filter(city == "Kansas City")

kc_sf <- df_sf %>%
  filter(city == "Kansas City")

dup <- rbind(df,
             kc)

dup_sf <- rbind(df_sf,
                kc_sf)

mat <- df %>% as.matrix()

df_na_id <- df %>%
  mutate(id = ifelse(city == "Kansas City",
                     NA,
                     id))

df_na_lat <- df %>%
  mutate(latitude = ifelse(city == "Kansas City",
                           NA,
                           latitude))

df_na_lon <- df %>%
  mutate(longitude = ifelse(city == "Kansas City",
                            NA,
                            longitude))

df_char_lat <- df %>%
  mutate(latitude = as.character(latitude))

df_char_lon <- df %>%
  mutate(longitude = as.character(longitude))


df_sf_na_id <- df_sf %>%
  mutate(id = ifelse(city == "Kansas City",
                     NA,
                     id))

df_lo_lon <- df %>%
  mutate(longitude = ifelse(city == "Kansas City",
                            -181,
                            longitude))

df_hi_lon <- df %>%
  mutate(longitude = ifelse(city == "Kansas City",
                            181,
                            longitude))

df_lo_lat <- df %>%
  mutate(latitude = ifelse(city == "Kansas City",
                           -91,
                           longitude))

df_hi_lat <- df %>%
  mutate(latitude = ifelse(city == "Kansas City",
                           91,
                           longitude))



