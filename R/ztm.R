#' Zoomable Treemap
#'
#' Implementation of a Mike Bostock's d3
#'  \href{https://bost.ocks.org/mike/treemap/}{zoomable treemap}
#'  as an htmlwidget in d3v5.
#'
#' @param data A json object
#' @param width Width of the widget, in pixels
#' @param height Height of the widget, in pixels
#' @param elementId Element ID used for R Shiny package
#' @param background Default background colour use if there is no color
#'     variable defined in the data. Takes hex of colour names.
#' @param header_background The background colour either named of in a hex
#'     e.g. "#bbb"
#' @param header_height Height of the title, in pixels
#' @param header_fontsize Font size of the title, in pixels
#' @param format_string D3 number format
#' @param zoom_in_helptext The help text displayed on the header bar
#' @param zoom_out_helptext Zoom out helptext
#' @param tooltip_background  Background colour of the tooltip
#' @param colnames Names of the columns (for use in the tooltip)
#'
#' @export
#' @example inst/examples/titanic.R
ztm <- function(
  data = jsonlite::toJSON(jsonlite::fromJSON(system.file("examples/flare.json",
                                         package = "d3tm"))),
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
  colnames = NULL,
  value_label = "Value"
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
    colnames = colnames,
    value_label = value_label
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
    package = "d3tm",
    elementId = elementId
  )

}


#' Shiny Bindings for Zoomable Treemap
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
#' ztm objects send input values to Shiny as the user interacts
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
#' \itemize{
#' \item \code{input$OBJECTID_clicked_id}
#' \item \code{input$OBJECTID_clicked_depth}
#' \item \code{input$OBJECTID_clicked_label}
#' \item \code{input$OBJECTID_hover_parent_index}
#' \item \code{input$OBJECTID_hover_parent_depth}
#' \item \code{input$OBJECTID_hover_parent_label}
#' \item \code{input$OBJECTID_hover_child_index}
#' \item \code{input$OBJECTID_hover_child_depth}
#' \item \code{input$OBJECTID_hover_child_label}
#' }
#'
#' If an event has not been triggered it is set to \code{NULL}.
#'
#' Variables can be reset by sending a custom message in Shiny using:
#'
#' \code{session$sendCustomMessage("resetInputValue", "OBJECTID_clicked_id")}
#'
#' @name ztmShiny
#'
#' @export
ztmOutput <- function(outputId, width = "100%", height = 500) {
  htmlwidgets::shinyWidgetOutput(outputId, "d3v5_zoomable_treemap", width, height,
                                 package = "d3tm")
}

#' @rdname ztmShiny
#' @export
renderZtm <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, ztmOutput, env, quoted = TRUE)
}


