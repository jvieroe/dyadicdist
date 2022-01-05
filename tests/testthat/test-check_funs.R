context("Test input data")

library(dplyr)
library(magrittr)

df <- dyadicdist::cities
df_sf <- df %>%
  sf::st_as_sf(coords = c("longitude", "latitude"),
               crs = 4326)

df_1 <- df %>%
  filter(state == "CA")

df_2 <- df %>%
  filter(state == "TX")

df_sf_1 <- df_sf %>%
  filter(state == "CA")

df_sf_2 <- df_sf %>%
  filter(state == "TX")

kc <- df %>%
  filter(city == "Kansas City")

kc_sf <- df_sf %>%
  filter(city == "Kansas City")

dup <- rbind(df,
             kc)

dup_sf <- rbind(df_sf,
                kc_sf)

mat <- df %>% as.matrix()



test_that(
  "only data.frames/tibbles allowed as input data in ddist()", {

    expect_error(dyadicdist::ddist(data = mat,
                                   id = "id"),
                 regexp = "Inputdata must be a data.frame or similar.")

  }
)


test_that(
  "only spatial data.frames/tibbles allowed as input data in ddist_sf()", {

    expect_error(dyadicdist::ddist_sf(data = df,
                                      id = "id"),
                 regexp = "Inputdata must be an object of class sf. Use dyadicdist::ddist()")

    expect_error(dyadicdist::ddist_sf(data = mat,
                                      id = "id"),
                 regexp = "Inputdata must be an object of class sf. Use dyadicdist::ddist()")

  }
)


test_that(
  "duplicate IDs not allowed in mono input functions", {

    expect_error(dyadicdist::ddist(data = dup,
                                   id = "id"),
                 regexp = "ID does not uniquely identify rows, duplicates exist")

    expect_error(dyadicdist::ddist_sf(data = dup_sf,
                                      id = "id"),
                 regexp = "ID does not uniquely identify rows, duplicates exist")

    }
  )


test_that(
  "missing IDs not allowed", {

    expect_error(dyadicdist::ddist(data = df),
                 regexp = "No id variable provided")

    expect_error(dyadicdist::ddist_sf(data = df_sf),
                 regexp = "No id variable provided")

  }
)

test_that(
  "wrong IDs not allowed", {

    expect_error(dyadicdist::ddist(data = df,
                                   id = "test"),
                 regexp = "The provided id variable is not present in data.")

    expect_error(dyadicdist::ddist_sf(data = df_sf,
                                      id = "test"),
                 regexp = "The provided id variable is not present in data.")


  }
)

test_that(
  "check quality of spatial data in ddist_sf()", {

    expect_error(dyadicdist::ddist(data = df,
                                   id = "id"),
                 regexp = "The provided id variable is not present in data.")

    expect_error(dyadicdist::ddist_sf(data = df_sf,
                                      id = "id"),
                 regexp = "The provided id variable is not present in data.")


  }
)
