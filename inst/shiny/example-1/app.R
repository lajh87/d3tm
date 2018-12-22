library(shiny)
library(d3RZoomableTreemap)

data(flare)

ui <- fluidPage(
  sidebarLayout(
    mainPanel = mainPanel(zoomableTreemapOutput("x1",width = "100%", height=500)),
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
