#' Zoomable Treemap
#'
#' A Zoomable Treemap Capable of Handling Unbalanced Hierarchical Data
#'
#' @import htmlwidgets
#'
#' @export
#' @examples \dontrun{ztm()}
ztm <- function(data = jsonlite::read_json(system.file("json/flare-2.json", package = "d3tm")),
                width = "100%", height = 400, elementId = NULL) {

  # forward options using x
  x = list(
    data = data
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'ztm',
    x,
    width = width,
    height = height,
    package = 'd3tm',
    elementId = elementId
  )
}

#' Shiny bindings for ztm
#'
#' Output and render functions for using ztm within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a ztm
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name ztm-shiny
#'
#' @export
ztmOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'ztm', width, height, package = 'd3tm')
}

#' @rdname ztm-shiny
#' @export
renderZtm <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, ztmOutput, env, quoted = TRUE)
}
