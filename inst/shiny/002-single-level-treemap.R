library(shiny)
library(tidyverse)
library(d3tm)


json <- data.frame(Titanic) %>%
  dplyr::select(Class, Freq) %>%
  dplyr::group_by(Class) %>%
  dplyr::summarise(Freq = sum(Freq)) %>%
  d3_nest2(value_col="Freq", root="Titanic")



ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(tableOutput("data")),
    mainPanel(ztmOutput("treemap"))
  )
)

server <- function(input, output, session) {

  output$treemap <- renderZtm(ztm(json))

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
