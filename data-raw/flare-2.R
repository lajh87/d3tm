flare_2 <- jsonlite::read_json("inst/json/flare-2.json")

## This uses recursive programming technique where a function is called within a function.

return_name <- function(data = flare_2){
  print(data$name)
  if(!is.null(data$children)){
    for(child in data$children)
      return_name(child)
  }
}

return_node <- function(data = flare_2, value = "SortOperator", key = "name"){
  if(data[key] == value) return(print(data)) else{
    if(!is.null(data$children))
      for(child in data$children){
        return_node(child, value, key)
      }
  }
}


return_name()
return_node(value = "Blah")
