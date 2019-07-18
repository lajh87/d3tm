library(shiny)
library(tidyverse)
library(d3tm)


# Build Data
json <- data.frame(Titanic) %>%
  dplyr::select(Class, Freq) %>%
  dplyr::group_by(Class) %>%
  dplyr::summarise(value = sum(Freq)) %>%
  d3_nest2(root = "Titanic Passengers")

json <- jsonlite::fromJSON(json)
json$children$color <- c("#FF5733","#FF5733","#FF5733", "#000")
json <- jsonlite::toJSON(json,auto_unbox = TRUE,dataframe = "rows")


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(tableOutput("data")),
    mainPanel(tmOutput("treemap"))
  )
)

server <- function(input, output, session) {

  output$treemap <- renderTm(tm(json))

  data <- reactiveValues(events = data.frame(Click = NA, Hover = NA))

  observe({
    data$events$Click <-input$treemap_clicked_label
    data$events$Hover <- input$treemap_hover_child_label
  })
  output$data <- renderTable({
    data$events
  })


}

shinyApp(ui, server)
