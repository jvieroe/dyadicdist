
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
check_coords_ddist_xy <- function(x,
                                  y) {

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
check_crs_orig_xy <- function(x_crs,
                              y_crs) {

  if(!is.numeric(x_crs)){
    stop("Provided y_crs is not numeric")
  }

  if(!is.numeric(y_crs)){
    stop("Provided x_crs is not numeric")
  }

  if(!x_crs %in% c(rgdal::make_EPSG()$code))  {
    stop("Provided x_crs is not valid, see rgdal::make_EPSG()")
  }

  if(!y_crs %in% c(rgdal::make_EPSG()$code))  {
    stop("Provided y_crs is not valid, see rgdal::make_EPSG()")
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


#' @noRd
check_equal_crs <- function(x,
                            y) {

  if(readr::parse_number(sf::st_crs(x)[[1]]) != readr::parse_number(sf::st_crs(y)[[1]])){
    stop("Data 'x' and 'y' have different CRS'. Transform using crs_transform and new_crs")
  }

}


#' @noRd
check_data_xy_sf <- function(x,
                             y,
                             x_id,
                             y_id) {

  if(is.null(x_id)) { # is.data.frame(data) &&
    stop("No x_id variable provided")
  }

  if(is.null(y_id)) { # is.data.frame(data) &&
    stop("No y_id variable provided")
  }

  if(!x_id %in% names(x)) {
    stop("The provided id variable is not present in data.")
  }

  if(!y_id %in% names(y)) {
    stop("The provided id variable is not present in data.")
  }

  if(any(duplicated(x[[x_id]]))) {
    stop("ID (x_id) does not uniquely identify rows, duplicates exist")
  }

  if(any(duplicated(y[[y_id]]))) {
    stop("ID (y_id) does not uniquely identify rows, duplicates exist")
  }


  if (class(x)[1] != "sf") {
    stop("Inputdata 'x' must be an object of class sf. Use dyadicdist::ddist_xy()")
  }

  if (class(y)[1] != "sf") {
    stop("Inputdata 'y' must be an object of class sf. Use dyadicdist::ddist_xy()")
  }


  if (!class(x$geometry)[1] %in% c("sfc_POINT", "sfc")) {
    stop("Inputdata 'x' is spatial but its spatial geometry must be of class sfc_POINT")
  }

  if (!class(y$geometry)[1] %in% c("sfc_POINT", "sfc")) {
    stop("Inputdata 'y' is spatial but its spatial geometry must be of class sfc_POINT")
  }


  if (any(sf::st_is_valid(x) == FALSE)) {
    stop("Inputdata 'x' contains invalid geometries")
  }

  if (any(sf::st_is_valid(y) == FALSE)) {
    stop("Inputdata 'y' contains invalid geometries")
  }

  if (sf::st_bbox(x)[1] > 180) {
    stop("Inputdata 'x' contains invalid longitude coordinates, one or more values > 180")
  }

  if (sf::st_bbox(x)[1] < -180) {
    stop("Inputdata 'x' contains invalid longitude coordinates, one or more values < -180")
  }

  if (sf::st_bbox(x)[2] > 90) {
    stop("Inputdata 'x' contains invalid latitude coordinates, one or more values > 90")
  }

  if (sf::st_bbox(x)[2] < -90) {
    stop("Inputdata 'x' contains invalid latitude coordinates, one or more values < -90")
  }

  if (sf::st_bbox(x)[3] > 180) {
    stop("Inputdata 'x' contains invalid longitude coordinates, one or more values > 180")
  }

  if (sf::st_bbox(x)[3] < -180) {
    stop("Inputdata 'x' contains invalid longitude coordinates, one or more values < -180")
  }

  if (sf::st_bbox(x)[4] > 90) {
    stop("Inputdata 'x' contains invalid latitude coordinates, one or more values > 90")
  }

  if (sf::st_bbox(x)[4] < -90) {
    stop("Inputdata 'x' contains invalid latitude coordinates, one or more values < -90")
  }

  if (sf::st_bbox(y)[1] > 180) {
    stop("Inputdata 'y' contains invalid longitude coordinates, one or more values > 180")
  }

  if (sf::st_bbox(y)[1] < -180) {
    stop("Inputdata 'y' contains invalid longitude coordinates, one or more values < -180")
  }

  if (sf::st_bbox(y)[2] > 90) {
    stop("Inputdata 'y' contains invalid latitude coordinates, one or more values > 90")
  }

  if (sf::st_bbox(y)[2] < -90) {
    stop("Inputdata 'y' contains invalid latitude coordinates, one or more values < -90")
  }

  if (sf::st_bbox(y)[3] > 180) {
    stop("Inputdata 'y' contains invalid longitude coordinates, one or more values > 180")
  }

  if (sf::st_bbox(y)[3] < -180) {
    stop("Inputdata 'y' contains invalid longitude coordinates, one or more values < -180")
  }

  if (sf::st_bbox(y)[4] > 90) {
    stop("Inputdata 'y' contains invalid latitude coordinates, one or more values > 90")
  }

  if (sf::st_bbox(y)[4] < -90) {
    stop("Inputdata 'y' contains invalid latitude coordinates, one or more values < -90")
  }


}




