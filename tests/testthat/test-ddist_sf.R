
test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist_sf(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")),
                                      id = "id",
                                      diagonal = TRUE,
                                      duplicates = TRUE)),
               nrow(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist"))) * nrow(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist"))))
})


test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist_sf(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")),
                                      id = "id",
                                      diagonal = FALSE,
                                      duplicates = TRUE)),
               (nrow(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist"))) * nrow(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")))) - nrow(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist"))))
})


test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist_sf(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")),
                                      id = "id",
                                      diagonal = TRUE,
                                      duplicates = FALSE)),
               (nrow(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")))*nrow(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist"))))/2+(nrow(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")))/2))
})

test_that("output dimensions work", {
  expect_equal(nrow(dyadicdist::ddist_sf(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")),
                                      id = "id",
                                      diagonal = FALSE,
                                      duplicates = FALSE)),
               (nrow(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")))*nrow(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist"))))/2-(nrow(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")))/2))
})


test_that("distance units work", {
  expect_equal(dyadicdist::ddist_sf(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")),
                                 id = "id") %>%
                 pull(distance_units) %>%
                 unique(),
               "m")
})

test_that("distance units work", {
  expect_equal(dyadicdist::ddist_sf(readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")),
                                 id = "id",
                                 crs_transform = TRUE,
                                 new_crs = 3359) %>%
                 pull(distance_units) %>%
                 unique(),
               "US_survey_foot")
})

