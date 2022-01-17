context("Test ddist")

library(dplyr)
library(magrittr)

df <- dyadicdist::cities


test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

