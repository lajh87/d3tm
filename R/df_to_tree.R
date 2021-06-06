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
#' data.frame(path = c("1/A", "1/B/i", "1/B/ii", "2A"), value = 1:4)
#' df_to_tree(df)
df_to_tree <- function(df, stringPath = "path", stringSep = "/",
                       value_from = "value", root_name = "root"){

  l <- strsplit(df[, stringPath], stringSep)
  value <- df[, value_from]

  filter_children <- function(l, j = 1, parent) {

    children <- do.call(rbind, purrr::map(l, function(x){
      if(j == 1) x[j] else
        if(x[j-1] == parent) x[j]
    })) %>% as.character() %>% unique()

    values <- do.call(rbind, purrr::map(1:length(l), function(i){

      if(j == 1){
        data.frame(name = l[[i]][j],
                   value = value[i],
                   stringsAsFactors = FALSE)
      }

      if(j>1 && l[[i]][j-1] == parent)
        if(length(l[[i]]) == j)
          data.frame(name = l[[i]][j],
                     value = value[i],
                     stringsAsFactors = FALSE)
    }))

    purrr::map(children, function(child){
      if(has_children(l, j, child)){
        list(name = child, children = filter_children(l, j+1, child))
      } else
        list(name = child, value = values$value[values$name == child])
    })
  }

  has_children <- function(l, level, child){
    children <- purrr::map(l, function(x){
      if(!is.na(x[level]))
        if(x[level]==child) has_child = !is.na(x[level+1])
    })
    do.call(rbind, children) %>% as.logical() %>% unique()
  }

  list(name = root_name, children = filter_children(l))

}
