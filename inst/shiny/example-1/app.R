library(shiny)
library(d3RZoomableTreemap)

# Using flare as have different levels and removing any json modifications
flare <- jsonlite::fromJSON(
  txt = system.file("json/flare.json",package = "d3RZoomableTreemap"),
  flatten = F, simplifyVector = F, simplifyDataFrame = F, simplifyMatrix = F
  )

ui <- fluidPage(
  sidebarLayout(
    mainPanel = mainPanel(zoomableTreemapOutput("x1")),
    sidebarPanel = sidebarPanel(
      fluidRow(
        tags$label("Selected Node:"),textOutput("selected_node",inline = T)
        )
      ),
      position = "right"
    )
  )

server <- function(input, output, session) {

  output$x1 <- renderZoomableTreemap({
    d3RZoomableTreemap::zoomableTreemap(flare)
  })

  output$selected_node <- renderText({input$x1_click})

  }

shinyApp(ui, server)
