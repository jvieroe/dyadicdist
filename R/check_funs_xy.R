
#' @noRd
check_data_xy <- function(x,
                          y,
                          x_id,
                          y_id,
                          x_longitude,
                          x_latitude,
                          y_longitude,
                          y_latitude) {

  if (!is.data.frame(x)) {
    stop("Inputdata 'x' must be a data.frame or similar.")
  }

  if (!is.data.frame(y)) {
    stop("Inputdata 'y' must be a data.frame or similar.")
  }

  if(is.null(x_id)) { # is.data.frame(data) &&
    stop("No x_id variable provided")
  }

  if(is.null(y_id)) { # is.data.frame(data) &&
    stop("No y_id variable provided")
  }

  if(!x_id %in% names(x)) {
    stop("The provided id variable is not present in data 'x'.")
  }

  if(!y_id %in% names(y)) {
    stop("The provided id variable is not present in data 'y'.")
  }


  if(any(duplicated(x[[x_id]]))) {
    stop("ID (x_id) does not uniquely identify rows, duplicates exist")
  }

  if(any(duplicated(y[[y_id]]))) {
    stop("ID (y_id) does not uniquely identify rows, duplicates exist")
  }

  # -- x

  if(!x_longitude %in% names(x)) {
    stop("The provided longitude variable is not present in data 'x'.")
  }

  if(!is.numeric(x[[x_longitude]])) {
    stop("The provided x_longitude variable is not numeric")
  }

  if(any(is.na(x[[x_longitude]]))) {
    stop("The provided x_longitude variable contains NAs")
  }

  if(!x_latitude %in% names(x)) {
    stop("The provided x_latitude variable is not present in data.")
  }

  if(!is.numeric(x[[x_latitude]])) {
    stop("The provided x_latitude variable is not numeric")
  }

  if(any(is.na(x[[x_latitude]]))) {
    stop("The provided x_latitude variable contains NAs")
  }

  # -- y

  if(!y_longitude %in% names(y)) {
    stop("The provided longitude variable is not present in data 'y'.")
  }

  if(!is.numeric(y[[y_longitude]])) {
    stop("The provided y_longitude variable is not numeric")
  }

  if(any(is.na(y[[y_longitude]]))) {
    stop("The provided y_longitude variable contains NAs")
  }

  if(!y_latitude %in% names(y)) {
    stop("The provided y_latitude variable is not present in data.")
  }

  if(!is.numeric(y[[y_latitude]])) {
    stop("The provided y_latitude variable is not numeric")
  }

  if(any(is.na(y[[y_latitude]]))) {
    stop("The provided y_latitude variable contains NAs")
  }

}


#' @noRd
check_coords_ddist_xy <- function(data) {

  # -- x
  if(base::max(x$x_longitude) > 180) {
    stop("Inputdata 'x' contains invalid x_longitude coordinates, one or more values > 180")
  }

  if(base::min(x$x_longitude) < -180) {
    stop("Inputdata 'x' contains invalid x_longitude coordinates, one or more values < -180")
  }

  if(base::max(x$x_latitude) > 90) {
    stop("Inputdata 'x' contains invalid x_latitude coordinates, one or more values > 90")
  }

  if(base::min(x$x_latitude) < -90) {
    stop("Inputdata 'x' contains invalid x_latitude coordinates, one or more values < -90")
  }

  # -- y
  if(base::max(y$y_longitude) > 180) {
    stop("Inputdata 'y' contains invalid y_longitude coordinates, one or more values > 180")
  }

  if(base::min(y$y_longitude) < -180) {
    stop("Inputdata 'y' contains invalid y_longitude coordinates, one or more values < -180")
  }

  if(base::max(y$y_latitude) > 90) {
    stop("Inputdata 'y' contains invalid y_latitude coordinates, one or more values > 90")
  }

  if(base::min(y$y_latitude) < -90) {
    stop("Inputdata 'y' contains invalid y_latitude coordinates, one or more values < -90")
  }

}


#' @noRd
check_crs_xy <- function(crs_transform,
                         new_crs) {

  if(crs_transform == TRUE && is.null(new_crs)) {
    stop("No new CRS provided")
  }

  if(crs_transform == TRUE && !is.numeric(new_crs)) {
    stop("New CRS is not numeric")
  }

  if(crs_transform == TRUE && !new_crs %in% c(rgdal::make_EPSG()$code))  {
    stop("New CRS is not valid, see rgdal::make_EPSG()")
  }

}
