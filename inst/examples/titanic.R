data.frame(Titanic) %>%
 dplyr::select(Class,Age,Survived,Sex,Freq) %>%
  d3_nest2(value_col="Freq", root="Titanic",
           id_vars = c("Class", "Age", "Survived", "Sex")) %>%
  zoomable_treemap()

