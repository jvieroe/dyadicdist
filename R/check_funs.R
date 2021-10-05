
#' @noRd
check_data <- function(data,
                       id,
                       longitude,
                       latitude) {

  if (!is.data.frame(data)) {
    stop("Inputdata must be a data.frame or similar.")
  }

  if(is.null(id)) { # is.data.frame(data) &&
    stop("No id variable provided")
  }

  if(!id %in% names(data)) {
    stop("The provided id variable is not present in data.")
  }

  if(any(duplicated(data[[id]]))) {
    stop("ID does not uniquely identify rows, duplicates exist")
  }

  if(!longitude %in% names(data)) {
    stop("The provided longitude variable is not present in data.")
  }

  if(!is.numeric(data[[longitude]])) {
    stop("The provided longitude variable is not numeric")
  }

  if(any(is.na(data[[longitude]]))) {
    stop("The provided longitude variable contains NAs")
  }

  if(!latitude %in% names(data)) {
    stop("The provided latitude variable is not present in data.")
  }

  if(!is.numeric(data[[latitude]])) {
    stop("The provided latitude variable is not numeric")
  }

  if(any(is.na(data[[latitude]]))) {
    stop("The provided latitude variable contains NAs")
  }

}



#' @noRd
check_crs <- function(data,
                      crs_transform,
                      new_crs) {

  if(crs_transform == TRUE && is.null(new_crs)) {
    stop("No new CRS provided")
  }

  if(crs_transform == TRUE && !is.numeric(new_crs)) {
    stop("New CRS is not numeric")
  }

}
