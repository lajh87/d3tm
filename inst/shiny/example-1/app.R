library(shiny)
library(d3RZoomableTreemap)
library(data.tree)

data(flare)
# tree <- data.tree::FromListExplicit(flare,check = "no-warn")
# tree$Set(color = "#98F6B3")
# flare <- ToListExplicit(tree,unname = TRUE,nameName = "name",childrenName = "children")

ui <- fluidPage(
  sidebarLayout(
    mainPanel = mainPanel(zoomable_treemap_output("x1",width = "100%", height=500)),
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
    d3RZoomableTreemap::zoomable_treemap(flare)
  })

  output$selected_node <- renderText({input$x1_click})

  }

shinyApp(ui, server)
