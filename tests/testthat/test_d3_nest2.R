context("d3_nest")
test_that("Check output is json",{
  input <- data.frame(Titanic) %>%
    dplyr::select(Class,Age,Survived,Sex,Freq) %>%
    d3_nest2(value_col="Freq", root="Titanic")
  expect_is(input, "json")
})


