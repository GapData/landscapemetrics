#' Show patches
#'
#' @description Show patches
#'
#' @param landscape *Raster object
#' @param directions The number of directions in which patches should be
#' connected: 4 (rook's case) or 8 (queen's case).
#'
#' @details The functions plots the landscape with the patches labeled with the
#' corresponding patch id.
#'
#' @return ggplot
#'
#' @examples
#' show_patches(landscape)
#'
#' @aliases show_patches
#' @rdname show_patches
#'
#' @export
show_patches <- function(landscape, directions)  UseMethod("show_patches")

#' @name show_patches
#' @export
show_patches.RasterLayer <- function(landscape, directions = 8) {
    show_patches_intern(landscape, directions = directions)
}

#' @name show_patches
#' @export
show_patches.RasterStack <- function(landscape, directions = 8) {
    purrr::map(raster::as.list(landscape), show_patches_intern,
               directions = directions)
}

#' @name show_patches
#' @export
show_patches.RasterBrick <- function(landscape, directions = 8) {
    purrr::map(raster::as.list(landscape), show_patches_intern,
               directions = directions)
}

#' @name show_patches
#' @export
show_patches.list <- function(landscape, directions = 8) {
    purrr::map(landscape, show_patches_intern,
               directions = directions)
}

show_patches_intern <- function(landscape, directions) {

    landscape_labeled <- get_patches(landscape, directions = directions)

    for(i in seq_len(length(landscape_labeled) - 1)){
        max_patch_id <- landscape_labeled[[i]] %>%
            raster::values() %>%
            max(na.rm = TRUE)

        landscape_labeled[[i + 1]] <- landscape_labeled[[i + 1]] + max_patch_id
    }

    landscape_labeled_stack <- landscape_labeled %>%
        raster::stack() %>%
        sum(na.rm = TRUE) %>%
        raster::as.data.frame(xy = TRUE) %>%
        purrr::set_names("x", "y", "values") %>%
        dplyr::mutate(values = replace(values, values == 0, NA))

    plot <- ggplot2::ggplot(landscape_labeled_stack) +
        ggplot2::geom_tile(ggplot2::aes(x = x, y = y, fill = values)) +
        ggplot2::geom_text(ggplot2::aes(x = x, y = y, label = values),
                           colour = "white") +
        ggplot2::coord_equal() +
        ggplot2::theme_void() +
        ggplot2::guides(fill = FALSE) +
        ggplot2::scale_fill_gradientn(
            colours = c(
                "#5F4690",
                "#1D6996",
                "#38A6A5",
                "#0F8554",
                "#73AF48",
                "#EDAD08",
                "#E17C05",
                "#CC503E",
                "#94346E",
                "#6F4070",
                "#994E95",
                "#666666"
                ),
            na.value = "grey75") +
        ggplot2::theme(axis.title = ggplot2::element_blank(),
                       axis.line = ggplot2::element_blank(),
                       axis.text.x = ggplot2::element_blank(),
                       axis.text.y = ggplot2::element_blank(),
                       axis.ticks = ggplot2::element_blank(),
                       axis.title.x = ggplot2::element_blank(),
                       axis.title.y = ggplot2::element_blank(),
                       axis.ticks.length = ggplot2::unit(0, "lines"),
                       legend.position = "none",
                       panel.background = ggplot2::element_blank(),
                       panel.border = ggplot2::element_blank(),
                       panel.grid.major = ggplot2::element_blank(),
                       panel.grid.minor = ggplot2::element_blank(),
                       panel.spacing = ggplot2::unit(0, "lines"),
                       plot.background = ggplot2::element_blank(),
                       plot.margin = ggplot2::unit(c(-1, -1, -1.5, -1.5), "lines")) +
        ggplot2::labs(x = NULL, y = NULL)

    return(plot)
}
