
#' @noRd
check_data_xy <- function(x,
                          y,
                          id_x,
                          id_y,
                          longitude_x,
                          latitude_x,
                          longitude_y,
                          latitude_y) {

  if (!is.data.frame(x)) {
    stop("Inputdata 'x' must be a data.frame or similar.")
  }

  if (!is.data.frame(y)) {
    stop("Inputdata 'y' must be a data.frame or similar.")
  }

  if(is.null(id_x)) { # is.data.frame(data) &&
    stop("No id_x variable provided")
  }

  if(is.null(id_y)) { # is.data.frame(data) &&
    stop("No id_y variable provided")
  }

  if(!id_x %in% names(x)) {
    stop("The provided id variable is not present in data 'x'.")
  }

  if(!id_y %in% names(y)) {
    stop("The provided id variable is not present in data 'y'.")
  }


  if(any(duplicated(x[[id_x]]))) {
    stop("ID (id_x) does not uniquely identify rows, duplicates exist")
  }

  if(any(duplicated(y[[id_y]]))) {
    stop("ID (id_y) does not uniquely identify rows, duplicates exist")
  }

  # -- x

  if(!longitude_x %in% names(x)) {
    stop("The provided longitude variable is not present in data 'x'.")
  }

  if(!is.numeric(x[[longitude_x]])) {
    stop("The provided longitude_x variable is not numeric")
  }

  if(any(is.na(x[[longitude_x]]))) {
    stop("The provided longitude_x variable contains NAs")
  }

  if(!latitude_x %in% names(x)) {
    stop("The provided latitude_x variable is not present in data.")
  }

  if(!is.numeric(x[[latitude_x]])) {
    stop("The provided latitude_x variable is not numeric")
  }

  if(any(is.na(x[[latitude_x]]))) {
    stop("The provided latitude_x variable contains NAs")
  }

  # -- y

  if(!longitude_y %in% names(y)) {
    stop("The provided longitude variable is not present in data 'y'.")
  }

  if(!is.numeric(y[[longitude_y]])) {
    stop("The provided longitude_y variable is not numeric")
  }

  if(any(is.na(y[[longitude_y]]))) {
    stop("The provided longitude_y variable contains NAs")
  }

  if(!latitude_y %in% names(y)) {
    stop("The provided latitude_y variable is not present in data.")
  }

  if(!is.numeric(y[[latitude_y]])) {
    stop("The provided latitude_y variable is not numeric")
  }

  if(any(is.na(y[[latitude_y]]))) {
    stop("The provided latitude_y variable contains NAs")
  }

}


#' @noRd
check_coords_ddist_xy <- function(x,
                                  y) {

  # -- x
  if(base::max(x$longitude_x) > 180) {
    stop("Inputdata 'x' contains invalid longitude_x coordinates, one or more values > 180")
  }

  if(base::min(x$longitude_x) < -180) {
    stop("Inputdata 'x' contains invalid longitude_x coordinates, one or more values < -180")
  }

  if(base::max(x$latitude_x) > 90) {
    stop("Inputdata 'x' contains invalid latitude_x coordinates, one or more values > 90")
  }

  if(base::min(x$latitude_x) < -90) {
    stop("Inputdata 'x' contains invalid latitude_x coordinates, one or more values < -90")
  }

  # -- y
  if(base::max(y$longitude_y) > 180) {
    stop("Inputdata 'y' contains invalid longitude_y coordinates, one or more values > 180")
  }

  if(base::min(y$longitude_y) < -180) {
    stop("Inputdata 'y' contains invalid longitude_y coordinates, one or more values < -180")
  }

  if(base::max(y$latitude_y) > 90) {
    stop("Inputdata 'y' contains invalid latitude_y coordinates, one or more values > 90")
  }

  if(base::min(y$latitude_y) < -90) {
    stop("Inputdata 'y' contains invalid latitude_y coordinates, one or more values < -90")
  }

}


#' @noRd
check_crs_orig_xy <- function(crs_x,
                              crs_y) {

  if(!is.numeric(crs_x)){
    stop("Provided crs_y is not numeric")
  }

  if(!is.numeric(crs_y)){
    stop("Provided crs_x is not numeric")
  }

  if(!crs_x %in% c(rgdal::make_EPSG()$code))  {
    stop("Provided crs_x is not valid, see rgdal::make_EPSG()")
  }

  if(!crs_y %in% c(rgdal::make_EPSG()$code))  {
    stop("Provided crs_y is not valid, see rgdal::make_EPSG()")
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
                             id_x,
                             id_y) {

  if(is.null(id_x)) { # is.data.frame(data) &&
    stop("No id_x variable provided")
  }

  if(is.null(id_y)) { # is.data.frame(data) &&
    stop("No id_y variable provided")
  }

  if(!id_x %in% names(x)) {
    stop("The provided id variable is not present in data.")
  }

  if(!id_y %in% names(y)) {
    stop("The provided id variable is not present in data.")
  }

  if(any(duplicated(x[[id_x]]))) {
    stop("ID (id_x) does not uniquely identify rows, duplicates exist")
  }

  if(any(duplicated(y[[id_y]]))) {
    stop("ID (id_y) does not uniquely identify rows, duplicates exist")
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




