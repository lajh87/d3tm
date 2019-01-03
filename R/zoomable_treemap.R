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
#' @param \code{header_height} header height, in pixels
#' @param \code{header_fontsize} header fontsize, pixels
#' @param \code{format_string} d3 number format
#' @param \code{zoom_in_helptext} zoom in helptext
#' @param \code{zoom_out_helptext} zoom out helptext
#' @param \code{tooltip_background} tooltip background colour
#'
#' @export
#' @example inst/examples/flare.R
zoomable_treemap <- function(
  data = jsonlite::toJSON(jsonlite::fromJSON(system.file("examples/flare.json",
                                         package = "d3RZoomableTreemap"))),
  width = "100%",
  height = NULL,
  elementId = NULL,
  background = "#bbb",
  header_background = "orange",
  header_height = 25,
  header_fontsize = "12px",
  format_string = ",",
  zoom_in_helptext = " - Click on a Square to Zoom",
  zoom_out_helptext = " - Click here to Zoom Out",
  tooltip_background = "orange",
  rmarkdown = FALSE
){

  # forward options using x
  x <- list(
    data = data,
    background = background,
    header_background = header_background,
    header_height = header_height,
    header_fontsize = header_fontsize,
    format_string = format_string,
    zoom_in_helptext = zoom_in_helptext,
    zoom_out_helptext = zoom_out_helptext,
    tooltip_background = tooltip_background,
    rmarkdown = rmarkdown
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


#' Shiny bindings for zoomable treemap
#'
#' Output and render functions for using zoomable treemap within Shiny
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
#' @details
#'
#' zoomable_treemap objects send input values to Shiny as the user interacts
#' with them.
#'
#' Object input names generally use this pattern:
#'
#' \code{input$OBJECTID_EVENT_OBJCATEGORY}
#'
#' So for \code{zoomable_treemap_output("ztm")} clicking on a square would
#' return the name of the node to \code{input$ztm_clicked_label}.
#'
#' The full list of current supported events are:
#'
#' \code{input$OBJECTID_clicked_id}
#' \code{input$OBJECTID_clicked_depth}
#' \code{input$OBJECTID_clicked_label}
#' \code{input$OBJECTID_hover_id}
#' \code{input$OBJECTID_hover_depth}
#' \code{input$OBJECTID_hover_label}
#'
#' If an event has not been triggered it is set to \code{NULL}.
#'
#' @name zoomable_treemap_shiny
#'
#' @export
zoomable_treemap_output <- function(outputId, width = "100%", height = 500) {
  htmlwidgets::shinyWidgetOutput(outputId, "d3v5_zoomable_treemap", width, height,
                                 package = "d3RZoomableTreemap")
}

#' @rdname zoomable_treemap_shiny
#' @export
render_zoomable_treemap <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, zoomable_treemap_output, env, quoted = TRUE)
}
