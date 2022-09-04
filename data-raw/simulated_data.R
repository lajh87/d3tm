library(rnaturalearth)
library(d3tm)

ne_countries()@data |>
  dplyr::select(region_un, subregion,country = name, value = pop_est) |>
  dplyr::mutate(path = paste(region_un, subregion, country, sep = "/")) |>
  df_to_tree() |>
  ztm()
