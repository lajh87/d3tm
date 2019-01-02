library(fscm)
library(d3RZoomableTreemap)

data(fscm)

fscm_lng <- fscm %>%
  tidyr::gather( "year", "value", `2016`:`2065`,na.rm=TRUE) %>%
  dplyr::mutate(year = as.numeric(year))

input <- list(year_range = c(2016, 2026),
              tlb = c("Centre", "Navy", "Land","Air","JFC", "DE&S",
                      "DIO", "W Pensions"),
              cost_type = c("Adj", "Infra", "EPP","ESP", "MPW","NonEP"),
              quantity_type = c("GFE", "Shared", "Overhead"))

filteredData <- fscm_lng %>%
  dplyr::filter(year >= input$year_range[1]
                & year <= input$year_range[2]) %>%
  dplyr::filter(tlb %in% input$tlb) %>%
  dplyr::filter(costtypel2 %in% input$cost_type) %>%
  dplyr::filter(quantity_type %in% input$quantity_type)

costSquaresData <- filteredData %>%
  dplyr::group_by(domain, category, element_name, level5_detail) %>%
  dplyr::summarise(value = sum(value))



data = costSquaresData
value_cols = "value"
root = "root"

json <- d3_nest2(data = data,
                 value_cols = value_cols,
                 root = root)

d3RZoomableTreemap::zoomable_treemap(
  data = json,format_string = "$.3s",
  header_background = "orange",
  header_height = 25,
  zoom_in_helptext = "",
  zoom_out_helptext = ""
)


zoomable_treemap()

