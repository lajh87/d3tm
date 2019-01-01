#' Convert a data.frame to a 'd3.js' Hierarchy
#'
#' Based on the timely portfolio code but with improved performance enhancements
#'
#' @param data A data frame input
#' @param value_cols The value columns
#' @param root The root of the tree name
#'
#' @return A json character vector
#' @export
#'
#' @examples
#' titanic_df <- data.frame(Titanic)
#' tit_tb <- titanic_df %>%
#' select(Class,Age,Survived,Sex,Freq) %>%
#'  d3_nest2(value_cols="Freq", root="titanic")
d3_nest2 <- function(data = data, value_cols = value_cols, root = root){
  data <- dplyr::mutate_if(data, is.factor, as.character)
  nonnest_cols <- dplyr::setdiff(colnames(data), value_cols)

  data_nested <- dplyr::rename(.data = data,  "name" = nonnest_cols[length(nonnest_cols)])
  data_nested <- tidyr::nest(data_nested, name , value_cols, .key = "children")
  data_nested <-  promote_na(data_nested)
  data_nested <-  dplyr::bind_rows(data_nested)
  nonnest_cols <- nonnest_cols[-length(nonnest_cols)]

  # if slow memoise
  # https://adv-r.hadley.nz/function-operators.html
  for (x in rev(nonnest_cols)) {
    data_nested <- dplyr::rename(.data = data_nested,  "name" = x)
    data_nested <- tidyr::nest(data_nested, name:children, .key = "children")
    data_nested <-  promote_na(data_nested)
    data_nested <-  dplyr::bind_rows(data_nested)
  }

  data_nested$name = root

  json <- d3r::d3_json(data_nested, strip = TRUE)
}

#'@keywords internal
#'@source d3r
promote_na <- function(x){
  lapply(seq_len(nrow(x)), function(row) {
    promote_na_one(x[row, ])
  })
}

#'@keywords internal
#'@source d3r
#'@author kent.russell@@timelyportfolio.com
promote_na_one <- function(x){
  na_child_loc <- which(is.na(x$children[[1]]$name))
  if (length(na_child_loc)) {
    na_child <- x$children[[1]][na_child_loc, ]
    x <- dplyr::bind_cols(x, na_child[1, setdiff(colnames(na_child), c("name", "children", "colname"))])
    x$children[[1]] <- x$children[[1]][-na_child_loc, ]
    x
  }
  else {
    x
  }
}



