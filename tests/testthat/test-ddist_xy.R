#
# test_that("output dimensions work", {
#   expect_equal(nrow(dyadicdist::ddist_xy(base::readRDS(system.file("testdata", "df_1.rds", package = "dyadicdist")),
#                                          base::readRDS(system.file("testdata", "df_2.rds", package = "dyadicdist")),
#                                          ids = c("id", "id"))),
#                nrow(readRDS(system.file("testdata", "df_1.rds", package = "dyadicdist"))) * nrow(readRDS(system.file("testdata", "df_2.rds", package = "dyadicdist"))))
# })
#
#
# test_that("distance units work", {
#   expect_equal(dyadicdist::ddist_xy(readRDS(system.file("testdata", "df_1.rds", package = "dyadicdist")),
#                                     readRDS(system.file("testdata", "df_2.rds", package = "dyadicdist")),
#                                     ids = c("id", "id")) %>%
#                  pull(distance_units) %>%
#                  unique(),
#                "m")
# })
#
# test_that("distance units work", {
#   expect_equal(dyadicdist::ddist_xy(readRDS(system.file("testdata", "df_1.rds", package = "dyadicdist")),
#                                     readRDS(system.file("testdata", "df_2.rds", package = "dyadicdist")),
#                                     ids = c("id", "id"),
#                                     crs_transform = TRUE,
#                                     new_crs = 3359) %>%
#                  pull(distance_units) %>%
#                  unique(),
#                "US_survey_foot")
# })
#
#
