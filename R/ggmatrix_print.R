
ggplot2_set_last_plot <- utils::getFromNamespace("set_last_plot", "ggplot2")

#' Print ggpair object
#'
#' Print method taken from \code{ggplot2:::print.ggplot} and altered for a ggmatrix object
#'
#' @param x plot to display
#' @param newpage draw new (empty) page first?
#' @param vp viewport to draw plot in
#' @param ... arguments passed onto ggmatrix_gtable
#' @method print ggmatrix
#' @author Barret Schloerke
#' @import utils
#' @importFrom grid grid.newpage grid.draw seekViewport pushViewport upViewport
#' @export
#' @examples
#'  data(tips, package = "reshape")
#'  pMat <- ggpairs(tips, c(1,3,2), mapping = ggplot2::aes_string(color = "sex"))
#'  pMat # calls print(pMat), which calls print.ggmatrix(pMat)
print.ggmatrix <- function (x, newpage = is.null(vp), vp = NULL, ...,
                            labeller = NULL) {
  if (is.null(labeller)) {
    labeller <- 'label_value'
  }
  if (newpage) {
    grid.newpage()
  }
  grDevices::recordGraphics(requireNamespace("jgally", quietly = TRUE),
      list(), getNamespace("jgally"))
  gtable <- ggmatrix_gtable(x, labeller = labeller, ...)

  # must be done after gtable, as gtable calls many ggplot2::print.ggplot methods
  ggplot2_set_last_plot(x)

  if (is.null(vp)) {
    grid.draw(gtable)
  } else {
    if (is.character(vp)) {
      seekViewport(vp)
    } else {
      pushViewport(vp)
    }
    grid.draw(gtable)
    upViewport()
  }
  invisible(data)
}




#' Is Blank Plot?
#' Find out if the plot equals a blank plot
#'
#' @keywords internal
#' @examples
#'  jgally:::is_blank_plot(ggally_blank())
#'  jgally:::is_blank_plot(ggally_points(mtcars, ggplot2::aes_string(x = "disp", y = "hp")))
#'
is_blank_plot <- function(p){
  is.null(p) || identical(p, "blank") || inherits(p, "ggmatrix_blank")
}
