library(shiny)
library(d3RZoomableTreemap)
library(data.tree)

data(flare)

ui <- fluidPage(
  sidebarLayout(
    mainPanel = mainPanel(zoomable_treemap_output("x1",width = "100%")),
    sidebarPanel = sidebarPanel(
      fluidRow(
        tags$label("Selected Node:"),textOutput("selected_node",inline = T)
        )
      ),
      position = "right"
    )
  )

server <- function(input, output, session) {

  output$x1 <- render_zoomable_treemap({
    d3RZoomableTreemap::zoomable_treemap(flare, background = "#bbb", header_background = "orange")
  })

  output$selected_node <- renderText({input$x1_click})

  }

shinyApp(ui, server)
