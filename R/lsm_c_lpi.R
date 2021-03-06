#' LPI (class level)
#'
#' @description Largest patch index (Area and Edge metric)
#'
#' @param landscape Raster* Layer, Stack, Brick or a list of rasterLayers.
#' @param directions The number of directions in which patches should be
#' connected: 4 (rook's case) or 8 (queen's case).
#'
#' @details
#' \deqn{LPI = \frac{\max \limits_{j = 1}^{n} (a_{ij})} {A} * 100}
#' where \eqn{max(a_{ij})} is the area of the patch in square meters and \eqn{A}
#' is the total landscape area in square meters.
#'
#' The largest patch index is an 'Area and edge metric'. It is the percentage of the
#' landscape covered by the corresponding largest patch of each class i. It is a simple
#' measure of dominance.
#'
#' \subsection{Units}{Percentage}
#' \subsection{Range}{0 < LPI <= 100}
#' \subsection{Behaviour}{Approaches LPI = 0 when the largest patch is becoming small
#' and equals LPI = 100 when only one patch is present}
#'
#' @seealso
#' \code{\link{lsm_p_area}},
#' \code{\link{lsm_l_ta}}, \cr
#' \code{\link{lsm_l_lpi}}
#'
#' @return tibble
#'
#' @examples
#' lsm_c_lpi(landscape)
#'
#' @aliases lsm_c_lpi
#' @rdname lsm_c_lpi
#'
#' @references
#' McGarigal, K., SA Cushman, and E Ene. 2012. FRAGSTATS v4: Spatial Pattern Analysis
#' Program for Categorical and Continuous Maps. Computer software program produced by
#' the authors at the University of Massachusetts, Amherst. Available at the following
#' web site: http://www.umass.edu/landeco/research/fragstats/fragstats.html
#'
#' @export
lsm_c_lpi <- function(landscape, directions) UseMethod("lsm_c_lpi")

#' @name lsm_c_lpi
#' @export
lsm_c_lpi.RasterLayer <- function(landscape, directions = 8) {
    purrr::map_dfr(raster::as.list(landscape),
                   lsm_c_lpi_calc,
                   directions = directions,
                   .id = "layer") %>%
        dplyr::mutate(layer = as.integer(layer))
}

#' @name lsm_c_lpi
#' @export
lsm_c_lpi.RasterStack <- function(landscape, directions = 8) {
    purrr::map_dfr(raster::as.list(landscape),
                   lsm_c_lpi_calc,
                   directions = directions,
                   .id = "layer") %>%
        dplyr::mutate(layer = as.integer(layer))
}

#' @name lsm_c_lpi
#' @export
lsm_c_lpi.RasterBrick <- function(landscape, directions = 8) {
    purrr::map_dfr(raster::as.list(landscape),
                   lsm_c_lpi_calc,
                   directions = directions,
                   .id = "layer") %>%
        dplyr::mutate(layer = as.integer(layer))
}

#' @name lsm_c_lpi
#' @export
lsm_c_lpi.list <- function(landscape, directions = 8) {
    purrr::map_dfr(landscape,
                   lsm_c_lpi_calc,
                   directions = directions,
                   .id = "layer") %>%
        dplyr::mutate(layer = as.integer(layer))
}

lsm_c_lpi_calc <- function(landscape, directions) {

    area_landscape <- lsm_l_ta_calc(landscape, directions = directions)

    area_patch <- lsm_p_area_calc(landscape, directions = directions)

    lpi <- dplyr::mutate(area_patch,
                         value = value / area_landscape$value * 100) %>%
        dplyr::group_by(class) %>%
        dplyr::summarise(value = max(value))

    tibble::tibble(
        level = "class",
        class = as.integer(lpi$class),
        id = as.integer(NA),
        metric = "lpi",
        value = as.double(lpi$value)
    )
}
