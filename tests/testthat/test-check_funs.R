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

df_na_id <- df %>%
  mutate(id = ifelse(city == "Kansas City",
                     NA,
                     id))

df_na_lat <- df %>%
  mutate(latitude = ifelse(city == "Kansas City",
                           NA,
                           latitude))

df_na_lon <- df %>%
  mutate(longitude = ifelse(city == "Kansas City",
                            NA,
                            longitude))

df_char_lat <- df %>%
  mutate(latitude = as.character(latitude))

df_char_lon <- df %>%
  mutate(longitude = as.character(longitude))


df_sf_na_id <- df_sf %>%
  mutate(id = ifelse(city == "Kansas City",
                     NA,
                     id))

df_lo_lon <- df %>%
  mutate(longitude = ifelse(city == "Kansas City",
                            -181,
                            longitude))

df_hi_lon <- df %>%
  mutate(longitude = ifelse(city == "Kansas City",
                            181,
                            longitude))

df_lo_lat <- df %>%
  mutate(latitude = ifelse(city == "Kansas City",
                            -91,
                            longitude))

df_hi_lat <- df %>%
  mutate(latitude = ifelse(city == "Kansas City",
                            91,
                            longitude))


df_sf_lo_lon <- df_lo_lon %>%
  sf::st_as_sf(coords = c("longitude", "latitude"),
               crs = 4326)

df_sf_hi_lon <- df_hi_lon %>%
  sf::st_as_sf(coords = c("longitude", "latitude"),
               crs = 4326)


df_sf_lo_lat <- df_lo_lat %>%
  sf::st_as_sf(coords = c("longitude", "latitude"),
               crs = 4326)

df_sf_hi_lat <- df_hi_lat %>%
  sf::st_as_sf(coords = c("longitude", "latitude"),
               crs = 4326)


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
  "NAs in ID(s) not allowed", {

    expect_error(dyadicdist::ddist(data = df_na_id,
                                   id = "id"),
                 regexp = "The provided ID variable contains NAs")

    expect_error(dyadicdist::ddist_sf(data = df_sf_na_id,
                                      id = "id"),
                 regexp = "The provided ID variable contains NAs")

  }
)


test_that(
  "check quality of coords", {

    expect_error(dyadicdist::ddist(data = df_na_lat,
                                   id = "id"),
                 regexp = "The provided latitude variable contains NAs")

    expect_error(dyadicdist::ddist(data = df_na_lon,
                                   id = "id"),
                 regexp = "The provided longitude variable contains NAs")

    expect_error(dyadicdist::ddist(data = df_char_lon,
                                   id = "id"),
                 regexp = "The provided longitude variable is not numeric")

    expect_error(dyadicdist::ddist(data = df_char_lat,
                                   id = "id"),
                 regexp = "The provided latitude variable is not numeric")

    expect_error(dyadicdist::ddist(data = df_lo_lat,
                                   id = "id"),
                 regexp = "Inputdata contains invalid latitude coordinates, one or more values < -90")

    expect_error(dyadicdist::ddist(data = df_hi_lat,
                                   id = "id"),
                 regexp = "Inputdata contains invalid latitude coordinates, one or more values > 90")

    expect_error(dyadicdist::ddist(data = df_lo_lon,
                                   id = "id"),
                 regexp = "Inputdata contains invalid longitude coordinates, one or more values < -180")

    expect_error(dyadicdist::ddist(data = df_hi_lon,
                                   id = "id"),
                 regexp = "Inputdata contains invalid longitude coordinates, one or more values > 180")


  }

)




test_that(
  "check CRS inputs", {

    expect_error(dyadicdist::ddist(data = df,
                                   id = "id",
                                   crs = "4326"),
                 regexp = "Provided CRS is not numeric")

    expect_error(dyadicdist::ddist(data = df,
                                   id = "id",
                                   crs = 43266),
                 regexp = "Provided CRS is not valid, see rgdal::make_EPSG()")

    expect_error(dyadicdist::ddist(data = df,
                                   id = "id",
                                   crs = 1),
                 regexp = "Provided CRS is not valid, see rgdal::make_EPSG()")

    expect_error(dyadicdist::ddist(data = df,
                                   id = "id",
                                   crs = 156),
                 regexp = "Provided CRS is not valid, see rgdal::make_EPSG()")


  }
)


test_that(
  "check CRS transformation inputs", {

    expect_error(dyadicdist::ddist(data = df,
                                   id = "id",
                                   crs_transform = TRUE),
                 regexp = "No new CRS provided")

    expect_error(dyadicdist::ddist(data = df,
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = "4326"),
                 regexp = "New CRS is not numeric")

    expect_error(dyadicdist::ddist(data = df,
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = 43266),
                 regexp = "New CRS is not valid, see rgdal::make_EPSG()")

    expect_error(dyadicdist::ddist(data = df,
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = 20),
                 regexp = "New CRS is not valid, see rgdal::make_EPSG()")


    expect_error(dyadicdist::ddist(data = df,
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = 145),
                 regexp = "New CRS is not valid, see rgdal::make_EPSG()")


  }
)


# test_that(
#   "check quality of spatial inputs", {
#
#     expect_error(dyadicdist::ddist_sf(data = df_sf_lo_lat,
#                                       id = "id"))
#
#     expect_error(dyadicdist::ddist_sf(data = df_sf_hi_lat,
#                                       id = "id"))
#
#     expect_error(dyadicdist::ddist_sf(data = df_sf_lo_lon,
#                                       id = "id"))
#
#     expect_error(dyadicdist::ddist_sf(data = df_sf_hi_lon,
#                                       id = "id"))
#
#   }
# )

test_that(
  "check CR inputs for spatial inputs", {

    expect_error(dyadicdist::ddist_sf(data = df_sf,
                                      id = "id",
                                      crs_transform = TRUE),
                 regexp = "No new CRS provided")

    expect_error(dyadicdist::ddist_sf(data = df_sf,
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = "4326"),
                 regexp = "New CRS is not numeric")

    expect_error(dyadicdist::ddist_sf(data = df_sf,
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = 43266),
                 regexp = "New CRS is not valid, see rgdal::make_EPSG()")

    expect_error(dyadicdist::ddist_sf(data = df_sf,
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = 20),
                 regexp = "New CRS is not valid, see rgdal::make_EPSG()")


    expect_error(dyadicdist::ddist_sf(data = df_sf,
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = 145),
                 regexp = "New CRS is not valid, see rgdal::make_EPSG()")


    expect_warning(dyadicdist::ddist_sf(data = df_sf,
                                      id = "id",
                                      crs_transform = FALSE,
                                      new_crs = 4326),
                 regexp = "New CRS is ignored, use crs_transform == TRUE")


  }
)



