library(dplyr)
library(magrittr)
library(tibble)


df <- dyadicdist::cities
df <- df %>%
  sf::st_as_sf(coords = c("longitude", "latitude"),
               crs = 4326)


test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist_sf(df,
                                      id = "id",
                                      diagonal = TRUE,
                                      duplicates = TRUE)),
               nrow(df) * nrow(df))
})


test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist_sf(df,
                                      id = "id",
                                      diagonal = FALSE,
                                      duplicates = TRUE)),
               (nrow(df) * nrow(df)) - nrow(df))
})


test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist_sf(df,
                                      id = "id",
                                      diagonal = TRUE,
                                      duplicates = FALSE)),
               (nrow(df)*nrow(df))/2+(nrow(df)/2))
})

test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist_sf(df,
                                      id = "id",
                                      diagonal = FALSE,
                                      duplicates = FALSE)),
               (nrow(df)*nrow(df))/2-(nrow(df)/2))
})


test_that("distance units work", {
  expect_equal(dyadicdist::ddist_sf(df,
                                 id = "id") %>%
                 pull(distance_units) %>%
                 unique(),
               "m")
})

test_that("distance units work", {
  expect_equal(dyadicdist::ddist_sf(df,
                                 id = "id",
                                 crs_transform = TRUE,
                                 new_crs = 3359) %>%
                 pull(distance_units) %>%
                 unique(),
               "US_survey_foot")
})

