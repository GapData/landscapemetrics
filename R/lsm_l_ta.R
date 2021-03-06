#' TA (landscape level)
#'
#' @description Total area (Area and edge metric)
#'
#' @param landscape Raster* Layer, Stack, Brick or a list of rasterLayers.
#' @param directions The number of directions in which patches should be
#' connected: 4 (rook's case) or 8 (queen's case).
#'
#' @details
#' \deqn{CA = sum(AREA[patch_{ij}])}
#' where \eqn{AREA[patch_{ij}]} is the area of each patch in hectares.
#'
#' TA is an 'Area and edge metric'. The total (class) area sums the area of all patches
#' in the landscape. It is the area of the observation area.
#'
#' \subsection{Units}{Hectares}
#' \subsection{Range}{TA > 0}
#' \subsection{Behaviour}{Approaches TA > 0 if the landscape is small and increases,
#' without limit, as the size of the landscape increases.}
#'
#' @seealso
#' \code{\link{lsm_p_area}},
#' \code{\link{sum}}, \cr
#' \code{\link{lsm_c_ca}}
#'
#' @return tibble
#'
#' @examples
#' lsm_l_ta(landscape)
#'
#' @aliases lsm_l_ta
#' @rdname lsm_l_ta
#'
#' @references
#' McGarigal, K., SA Cushman, and E Ene. 2012. FRAGSTATS v4: Spatial Pattern Analysis
#' Program for Categorical and Continuous Maps. Computer software program produced by
#' the authors at the University of Massachusetts, Amherst. Available at the following
#' web site: http://www.umass.edu/landeco/research/fragstats/fragstats.html
#'
#' @export
lsm_l_ta <- function(landscape, directions) UseMethod("lsm_l_ta")


#' @name lsm_l_ta
#' @export
lsm_l_ta.RasterLayer <- function(landscape, directions = 8) {
    purrr::map_dfr(raster::as.list(landscape),
                   lsm_l_ta_calc,
                   directions = directions,
                   .id = "layer") %>%
        dplyr::mutate(layer = as.integer(layer))
}

#' @name lsm_l_ta
#' @export
lsm_l_ta.RasterStack <- function(landscape, directions = 8) {
    purrr::map_dfr(raster::as.list(landscape),
                   lsm_l_ta_calc,
                   directions = directions,
                   .id = "layer") %>%
        dplyr::mutate(layer = as.integer(layer))

}

#' @name lsm_l_ta
#' @export
lsm_l_ta.RasterBrick <- function(landscape, directions = 8) {
    purrr::map_dfr(raster::as.list(landscape),
                   lsm_l_ta_calc,
                   directions = directions,
                   .id = "layer") %>%
        dplyr::mutate(layer = as.integer(layer))

}

#' @name lsm_l_ta
#' @export
lsm_l_ta.list <- function(landscape, directions = 8) {
    purrr::map_dfr(landscape,
                   lsm_l_ta_calc,
                   directions = directions,
                   .id = "layer") %>%
        dplyr::mutate(layer = as.integer(layer))

}

lsm_l_ta_calc <- function(landscape, directions) {

    total_area <- landscape %>%
        lsm_p_area_calc(directions = directions) %>%
        dplyr::summarise(value = sum(value))

    tibble::tibble(
        level = "landscape",
        class = as.integer(NA),
        id = as.integer(NA),
        metric = "ta",
        value = as.double(total_area$value)
    )
}
