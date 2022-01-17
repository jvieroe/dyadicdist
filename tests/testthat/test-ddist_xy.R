context("Test ddisy_xy_sf")

library(dplyr)
library(magrittr)

df <- dyadicdist::cities

df_1 <- df %>%
  filter(state == "CA")

df_2 <- df %>%
  filter(state == "TX")

