
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
check_coords_ddist <- function(data) {

  if(base::max(data$longitude) > 180) {
    stop("Inputdata contains invalid longitude coordinates, one or more values > 180")
  }

  if(base::min(data$longitude) < -180) {
    stop("Inputdata contains invalid longitude coordinates, one or more values < -180")
  }

  if(base::max(data$latitude) > 90) {
    stop("Inputdata contains invalid latitude coordinates, one or more values > 90")
  }

  if(base::min(data$latitude) < -90) {
    stop("Inputdata contains invalid latitude coordinates, one or more values < -90")
  }

}



#' @noRd
check_crs <- function(crs_transform,
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
check_data_sf <- function(data,
                          id) {

  if(is.null(id)) { # is.data.frame(data) &&
    stop("No id variable provided")
  }

  if(!id %in% names(data)) {
    stop("The provided id variable is not present in data.")
  }

  if(any(duplicated(data[[id]]))) {
    stop("ID does not uniquely identify rows, duplicates exist")
  }

  if (class(data)[1] != "sf") {
    stop("Inputdata must be an object of class sf. Use dyadicdist::ddist()")
  }

  if (!class(data$geometry)[1] %in% c("sfc_POINT", "sfc")) {
    stop("Inputdata is spatial but its spatial geometry must be of class sfc_POINT")
  }

  if (any(sf::st_is_valid(data) == FALSE)) {
    stop("Inputdata contains invalid geometries")
  }

  if (sf::st_bbox(data)[1] > 180) {
    stop("Inputdata contains invalid longitude coordinates, one or more values > 180")
  }

  if (sf::st_bbox(data)[1] < -180) {
    stop("Inputdata contains invalid longitude coordinates, one or more values < -180")
  }

  if (sf::st_bbox(data)[2] > 90) {
    stop("Inputdata contains invalid latitude coordinates, one or more values > 90")
  }

  if (sf::st_bbox(data)[2] < -90) {
    stop("Inputdata contains invalid latitude coordinates, one or more values < -90")
  }

  if (sf::st_bbox(data)[3] > 180) {
    stop("Inputdata contains invalid longitude coordinates, one or more values > 180")
  }

  if (sf::st_bbox(data)[3] < -180) {
    stop("Inputdata contains invalid longitude coordinates, one or more values < -180")
  }

  if (sf::st_bbox(data)[4] > 90) {
    stop("Inputdata contains invalid latitude coordinates, one or more values > 90")
  }

  if (sf::st_bbox(data)[4] < -90) {
    stop("Inputdata contains invalid latitude coordinates, one or more values < -90")
  }

}


#' @noRd
check_crs_sf <- function(data,
                         crs_transform,
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
