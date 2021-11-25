#' Calculate dyadic distances between points `i` and `j` from separate spatial datasets
#'
#' This function calculates the geodesic distance between any dyads (pairs of points `i` and `j`) from spatial datasets `x` and `y` and stores the result in a long tibble
#'
#' @param x an object of class `sf` (`"sf" "data.frame"` or `"sf" "tbl_df" "tbl" "data.frame"`)
#' @param y an object of class `sf` (`"sf" "data.frame"` or `"sf" "tbl_df" "tbl" "data.frame"`)
#' @param id_x a variable uniquely idenfiying geospatial points in data `x`. Can be of type numeric, integer, character, or factor
#' @param id_y a variable uniquely idenfiying geospatial points in data `y`. Can be of type numeric, integer, character, or factor
#' @param crs_transform a logical value indicating whether to transform the CRS. Defaults to FALSE
#' @param new_crs a valid EPSG for a new CRS. See `rgdal::make_EPSG()` or \url{https://epsg.org/home.html}
#' @return a long \link[tibble]{tibble} with dyads and dyadic distances incl. a distance unit indicator
#' @author Jeppe Vierø
#' @import dplyr sf tidyr tibble rgdal readr stringr rlang tidyselect
#' @export

ddist_xy_sf <- function(x = NULL,
                        y = NULL,
                        id_x = NULL,
                        id_y = NULL,
                        crs_transform = FALSE,
                        new_crs = NULL) {

  check_crs_xy(crs_transform = crs_transform,
               new_crs = new_crs)

  check_data_xy_sf(x = x,
                   y = y,
                   id_x = id_x,
                   id_y = id_y)


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
                       ~ stringr::str_replace_all(., '\\.y', '_2')) %>%
    dplyr::mutate(id1 := !!rlang::sym(paste0(id_x,
                                             "_1")),
                  id2 := !!rlang::sym(paste0(id_y,
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
