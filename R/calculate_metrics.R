#' Calculate metrics
#'
#' @description Calculate all metrics of level
#'
#' @param landscape Raster* Layer, Stack, Brick or a list of rasterLayers.
#'
#' @return tibble
#'
#' @examples
#' calculate_metrics(landscape)
#' calculate_metrics(landscape_stack, what = "patch")
#'
#' @aliases calculate_metrics
#' @rdname calculate_metrics
#'
#' @references
#' McGarigal, K., and B. J. Marks. 1995. FRAGSTATS: spatial pattern analysis
#' program for quantifying landscape structure. USDA For. Serv. Gen. Tech. Rep.
#'  PNW-351.
#' @export
calculate_metrics <- function(landscape, what, ...) UseMethod("calculate_metrics")

#' @name calculate_metrics
#' @export
calculate_metrics.RasterLayer <- function(landscape, what = "all", ...) {

    calculate_metrics_internal(landscape, what = what, ...)

}

#' @name calculate_metrics
#' @export
calculate_metrics.RasterStack <- function(landscape, what = "all", ...) {
    purrr::map_dfr(raster::as.list(landscape), calculate_metrics_internal,
                   what = what) %>%
        dplyr::mutate(layer = as.integer(layer))
}

#' @name calculate_metrics
#' @export
calculate_metrics.RasterBrick <- function(landscape, what = "all", ...) {
    purrr::map_dfr(raster::as.list(landscape), calculate_metrics_internal,
                   what = what) %>%
        dplyr::mutate(layer = as.integer(layer))
}

#' @name calculate_metrics
#' @export
calculate_metrics.list <- function(landscape, what = "all", ...) {
    purrr::map_dfr(landscape, calculate_metrics_internal,
                   what = what) %>%
        dplyr::mutate(layer = as.integer(layer))
}

calculate_metrics_internal <- function(landscape, what = "all", ...) {
    # level <- "lsm"
    # lsf.str("package:landscapemetrics") %>%
    #     grep(pattern = level, x = ., value = TRUE) %>%
    #     grep(pattern = "\\.|calc", x = ., value = TRUE, invert = TRUE)


    if(what == "all") {


        result <- dplyr::bind_rows(
            lsm_p_area(landscape),
            lsm_p_perim(landscape),
            lsm_p_para(landscape),
            lsm_p_enn(landscape),

            lsm_c_ta(landscape),
            lsm_c_area_mn(landscape),
            lsm_c_area_cv(landscape),
            lsm_c_area_sd(landscape),
            lsm_c_pland(landscape),
            lsm_c_lpi(landscape),
            lsm_c_te(landscape),
            lsm_c_np(landscape),
            lsm_c_enn_mn(landscape),

            lsm_l_ta(landscape),
            lsm_l_area_mn(landscape),
            lsm_l_area_cv(landscape),
            lsm_l_area_sd(landscape),
            lsm_l_lpi(landscape),
            lsm_l_te(landscape),
            lsm_l_np(landscape),
            lsm_l_pr(landscape),
            lsm_l_prd(landscape),
            lsm_l_rpr(landscape, classes_max = ...),
            lsm_l_enn_mn(landscape),
            lsm_l_shei(landscape),
            lsm_l_shdi(landscape)
        )
    }

    if(what == "patch"){
        result <- dplyr::bind_rows(
            lsm_p_area(landscape),
            lsm_p_perim(landscape),
            lsm_p_para(landscape),
            lsm_p_enn(landscape)
        )
    }

    else if(what == "class"){
        result <- dplyr::bind_rows(
            lsm_c_ta(landscape),
            lsm_c_area_mn(landscape),
            lsm_c_area_cv(landscape),
            lsm_c_area_sd(landscape),
            lsm_c_pland(landscape),
            lsm_c_lpi(landscape),
            lsm_c_te(landscape),
            lsm_c_np(landscape),
            lsm_c_enn_mn(landscape)
        )

    }

    else if(what == "landscape"){
        result <- dplyr::bind_rows(
            lsm_l_ta(landscape),
            lsm_l_area_mn(landscape),
            lsm_l_area_cv(landscape),
            lsm_l_area_sd(landscape),
            lsm_l_lpi(landscape),
            lsm_l_te(landscape),
            lsm_l_np(landscape),
            lsm_l_pr(landscape),
            lsm_l_prd(landscape),
            lsm_l_rpr(landscape, classes_max = NULL),
            lsm_l_enn_mn(landscape),
            lsm_l_shei(landscape),
            lsm_l_shdi(landscape)
        )
    }
    return(result)
}