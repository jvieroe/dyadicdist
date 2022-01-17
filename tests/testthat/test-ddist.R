context("Test ddist")

library(dplyr)
library(magrittr)

df <- dyadicdist::cities


test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist(cities,
                                      id = "id",
                                      diagonal = TRUE,
                                      duplicates = TRUE)),
               nrow(df) * nrow(df))
})



test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist(cities,
                                      id = "id",
                                      diagonal = FALSE,
                                      duplicates = TRUE)),
               (nrow(df) * nrow(df)) - nrow(df))
})


test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist(cities,
                                      id = "id",
                                      diagonal = TRUE,
                                      duplicates = FALSE)),
               (nrow(df)*nrow(df))/2+(nrow(df)/2))
})

test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist(cities,
                                      id = "id",
                                      diagonal = FALSE,
                                      duplicates = FALSE)),
               (nrow(df)*nrow(df))/2-(nrow(df)/2))
})



