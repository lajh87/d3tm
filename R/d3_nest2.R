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
d3_nest2 <- function(data, value_col = "value", root = "root"){

  if(!inherits(data, "data.frame")) stop("Input data must be a data.frame")

  if(value_col != "value")
    data <- data %>% dplyr::rename(value = dplyr::contains(value_col))

  nonnest_cols <- dplyr::setdiff(colnames(data), "value")
  data <- dplyr::mutate_if(data, is.factor, as.character)

  id_matrix <- sapply(nonnest_cols, function(x){
    dplyr::group_indices(data, get(x))
  })

  id_matrix <- lapply(seq_along(nonnest_cols), function(i){
    if(i == 1) {
      x <- list(id_matrix[,i])
    } else{
      x <- list(apply(id_matrix[,1:i], 1, paste, collapse = "."))
    }
    return(x)
  }) %>%
    data.frame(stringsAsFactors = F)
  names(id_matrix) <- paste0(nonnest_cols, "_id")
  id_cols <- colnames(id_matrix)

  data <- dplyr::bind_cols(id_matrix,data)

  for (i in rev(seq_along(nonnest_cols))) {
    if(i == 4){
      data_nested <- dplyr::rename(.data = data,
                                   "key" = id_cols[i],
                                   "name" = nonnest_cols[i]) %>%
        dplyr::mutate(col_name = nonnest_cols[i])

      data_nested <- tidyr::nest(data_nested, key, name,col_name, value,
                                 .key = "children")
      data_nested <-  promote_na(data_nested)
      data_nested <-  dplyr::bind_rows(data_nested)


    }else{
      data_nested <- dplyr::rename(.data = data_nested,  key = id_cols[i],
                                   name = nonnest_cols[i])
      data_nested <- tidyr::nest(data_nested, key, name, children,
                                 .key = "children")
      data_nested <-  promote_na(data_nested)
      data_nested <-  dplyr::bind_rows(data_nested)
    }
  }

  data_nested$name = root

  d3_json(data_nested, strip = TRUE)

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
      dplyr::bind_cols(x, na_child[1, setdiff(colnames(na_child), c("name", "children", "colname"))])
    x$children[[1]] <- x$children[[1]][-na_child_loc, ]
    x
  }
  else {
    x
  }
}

#'@keywords internal
#'@source d3r
#'@author kent.russell@@timelyportfolio.com
d3_json <- function(x = NULL, strip = TRUE) {
  xj <- jsonlite::toJSON(x, auto_unbox = TRUE, dataframe = "rows")
  if (strip) {
    substr(xj, 2, nchar(xj) - 1)
  }
  else {
    xj
  }
}




