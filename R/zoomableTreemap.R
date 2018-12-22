#' Zoomable Treemap
#'
#' R Implementation of Mike Bostock's zoomable treemap
#'
#' @import htmlwidgets
#'
#' @export
zoomableTreemap <- function(data = flare, width = 800, height = 500, elementId = NULL) {
  data <- jsonlite::toJSON(data, pretty = T, auto_unbox = T)

  # forward options using x
  x <- list(
    data = data
  )

  # create widget
  htmlwidgets::createWidget(
    name = "zoomableTreemap",
    x,
    width = width,
    height = height,
    sizingPolicy = htmlwidgets::sizingPolicy(
      padding = 0,
      browser.fill = TRUE
      ),
    package = "d3RZoomableTreemap",
    elementId = elementId
  )
}

#' Shiny bindings for zoomableTreemap
#'
#' Output and render functions for using zoomableTreemap within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a zoomableTreemap
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name zoomableTreemap-shiny
#'
#' @export
zoomableTreemapOutput <- function(outputId, width = 800, height = 500) {
  htmlwidgets::shinyWidgetOutput(outputId, "zoomableTreemap", width, height, package = "d3RZoomableTreemap")
}

#' @rdname zoomableTreemap-shiny
#' @export
renderZoomableTreemap <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, zoomableTreemapOutput, env, quoted = TRUE)
}

