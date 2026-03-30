#' Download WorldClim BIO data
#'
#' @param path Directory to store data
#' @return SpatRaster object
#' @export
download_bioclim <- function(path = "data") {
  geodata::worldclim_global(var = "bio", res = 10, path = path)
}

#' Extract BIO1 layer
#'
#' @param clim SpatRaster
#' @return BIO1 raster
#' @export
get_bio1 <- function(clim) {
  clim[[1]]
}

#' Crop raster to region
#'
#' @param raster SpatRaster
#' @param region Character region name
#' @return Cropped raster
#' @export
crop_region <- function(raster, region) {
  ext_val <- switch(region,
    "South America" = terra::ext(-90, -30, -60, 15),
    "Africa" = terra::ext(-20, 50, -35, 35),
    "Asia" = terra::ext(60, 150, 5, 55)
  )
  
  terra::crop(raster, ext_val)
}

#' Run the Shiny app
#' @export
run_app <- function() {
  shinyApp(ui, server)
}