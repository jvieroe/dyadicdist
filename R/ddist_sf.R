#' Calculate dyadic distances between points `i` and `j` in a spatial dataset
#'
#' This function calculates the geodesic distance between any dyads (pairs of points `i` and `j`) in a spatial dataset and stores the result in a long tibble
#'
#' @param data an object of class `sf` (`"sf" "data.frame"` or `"sf" "tbl_df" "tbl" "data.frame"`)
#' @param id a variable uniquely idenfiying geospatial points. Can be of type numeric, integer, character, or factor
#' @param crs_transform a logical value indicating whether to transform the CRS. Defaults to FALSE
#' @param new_crs a valid EPSG for a new CRS. See `rgdal::make_EPSG()` or \url{https://epsg.org/home.html}
#' @param diagonal a logical value. Keep the diagonal component in the distance matrix with dyads (i,i) and distance zero? Defaults to TRUE
#' @param duplicates a logical value. Keep "identical" dyads (i,j) and (j,i)? Defaults to TRUE. If set to FALSE, only one observation per dyad is kept. Note that this uses \link[dplyr]{rowwise} and makes the \link[dyadicdist]{ddist} function considerably more time-consuming
#' @return a long \link[tibble]{tibble} with dyads and dyadic distances incl. a distance unit indicator
#' @examples
#' library(tibble)
#' df <- tibble::tribble(
#' ~city_name, ~idvar, ~latitude, ~longitude,
#' "copenhagen", 5, 55.68, 12.58,
#' "stockholm", 2, 59.33, 18.07,
#' "oslo", 51, 59.91, 10.75
#' ) %>% sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
#' ddist_sf(data = df, id = "idvar")
#' @author Jeppe Vierø
#' @import dplyr sf tidyr tibble rgdal readr stringr rlang tidyselect
#' @export

ddist_sf <- function(data = NULL,
                     id = NULL,
                     crs_transform = FALSE,
                     new_crs = NULL,
                     diagonal = TRUE,
                     duplicates = TRUE) {

  check_crs_sf(crs_transform = crs_transform,
               new_crs = new_crs)

  check_data_sf(data = data,
                id = id)

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
    dplyr::mutate(row_id_2 = readr::parse_number(.data$temp)) %>%
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
