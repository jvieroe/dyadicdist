#' Create dyads of points i and j and calculate distances
#'
#' This function calculates the geodesic distance between any dyads (pairs of points) and stores the result in a long tibble, a opposed to a wide matrix.
#'
#' @param data an sf data.frame or tibble.
#' @param id a numeric variable uniquely idenfiying points.
#' @param crs_transform a logical value indicating whether to transform the Coordinate Reference System (CRS). Defaults to FALSE
#' @param new_crs a valid EPSG for a new CRS.
#' @param diagonal a logical value indicating whether to keep the diagonal component in the distance matrix with dyads (i,i). Defaults to TRUE
#' @return ... y
#' @author Jeppe Vierø
#' @export

ddist_sf <- function(data = NULL,
                     id = NULL,
                     crs_transform = FALSE,
                     new_crs = NULL,
                     diagonal = TRUE) {

  if (crs_transform == TRUE) {

    data <- data %>%
      sf::st_transform(crs = new_crs)

  } else {

    data <- data

  }

  temp <- data %>%
    dplyr::distinct(.,
                    !!rlang::sym(id),
                    .keep_all = TRUE) %>%
    dplyr::mutate(row_id = dplyr::row_number())

  dist_mat <- sf::st_distance(temp,
                              temp,
                              by_element = FALSE) %>%
    base::unclass() %>%
    base::as.data.frame()

  dist_long <- dist_mat %>%
    tidyr::pivot_longer(cols = everything(),
                        names_to = "temp",
                        values_to = "distance") %>%
    dplyr::mutate(
      row_id_1 = sort(
        base::rep(
          base::seq(
            1:nrow(dist_mat)
          ),
          nrow(dist_mat)
        )
      )
    ) %>%
    dplyr::mutate(row_id_2 = readr::parse_number(temp)) %>%
    dplyr::select(-temp)

  temp <- temp %>%
    tibble::tibble() %>%
    dplyr::select(-geometry)

  dist_long <- dist_long %>%
    dplyr::left_join(.,
                     temp,
                     by = c("row_id_1" = "row_id")) %>%
    dplyr::left_join(.,
                     temp,
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
      match_id = base::paste(id1,
                             id2,
                             sep = "_"))

  if (diagonal == TRUE) {

    dist_long <- dist_long %>%
      dplyr::select(-c(id1, id2,
                       row_id_1,
                       row_id_2)) %>%
      tibble::tibble()

  } else if (diagonal == FALSE) {

    dist_long <- dist_long %>%
      filter(id1 != id2) %>%
      dplyr::select(-c(id1, id2,
                       row_id_1,
                       row_id_2)) %>%
      tibble::tibble()

  }

  return(dist_long)

}
