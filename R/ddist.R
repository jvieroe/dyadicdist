#' Create dyads of points i and j and calculate distances
#'
#' This function calculates the geodesic distance between any dyads (pairs of points) and stores the result in a long tibble, a opposed to a wide matrix.
#'
#' @param data a data.frame or tibble.
#' @param id a numeric variable uniquely idenfiying points.
#' @param crs a valid EPSG for a valid Coordinate Reference System (CRS). Defaults to 4326.
#' @return ... y
#' @author Jeppe Vierø
#' @export

ddist <- function(data = NULL,
                  id = NULL,
                  crs = 4326) {

  data <- data %>%
    dplyr::filter(!is.na(longitude) & !is.na(latitude)) %>%
    sf::st_as_sf(coords = c("longitude", "latitude"),
                 crs = crs)

  temp <- data %>%
    dplyr::distinct(.,
                    data[[id]],
                    .keep_all = TRUE) %>%
    dplyr::mutate(row_id = row_number())

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
    dplyr::mutate(match_id = base::paste(id_1,
                                         id_2,
                                         sep = "_")) %>%
    tibble::tibble() %>%
    dplyr::select(-c(row_id_1,
                     row_id_2))

  return(dist_long)

}
