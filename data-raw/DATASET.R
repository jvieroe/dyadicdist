## code to prepare `cities` dataset goes here
library(dplyr)
library(magrittr)
library(tibble)

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

rm(cities)

## code to prepare test data goes here
df <- dyadicdist::cities

saveRDS(df,
        "inst/testdata/df.rds")


df_sf <- df %>%
  sf::st_as_sf(coords = c("longitude", "latitude"),
               crs = 4326)

saveRDS(df_sf,
        "inst/testdata/df_sf.rds")


df_1 <- df %>%
  filter(state == "CA")

saveRDS(df_1,
        "inst/testdata/df_1.rds")

df_2 <- df %>%
  filter(state == "CO")

saveRDS(df_2,
        "inst/testdata/df_2.rds")

df_sf_1 <- df_sf %>%
  filter(state == "CA")

saveRDS(df_sf_1,
        "inst/testdata/df_sf_1.rds")

table(df_sf$state)
df_sf_2 <- df_sf %>%
  filter(state == "CO")

saveRDS(df_sf_2,
        "inst/testdata/df_sf_2.rds")


kc <- df %>%
  filter(city == "Bartow")

saveRDS(kc,
        "inst/testdata/kc.rds")

kc_sf <- df_sf %>%
  filter(city == "Bartow")

saveRDS(kc_sf,
        "inst/testdata/kc_sf.rds")

dup <- rbind(df,
             kc)

saveRDS(dup,
        "inst/testdata/dup.rds")


dup_sf <- rbind(df_sf,
                kc_sf)

saveRDS(dup_sf,
        "inst/testdata/dup_sf.rds")


mat <- df %>% as.matrix()

saveRDS(mat,
        "inst/testdata/mat.rds")


df_na_id <- df %>%
  mutate(id = ifelse(city == "Bartow",
                     NA,
                     id))

saveRDS(df_na_id,
        "inst/testdata/df_na_id.rds")



df_na_lat <- df %>%
  mutate(latitude = ifelse(city == "Bartow",
                           NA,
                           latitude))

saveRDS(df_na_lat,
        "inst/testdata/df_na_lat.rds")


df_na_lon <- df %>%
  mutate(longitude = ifelse(city == "Bartow",
                            NA,
                            longitude))

saveRDS(df_na_lon,
        "inst/testdata/df_na_lon.rds")


df_char_lat <- df %>%
  mutate(latitude = as.character(latitude))

saveRDS(df_char_lat,
        "inst/testdata/df_char_lat.rds")


df_char_lon <- df %>%
  mutate(longitude = as.character(longitude))

saveRDS(df_char_lon,
        "inst/testdata/df_char_lon.rds")


df_sf_na_id <- df_sf %>%
  mutate(id = ifelse(city == "Bartow",
                     NA,
                     id))

saveRDS(df_sf_na_id,
        "inst/testdata/df_sf_na_id.rds")


df_lo_lon <- df %>%
  mutate(longitude = ifelse(city == "Bartow",
                            -181,
                            longitude))

saveRDS(df_lo_lon,
        "inst/testdata/df_lo_lon.rds")


df_hi_lon <- df %>%
  mutate(longitude = ifelse(city == "Bartow",
                            181,
                            longitude))

saveRDS(df_hi_lon,
        "inst/testdata/df_hi_lon.rds")


df_lo_lat <- df %>%
  mutate(latitude = ifelse(city == "Bartow",
                           -91,
                           longitude))

saveRDS(df_lo_lat,
        "inst/testdata/df_lo_lat.rds")


df_hi_lat <- df %>%
  mutate(latitude = ifelse(city == "Bartow",
                           91,
                           longitude))


saveRDS(df_hi_lat,
        "inst/testdata/df_hi_lat.rds")

rm(list=ls())
