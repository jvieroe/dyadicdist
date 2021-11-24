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
                     x_longitude = longitude,
                     x_latitude = latitude,
                     y_longitude = longitude,
                     y_latitude = latitude) {

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

  if (longitude != "longitude") {

    data <- data %>%
      dplyr::rename(longitude = !!rlang::sym(longitude))

  }

  if (latitude != "latitude") {

    data <- data %>%
      dplyr::rename(latitude = !!rlang::sym(latitude))

  }

  check_coords_ddist(data = data)

  data <- data %>%
    dplyr::filter(!is.na(longitude) & !is.na(latitude)) %>%
    sf::st_as_sf(coords = c("longitude", "latitude"),
                 crs = crs)

  if (crs_transform == TRUE) {

    data <- data %>%
      sf::st_transform(crs = new_crs)

  } else {

    data <- data

  }

  temp <- data %>%
    dplyr::distinct(!!rlang::sym(id),
                    .keep_all = TRUE) %>%
    dplyr::mutate(row_id = dplyr::row_number())

  dist_mat <- sf::st_distance(temp,
                              temp,
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
            1:nrow(dist_mat)
          ),
          nrow(dist_mat)
        )
      )
    ) %>%
    dplyr::mutate(row_id_2 = readr::parse_number(temp)) %>%
    dplyr::select(-.data$temp) %>%
    dplyr::mutate(distance_units = length_units)

  temp <- temp %>%
    tibble::tibble() %>%
    dplyr::select(-.data$geometry)

  dist_long <- dist_long %>%
    dplyr::left_join(temp,
                     by = c("row_id_1" = "row_id")) %>%
    dplyr::left_join(temp,
                     by = c("row_id_2" = "row_id")) %>%
    dplyr::rename_with(.cols = tidyselect::ends_with(".x"),
                       ~ stringr::str_replace_all(., '\\.x', '_1')) %>%
    dplyr::rename_with(.cols = tidyselect::ends_with(".y"),
                       ~ stringr::str_replace_all(., '\\.y', '_2')) %>%
    dplyr::mutate(id1 := !!rlang::sym(paste0(id,
                                             "_1")),
                  id2 := !!rlang::sym(paste0(id,
                                             "_2"))) %>%
    dplyr::mutate(
      match_id = base::paste(.data$id1,
                             .data$id2,
                             sep = "_"))

  if (duplicates == FALSE) {

    dist_long <- dist_long %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        tmp =
          base::paste(
            base::sort(
              c(
                .data$row_id_1,
                .data$row_id_2)
            ),
            collapse = "_")
      ) %>%
      dplyr::distinct(.data$tmp,
                      .keep_all = T) %>%
      dplyr::select(-.data$tmp)

  } else if (duplicates == TRUE) {

    dist_long <- dist_long

  }

  if (diagonal == TRUE) {

    dist_long <- dist_long %>%
      dplyr::select(-c(.data$id1, .data$id2,
                       .data$row_id_1,
                       .data$row_id_2)) %>%
      tibble::tibble()

  } else if (diagonal == FALSE) {

    dist_long <- dist_long %>%
      dplyr::filter(.data$id1 != .data$id2) %>%
      dplyr::select(-c(.data$id1, .data$id2,
                       .data$row_id_1,
                       .data$row_id_2)) %>%
      tibble::tibble()

  }

  return(dist_long)

}
