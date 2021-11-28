#' Calculate dyadic distances between points `i` and `j` from separate datasets
#'
#' This function calculates the geodesic distance between any dyads (pairs of points `i` and `j`) from datasets `x` and `y` and stores the result in a long tibble
#'
#' @param x an object of class `data.frame` or `tibble`.
#' @param y an object of class `data.frame` or `tibble`.
#' @param id variables uniquely identifying geospatial points in data `x` and `y`. Can be of type numeric, integer, character, or factor
#' @param longitude names of the numeric longitude variables in data `x` and `y`. Defaults to c("longitude", "longitude")
#' @param latitude names of the numeric latitude variables in data `x` and `y`. Defaults to c("latitude", "latitude")
#' @param crs valid EPSG's for your coordinates in data `x` and `y`. Defaults to c(4326, 4326).
#' @param crs_transform a logical value indicating whether to transform the CRS. Defaults to FALSE
#' @param new_crs a valid EPSG for a new CRS. See `rgdal::make_EPSG()` or \url{https://epsg.org/home.html}
#' @return a long \link[tibble]{tibble} with dyads and dyadic distances incl. a distance unit indicator
#' @author Jeppe Vierø
#' @import dplyr sf tidyr tibble rgdal readr stringr rlang tidyselect
#' @export

ddist_xy <- function(x = NULL,
                     y = NULL,
                     id = NULL,
                     longitude = c("longitude", "longitude"),
                     latitude = c("latitude", "latitude"),
                     crs = c(4326, 4326),
                     crs_transform = FALSE,
                     new_crs = NULL) {

  check_raw_cinput(id = id,
                   longitude = longitude,
                   latitude = latitude,
                   crs = crs)

  id_x <- id[1]
  id_y <- id[2]

  longitude_x <- longitude[1]
  longitude_y <- longitude[2]

  latitude_x <- latitude[1]
  latitude_y <- latitude[2]

  crs_x <- crs[1]
  crs_y <- crs[2]

  check_cinput(id_x = id_x,
               id_y = id_y,
               longitude_x = longitude_x,
               latitude_x = latitude_x,
               longitude_y = longitude_y,
               latitude_y = latitude_y,
               crs_x = crs_x,
               crs_y = crs_y)

  check_crs_orig_xy(crs_x = crs_x,
                    crs_y = crs_y)

  check_crs_xy(crs_transform = crs_transform,
               new_crs = new_crs)

  check_data_xy(x = x,
                y = y,
                id_x = id_x,
                id_y = id_y,
                longitude_x = longitude_x,
                latitude_x = latitude_x,
                longitude_y = longitude_y,
                latitude_y = latitude_y)


  # -- x
  if (longitude_x != "longitude") {

    x <- x %>%
      dplyr::rename(longitude = !!rlang::sym(longitude_x))

  }

  if (latitude_x != "latitude") {

    x <- x %>%
      dplyr::rename(latitude = !!rlang::sym(latitude_x))

  }


  # -- y
  if (longitude_y != "longitude") {

    y <- y %>%
      dplyr::rename(longitude = !!rlang::sym(longitude_y))

  }

  if (latitude_y != "latitude") {

    y <- y %>%
      dplyr::rename(latitude = !!rlang::sym(latitude_y))

  }

  check_coords_ddist_xy(x = x,
                        y = y)

  x <- x %>%
    dplyr::filter(!is.na(longitude) & !is.na(latitude)) %>%
    sf::st_as_sf(coords = c("longitude", "latitude"),
                 crs = crs_x)

  y <- y %>%
    dplyr::filter(!is.na(longitude) & !is.na(latitude)) %>%
    sf::st_as_sf(coords = c("longitude", "latitude"),
                 crs = crs_y)

  if (crs_transform == TRUE) {

    x <- x %>%
      sf::st_transform(crs = new_crs)

    y <- y %>%
      sf::st_transform(crs = new_crs)

  } else {

    x <- x
    y <- y

  }

  check_equal_crs(x = x,
                  y = y)


  x_temp <- x %>%
    dplyr::distinct(!!rlang::sym(id_x),
                    .keep_all = TRUE) %>%
    dplyr::mutate(row_id = dplyr::row_number())

  y_temp <- y %>%
    dplyr::distinct(!!rlang::sym(id_y),
                    .keep_all = TRUE) %>%
    dplyr::mutate(row_id = dplyr::row_number())

  dist_mat <- sf::st_distance(x_temp,
                              y_temp,
                              by_element = FALSE) %>%
    base::as.data.frame()

  length_units <- base::units(dist_mat[1,1])$numerator

  dist_mat <- dist_mat %>%
    dplyr::mutate(across(all_of(names(.)),
                         ~ base::unclass(.x)))

  dist_long <- dist_mat %>%
    tidyr::pivot_longer(cols = everything(),
                        names_to = "temp",
                        values_to = "distance") %>%
    dplyr::mutate(
      row_id_1 = base::sort(
        base::rep(
          base::seq(
            1:nrow(x)
          ),
          nrow(y)
        )
      )
    ) %>%
    dplyr::mutate(row_id_2 = readr::parse_number(.data$temp)) %>%
    dplyr::select(-.data$temp) %>%
    dplyr::mutate(distance_units = length_units)

  x_temp <- x_temp %>%
    tibble::tibble() %>%
    dplyr::select(-.data$geometry)

  y_temp <- y_temp %>%
    tibble::tibble() %>%
    dplyr::select(-.data$geometry)

  dist_long <- dist_long %>%
    dplyr::left_join(x_temp,
                     by = c("row_id_1" = "row_id")) %>%
    dplyr::left_join(y_temp,
                     by = c("row_id_2" = "row_id")) %>%
    dplyr::rename_with(.cols = tidyselect::ends_with(".x"),
                       ~ stringr::str_replace_all(., '\\.x', '_1')) %>%
    dplyr::rename_with(.cols = tidyselect::ends_with(".y"),
                       ~ stringr::str_replace_all(., '\\.y', '_2'))

  if (id_x == id_y) {

    dist_long <- dist_long %>%
      dplyr::mutate(id1 := !!rlang::sym(paste0(id_x,
                                               "_1")),
                    id2 := !!rlang::sym(paste0(id_y,
                                               "_2")))

  } else if (id_x != id_y) {

    dist_long <- dist_long %>%
      dplyr::mutate(id1 := !!rlang::sym(id_x),
                    id2 := !!rlang::sym(id_y))

  }

  dist_long <- dist_long %>%
    dplyr::mutate(
      match_id = base::paste(.data$id1,
                             .data$id2,
                             sep = "_")) %>%
    dplyr::select(-c(.data$id1, .data$id2,
                     .data$row_id_1,
                     .data$row_id_2)) %>%
    tibble::tibble()


  return(dist_long)

}
