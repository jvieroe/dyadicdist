
test_that(
  "only data.frames/tibbles allowed as input data in ddist()", {

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "mat.rds", package = "dyadicdist")),
                                   id = "id"),
                 regexp = "Inputdata must be a data.frame or similar.")

  }
)


test_that(
  "only spatial data.frames/tibbles allowed as input data in ddist_sf()", {

    expect_error(dyadicdist::ddist_sf(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                      id = "id"),
                 regexp = "Inputdata must be an object of class sf. Use dyadicdist::ddist()")

    expect_error(dyadicdist::ddist_sf(data = readRDS(system.file("testdata", "mat.rds", package = "dyadicdist")),
                                      id = "id"),
                 regexp = "Inputdata must be an object of class sf. Use dyadicdist::ddist()")

  }
)


test_that(
  "duplicate IDs not allowed in mono input functions", {

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "dup.rds", package = "dyadicdist")),
                                   id = "id"),
                 regexp = "ID does not uniquely identify rows, duplicates exist")

    expect_error(dyadicdist::ddist_sf(data = readRDS(system.file("testdata", "dup_sf.rds", package = "dyadicdist")),
                                      id = "id"),
                 regexp = "ID does not uniquely identify rows, duplicates exist")

    }
  )


test_that(
  "missing IDs not allowed", {

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist"))),
                 regexp = "No id variable provided")

    expect_error(dyadicdist::ddist_sf(data = readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist"))),
                 regexp = "No id variable provided")

  }
)

test_that(
  "wrong IDs not allowed", {

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                   id = "test"),
                 regexp = "The provided id variable is not present in data.")

    expect_error(dyadicdist::ddist_sf(data = readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")),
                                      id = "test"),
                 regexp = "The provided id variable is not present in data.")

  }
)

test_that(
  "NAs in ID(s) not allowed", {

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df_na_id.rds", package = "dyadicdist")),
                                   id = "id"),
                 regexp = "The provided ID variable contains NAs")

    expect_error(dyadicdist::ddist_sf(data = readRDS(system.file("testdata", "df_sf_na_id.rds", package = "dyadicdist")),
                                      id = "id"),
                 regexp = "The provided ID variable contains NAs")

  }
)


test_that(
  "check quality of coords", {

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df_na_lat.rds", package = "dyadicdist")),
                                   id = "id"),
                 regexp = "The provided latitude variable contains NAs")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df_na_lon.rds", package = "dyadicdist")),
                                   id = "id"),
                 regexp = "The provided longitude variable contains NAs")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df_char_lon.rds", package = "dyadicdist")),
                                   id = "id"),
                 regexp = "The provided longitude variable is not numeric")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df_char_lat.rds", package = "dyadicdist")),
                                   id = "id"),
                 regexp = "The provided latitude variable is not numeric")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df_lo_lat.rds", package = "dyadicdist")),
                                   id = "id"),
                 regexp = "Inputdata contains invalid latitude coordinates, one or more values < -90")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df_hi_lat.rds", package = "dyadicdist")),
                                   id = "id"),
                 regexp = "Inputdata contains invalid latitude coordinates, one or more values > 90")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df_lo_lon.rds", package = "dyadicdist")),
                                   id = "id"),
                 regexp = "Inputdata contains invalid longitude coordinates, one or more values < -180")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df_hi_lon.rds", package = "dyadicdist")),
                                   id = "id"),
                 regexp = "Inputdata contains invalid longitude coordinates, one or more values > 180")


  }

)




test_that(
  "check CRS inputs", {

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                   id = "id",
                                   crs = "4326"),
                 regexp = "Provided CRS is not numeric")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                   id = "id",
                                   crs = 43266),
                 regexp = "Provided CRS is not valid, see rgdal::make_EPSG()")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                   id = "id",
                                   crs = 1),
                 regexp = "Provided CRS is not valid, see rgdal::make_EPSG()")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                   id = "id",
                                   crs = 156),
                 regexp = "Provided CRS is not valid, see rgdal::make_EPSG()")

    expect_warning(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                     id = "id",
                                     crs_transform = FALSE,
                                     new_crs = 4326),
                   regexp = "New CRS is ignored, use crs_transform = TRUE")

  }
)


test_that(
  "check CRS transformation inputs", {

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                   id = "id",
                                   crs_transform = TRUE),
                 regexp = "No new CRS provided")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = "4326"),
                 regexp = "New CRS is not numeric")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = 43266),
                 regexp = "New CRS is not valid, see rgdal::make_EPSG()")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = 20),
                 regexp = "New CRS is not valid, see rgdal::make_EPSG()")


    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = 145),
                 regexp = "New CRS is not valid, see rgdal::make_EPSG()")


  }
)


test_that(
  "check CRS inputs for spatial inputs", {

    expect_error(dyadicdist::ddist_sf(data = readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")),
                                      id = "id",
                                      crs_transform = TRUE),
                 regexp = "No new CRS provided")

    expect_error(dyadicdist::ddist_sf(data = readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")),
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = "4326"),
                 regexp = "New CRS is not numeric")

    expect_error(dyadicdist::ddist_sf(data = readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")),
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = 43266),
                 regexp = "New CRS is not valid, see rgdal::make_EPSG()")

    expect_error(dyadicdist::ddist_sf(data = readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")),
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = 20),
                 regexp = "New CRS is not valid, see rgdal::make_EPSG()")


    expect_error(dyadicdist::ddist_sf(data = readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")),
                                   id = "id",
                                   crs_transform = TRUE,
                                   new_crs = 145),
                 regexp = "New CRS is not valid, see rgdal::make_EPSG()")

    expect_warning(dyadicdist::ddist_sf(data = readRDS(system.file("testdata", "df_sf.rds", package = "dyadicdist")),
                                      id = "id",
                                      crs_transform = FALSE,
                                      new_crs = 4326),
                 regexp = "New CRS is ignored, use crs_transform = TRUE")


  }
)


test_that(
  "wrong IDs not allowed", {

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                   id = "id",
                                   latitude = "test"),
                 regexp = "The provided latitude variable is not present in data.")

    expect_error(dyadicdist::ddist(data = readRDS(system.file("testdata", "df.rds", package = "dyadicdist")),
                                   id = "id",
                                   longitude = "test"),
                 regexp = "The provided longitude variable is not present in data.")


  }
)



