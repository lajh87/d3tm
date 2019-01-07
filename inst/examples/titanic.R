data.frame(Titanic) %>%
 dplyr::select(Class,Age,Survived,Sex,Freq) %>%
  d3_nest2(value_col="Freq", root="Titanic") %>%
  ztm()

