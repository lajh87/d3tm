#' DF to Tree
#'
#' Convert a data.frame to a list of names and nested children with values
#'
#' @param df A data frame
#' @param stringPath The name of the string
#' @param stringSep The separator (defaults to "/")
#' @param value_from The name of the value (Defaults to "value")
#' @param root_name The name of the root (Defaults to "root")
#'
#' @return A list of 2: name and list of n children. The leaf nodes return
#'   name and value
#' @export
#'
#' @examples
#' library(d3tm)
#' df <- data.frame(path = c("1/A", "1/B/i", "1/B/ii", "2/A", 3), value = 1:5)
#' df_to_tree(df)
df_to_tree <- function(df, stringPath = "path", stringSep = "/",
                       value_from = "value", root_name = "root"){

  l <- strsplit(df[, stringPath], stringSep)
  value <- df[, value_from]

  filter_children <- function(l, j = 1, parent) {

    ## Extract a unique vector of children names for a given level and parent
    children <- do.call(rbind, purrr::map(l, function(x){
      if(j == 1) x[j] else
        if(!is.na(x[j-1]) && x[j-1] == parent)  x[j]
    })) %>% as.character() %>% unique()

    ## Extract the leaf values and associated child's name for a given parent
    values <- do.call(rbind, purrr::map(1:length(l), function(i){

      if(length(l[[i]]) == j){
        if(j==1){
          data.frame(name = l[[i]][j],
                     value = value[i],
                     stringsAsFactors = FALSE)
        } else{
          if(l[[i]][j-1] == parent){
            data.frame(name = l[[i]][j],
                       value = value[i],
                       stringsAsFactors = FALSE)
          }
        }
      }
    }))

    ## Loop through children and for each child if they have children then
    ##  extract children recursively. If not the extract the leaf values.
    purrr::map(children, function(child){
      if(has_children(l, j, child)){
        list(name = child, children = filter_children(l, j+1, child))
      } else
        list(name = child, value = values$value[values$name == child])
    })
  }

  ## Check if a given child has children of their own.
  has_children <- function(l, level, child){
    children <- purrr::map(l, function(x){
      if(!is.na(x[level]))
        if(x[level]==child) has_child = !is.na(x[level+1])
    })
    do.call(rbind, children) %>% as.logical() %>% unique()
  }

  list(name = root_name, children = filter_children(l))

}
