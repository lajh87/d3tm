#' Convert a data.frame to a 'd3.js' Hierarchy
#'
#' @param data A data frame
#' @param value_col The name of the value column in the data frame
#' @param root The name of the root
#'
#' @return Serialised json
#' @export
#'
#' @example inst/examples/titanic.R
d3_nest2 <- function(data,  value_col = "value", root = "root"){

  if(!inherits(data, "data.frame"))
    stop("Input data must be a data.frame")

  data <- as.data.frame(data)

  if(value_col != "value")
    data <- data %>% dplyr::rename(value = dplyr::contains(value_col))
  data <- dplyr::mutate_if(data, is.factor, as.character)
  nonnest_cols <- dplyr::setdiff(colnames(data), "value")


  for (i in rev(seq_along(nonnest_cols))) {
    if(i == length(nonnest_cols)){
      data_nested <- dplyr::rename(.data = data,
                                   "name" = nonnest_cols[i])

      data_nested <- tidyr::nest(data_nested, "name","value",
                                 .key = "children")
      data_nested <-  promote_na(data_nested)
      data_nested <-  dplyr::bind_rows(data_nested)


    }else{
      data_nested <- dplyr::rename(.data = data_nested,
                                   "name" = nonnest_cols[i])

      data_nested <- tidyr::nest(data_nested, "name", "children",
                                 .key = "children")
      data_nested <-  promote_na(data_nested)
      data_nested <-  dplyr::bind_rows(data_nested)
    }
  }

  data_nested$name = root

  xj <- jsonlite::toJSON(data_nested, auto_unbox = TRUE, dataframe = "rows")

  return(substr(xj, 2, nchar(xj) - 1))
}

#'@keywords internal
#'@source d3r
#'@author kent.russell@@timelyportfolio.com
promote_na <- function(x) {
  lapply(seq_len(nrow(x)), function(row) {
    promote_na_one(x[row, ])
  })
}

#'@keywords internal
#'@source d3r
#'@author kent.russell@@timelyportfolio.com
promote_na_one <- function(x) {
  na_child_loc <- which(is.na(x$children[[1]]$name))
  if (length(na_child_loc)) {
    na_child <- x$children[[1]][na_child_loc, ]
    x <-
      dplyr::bind_cols(x, na_child[1, setdiff(colnames(na_child),
                                              c("name", "children", "colname"))])
    x$children[[1]] <- x$children[[1]][-na_child_loc, ]
    x
  }
  else {
    x
  }
}


