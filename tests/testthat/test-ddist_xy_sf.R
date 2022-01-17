context("Test ddist_xy_sf")

library(dplyr)
library(magrittr)

df <- dyadicdist::cities
df <- df %>%
  sf::st_as_sf(coords = c("longitude", "latitude"),
               crs = 4326)

df_1 <- df %>%
  filter(state == "CA")

df_2 <- df_sf %>%
  filter(state == "TX")
