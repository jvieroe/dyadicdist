#' Create dyads of points i and j and calculate distances
#'
#' This function calculates the geodesic distance between any dyads (pairs of points) and stores the result in a long tibble, a opposed to a wide matrix.
#'
#' @param data a data.frame or tibble.
#' @param id a variable uniquely idenfiying geospatial points. Can be of type numeric, integer, character, or factor
#' @param longitude name of the numeric longitude variable. Defaults to "longitude"
#' @param latitude name of the numeric latitude variable. Defaults to "latitude"
#' @param crs a valid EPSG for a valid Coordinate Reference System (CRS) for your coordinates. Defaults to 4326.
#' @param crs_transform a logical value indicating whether to transform the CRS. Defaults to FALSE
#' @param new_crs a valid EPSG for a new CRS. See \url{https://epsg.org/home.html}
#' @param diagonal a logical value. Keep the diagonal component in the distance matrix with dyads (i,i) and distance zero? Defaults to TRUE
#' @param duplicates a logical value. Keep "identical" dyads (i,j) and (j,i)? Defaults to TRUE. If set to FALSE, only one observation per dyad is kept. Note that this uses \link[dplyr]{rowwise} and makes the \link[dyadicdist]{ddist} function considerably more time-consuming
#' @return a long \link[tibble]{tibble} with dyads and dyadic distances
#' @author Jeppe Vierø
#' @export

ddist <- function(data = NULL,
                  id = NULL,
                  longitude = "longitude",
                  latitude = "latitude",
                  crs = 4326,
                  crs_transform = FALSE,
                  new_crs = NULL,
                  diagonal = TRUE,
                  duplicates = TRUE) {

  check_crs(data = data,
            crs_transform = crs_transform,
            new_crs = new_crs)

  check_data(data = data,
             id = id,
             longitude = longitude,
             latitude = latitude)

  if (longitude != "longitude") {

    data <- data %>%
      dplyr::rename(longitude = !!rlang::sym(longitude))

  }

  if (latitude != "latitude") {

    data <- data %>%
      dplyr::rename(latitude = !!rlang::sym(latitude))

  }

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

  if (duplicates == FALSE) {

    dist_long <- dist_long %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        tmp =
          base::paste(
            base::sort(
              c(
                row_id_1,
                row_id_2)
              ),
            collapse = "_")
      ) %>%
      dplyr::distinct(.,
                      tmp,
                      .keep_all = T) %>%
      dplyr::select(-tmp)

  } else if (duplicates == TRUE) {

    dist_long <- dist_long

  }

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
