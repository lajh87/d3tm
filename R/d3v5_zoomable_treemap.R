#' D3 Zoomable Treemap
#'
#' Implementation of a d3 zoomable treemap
#'
#' @param \code{data} A json object
#' @param \code{width} Width of the widget, in pixels
#' @param \code{height} Height of the widget, in pixels
#' @param \code{elementId} Element ID used for R Shiny package
#' @param \code{background} Default background colour use if there is no color
#'     variable defined in the data. Takes hex of colour names.
#' @param \code{header_background} The background colour either named of in a hex
#'     e.g. "#bbb"
#'
#' @import htmlwidgets
#' @export
#' @examples
#' data(flare)
#' zoomable_treemap(flare)
#' zoomable_treemap(data= flare, width = 100%,
#'     background="#484848", header_background = "black")
zoomable_treemap <- function(data = jsonlite::toJSON(flare,auto_unbox=T),
                             width = "100%",
                             height = NULL,
                             elementId = NULL,
                             background = "#bbb",
                             header_background = "orange",
                             header_height = 25,
                             format_string = ","){

  # forward options using x
  x <- list(
    data = data,
    background = background,
    header_background = header_background,
    header_height = header_height,
    format_string = format_string
  )

  # create widget
  htmlwidgets::createWidget(
    name = "d3v5_zoomable_treemap",
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


#' Shiny bindings for d3v5 zoomableTreemap
#'
#' Output and render functions for using zoomableTreemap within Shiny
#' applications and interactive Rmd documents.
#'
#' The name of the clicked node is avaiable based on the object name + _clicked
#' e.g. input$treemap_clicked
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
#' @name zoomable_treemap_shiny
#'
#' @export
zoomable_treemap_output <- function(outputId, width = "100%", height = 500) {
  htmlwidgets::shinyWidgetOutput(outputId, "d3v5_zoomable_treemap", width, height, package = "d3RZoomableTreemap")
}

#' @rdname zoomable_treemap_shiny
#' @export
render_zoomable_treemap <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, zoomable_treemap_output, env, quoted = TRUE)
}
