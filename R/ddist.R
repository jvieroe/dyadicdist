#' Add a DSB style to your graph
#'
#' This function etc.
#' @param ... x
#' @return ... y
#' @author Jeppe Vierø
#' @export

ddist <- function(data = NULL,
                  id = NULL,
                  #latitude = NULL,
                  #longitude = NULL,
                  crs = 4326) {

  data <- data %>%
    dplyr::filter(!is.na(longitude) & !is.na(latitude)) %>%
    sf::st_as_sf(coords = c("longitude", "latitude"),
                 crs = crs)

  temp <- data %>%
    dplyr::distinct(.,
                    id,
                    .keep_all = TRUE) %>%
    dplyr::select(c(id)) %>%
    dplyr::mutate(row_id = row_number())


  dist_mat <- st_distance(temp,
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
        rep(
          seq(
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
    dplyr::rename_with(.cols = c(id, name, found_name),
                       ~ str_c(., "_1")) %>%
    dplyr::left_join(.,
                     temp,
                     by = c("row_id_2" = "row_id")) %>%
    dplyr::rename_with(.cols = c(id, name, found_name),
                       ~ str_c(., "_2")) %>%
    dplyr::mutate(match_id = base::paste(id_1,
                                         id_2,
                                         sep = "_")) %>%
    dplyr::select(-c(row_id_1,
              row_id_2))

  return(dist_long)

}
