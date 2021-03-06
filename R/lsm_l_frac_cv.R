#' FRAC_CV (landscape level)
#'
#' @description Coefficient of variation fractal dimension index (Shape metric)
#'
#' @param landscape Raster* Layer, Stack, Brick or a list of rasterLayers.
#' @param directions The number of directions in which patches should be
#' connected: 4 (rook's case) or 8 (queen's case).
#'
#' @details
#' \deqn{FRAC_{CV} = cv(FRAC[patch_{ij}])}
#' where \eqn{FRAC[patch_{ij}]} equals the fractal dimension index of each patch.
#'
#' FRAC_CV is a 'Shape metric'. The metric summarises the landscape
#' as the Coefficient of variation of the fractal dimension index of all patches
#' in the landscape. The fractal dimension index is based on the patch perimeter and
#' the patch area and describes the patch complexity. The Coefficient of variation is
#' scaled to the mean and comparable among different landscapes.
#'
#' \subsection{Units}{None}
#' \subsection{Range}{FRAC_CV >= 0 }
#' \subsection{Behaviour}{Equals FRAC_CV = 0 if the fractal dimension index is identical
#' for all patches. Increases, without limit, as the variation of the fractal dimension
#' indices increases.}
#'
#' @seealso
#' \code{\link{lsm_p_frac}},
#' \code{\link{cv}}, \cr
#' \code{\link{lsm_c_frac_mn}},
#' \code{\link{lsm_c_frac_sd}},
#' \code{\link{lsm_c_frac_cv}}, \cr
#' \code{\link{lsm_l_frac_mn}},
#' \code{\link{lsm_l_frac_sd}},
#'
#' @return tibble
#'
#' @examples
#' lsm_l_frac_cv(landscape)
#'
#' @aliases lsm_l_frac_cv
#' @rdname lsm_l_frac_cv
#'
#' @references
#' McGarigal, K., SA Cushman, and E Ene. 2012. FRAGSTATS v4: Spatial Pattern Analysis
#' Program for Categorical and Continuous Maps. Computer software program produced by
#' the authors at the University of Massachusetts, Amherst. Available at the following
#' web site: http://www.umass.edu/landeco/research/fragstats/fragstats.html
#'
#' Mandelbrot, B. B. 1977. Fractals: Form, Chance, and Dimension.
#' San Francisco. W. H. Freeman and Company.
#'
#' @export
lsm_l_frac_cv <- function(landscape, directions) UseMethod("lsm_l_frac_cv")

#' @name lsm_l_frac_cv
#' @export
lsm_l_frac_cv.RasterLayer <- function(landscape, directions = 8) {
    purrr::map_dfr(raster::as.list(landscape),
                   lsm_l_frac_cv_calc,
                   directions = directions,
                   .id = "layer") %>%
        dplyr::mutate(layer = as.integer(layer))
}

#' @name lsm_l_frac_cv
#' @export
lsm_l_frac_cv.RasterStack <- function(landscape, directions = 8) {
    purrr::map_dfr(raster::as.list(landscape),
                   lsm_l_frac_cv_calc,
                   directions = directions,
                   .id = "layer") %>%
        dplyr::mutate(layer = as.integer(layer))

}

#' @name lsm_l_frac_cv
#' @export
lsm_l_frac_cv.RasterBrick <- function(landscape, directions = 8) {
    purrr::map_dfr(raster::as.list(landscape),
                   lsm_l_frac_cv_calc,
                   directions = directions,
                   .id = "layer") %>%
        dplyr::mutate(layer = as.integer(layer))

}

#' @name lsm_l_frac_cv
#' @export
lsm_l_frac_cv.list <- function(landscape, directions = 8) {
    purrr::map_dfr(landscape,
                   lsm_l_frac_cv_calc,
                   directions = directions,
                   .id = "layer") %>%
        dplyr::mutate(layer = as.integer(layer))

}

lsm_l_frac_cv_calc <- function(landscape, directions){

    frac_cv <- landscape %>%
        lsm_p_frac_calc(directions = directions) %>%
        dplyr::summarise(value = raster::cv(value))

    tibble::tibble(
        level = "landscape",
        class = as.integer(NA),
        id = as.integer(NA),
        metric = "frac_cv",
        value = as.double(frac_cv$value)
    )
}
