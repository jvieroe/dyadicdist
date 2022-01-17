context("Test ddisy_xy_sf")

library(dplyr)
library(tidyverse)

df <- dyadicdist::cities

df_1 <- df %>%
  filter(state == "CA")

df_2 <- df %>%
  filter(state == "TX")

test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist_xy(df_1,
                                         df_2,
                                         ids = c("id", "id"))),
               nrow(df_1) * nrow(df_2))
})



test_that("output dimensions work", {
  expect_equal(nrow(
    dyadicdist::ddist_xy(x = df_1,
                         y = df_2,
                         ids = c("id", "id"))
    ),
    nrow(df_1) * nrow(df_2))
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
