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


usethis::use_data(cities, overwrite = TRUE)
