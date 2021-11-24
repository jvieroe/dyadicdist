#' Create dyads of points i and j and calculate distances
#'
#' This function calculates the geodesic distance between any dyads (pairs of points) and stores the result in a long tibble, a opposed to a wide matrix.
#'
#' @param x an object of class `data.frame` or `tibble`.
#' @param y an object of class `data.frame` or `tibble`.
#' @return a long \link[tibble]{tibble} with dyads and dyadic distances incl. a distance unit indicator
#' @author Jeppe Vierø
#' @import dplyr sf tidyr tibble rgdal readr stringr rlang tidyselect
#' @export

ddist_xy <- function(x = NULL,
                     y = NULL,
                     x_id = NULL,
                     y_id = NULL,
                     x_crs = 4326,
                     y_crs = 4326,
                     x_longitude = longitude,
                     x_latitude = latitude,
                     y_longitude = longitude,
                     y_latitude = latitude) {

  check_crs_orig_xy(x_crs = x_crs,
                    y_crs = y_crs)

  check_crs_xy(crs_transform = crs_transform,
               new_crs = new_crs)

  check_data(x = x,
             y = y,
             x_id = x_id,
             y_id = y_id,
             x_longitude = x_longitude,
             x_latitude = x_latitude,
             y_longitude = y_longitude,
             y_latitude = y_latitude)


  # -- x
  if (x_longitude != "longitude") {

    x <- x %>%
      dplyr::rename(longitude = !!rlang::sym(x_longitude))

  }

  if (x_latitude != "latitude") {

    x <- x %>%
      dplyr::rename(latitude = !!rlang::sym(x_latitude))

  }


  # -- y
  if (y_longitude != "longitude") {

    y <- y %>%
      dplyr::rename(longitude = !!rlang::sym(y_longitude))

  }

  if (y_latitude != "latitude") {

    y <- y %>%
      dplyr::rename(latitude = !!rlang::sym(y_latitude))

  }

  check_coords_ddist_xy(x = x,
                        y = y)

  x <- x %>%
    dplyr::filter(!is.na(longitude) & !is.na(latitude)) %>%
    sf::st_as_sf(coords = c("longitude", "latitude"),
                 crs = x_crs)

  y <- y %>%
    dplyr::filter(!is.na(longitude) & !is.na(latitude)) %>%
    sf::st_as_sf(coords = c("longitude", "latitude"),
                 crs = y_crs)

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
    dplyr::distinct(!!rlang::sym(x_id),
                    .keep_all = TRUE) %>%
    dplyr::mutate(row_id = dplyr::row_number())

  y_temp <- y %>%
    dplyr::distinct(!!rlang::sym(y_id),
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
                       ~ stringr::str_replace_all(., '\\.y', '_2')) %>%
    dplyr::mutate(id1 := !!rlang::sym(paste0(x_id,
                                             "_1")),
                  id2 := !!rlang::sym(paste0(y_id,
                                             "_2"))) %>%
    dplyr::mutate(
      match_id = base::paste(.data$id1,
                             .data$id2,
                             sep = "_"))

  # if (duplicates == FALSE) {
  #
  #   dist_long <- dist_long %>%
  #     dplyr::rowwise() %>%
  #     dplyr::mutate(
  #       tmp =
  #         base::paste(
  #           base::sort(
  #             c(
  #               .data$row_id_1,
  #               .data$row_id_2)
  #           ),
  #           collapse = "_")
  #     ) %>%
  #     dplyr::distinct(.data$tmp,
  #                     .keep_all = T) %>%
  #     dplyr::select(-.data$tmp)
  #
  # } else if (duplicates == TRUE) {
  #
  #   dist_long <- dist_long
  #
  # }

  return(dist_long)

}
