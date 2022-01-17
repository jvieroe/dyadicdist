context("Test ddist_xy_sf")

library(dplyr)
library(magrittr)

df <- dyadicdist::cities
df <- df %>%
  sf::st_as_sf(coords = c("longitude", "latitude"),
               crs = 4326)

ca <- df %>%
  filter(state == "CA")

tx <- df %>%
  filter(state == "TX")


test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist_xy_sf(ca,
                                            tx,
                                            ids = c("id", "id"))),
               nrow(ca) * nrow(tx))
})


test_that("distance units work", {
  expect_equal(dyadicdist::ddist_xy_sf(ca,
                                       tx,
                                       ids = c("id", "id")) %>%
                 pull(distance_units) %>%
                 unique(),
               "m")
})

test_that("distance units work", {
  expect_equal(dyadicdist::ddist_xy_sf(ca,
                                       tx,
                                       ids = c("id", "id"),
                                       crs_transform = TRUE,
                                       new_crs = 3359) %>%
                 pull(distance_units) %>%
                 unique(),
               "US_survey_foot")
})
