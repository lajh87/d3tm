library(shiny)
library(d3RZoomableTreemap)

data("Titanic")
json <- data.frame(Titanic) %>%
  dplyr::select(Class,Sex,Age,Survived,Freq) %>%
  d3_nest2(id_vars = c("Class", "Sex", "Age"),
           value_col="Freq", root="Titanic")

ui <- fluidPage(
  sidebarLayout(
    mainPanel = mainPanel(zoomable_treemap_output("x1",width = "100%")),
    sidebarPanel = sidebarPanel(
      fluidRow(
        h4("Click Events"),
        tags$label("Clicked Node ID:"),textOutput("clicked_node_id",inline = T),
        tags$label("Clicked Node Label:"),textOutput("clicked_node_label",inline = T),
        tags$label("Clicked Node Depth:"),textOutput("clicked_node_depth",inline = T)
        ),
      fluidRow(
        h4("Hover Events"),
        tags$label("Hover Node ID:"),textOutput("hover_node_id",inline = T),
        tags$label("Hover Node Label:"),textOutput("hover_node_label",inline = T),
        tags$label("Hover Node Depth:"),textOutput("hover_node_depth",inline = T)
      )
      ),
      position = "right"
    )
  )

server <- function(input, output, session) {

  output$x1 <- render_zoomable_treemap({
    d3RZoomableTreemap::zoomable_treemap(json, background = "#bbb", header_background = "orange")
  })

  output$clicked_node_id <- renderText({input$x1_clicked_id})
  output$clicked_node_label <- renderText(input$x1_clicked_label)
  output$clicked_node_depth <- renderText({input$x1_clicked_depth})

  output$hover_node_id <- renderText({input$x1_hover_id})
  output$hover_node_label <- renderText(input$x1_hover_label)
  output$hover_node_depth <- renderText({input$x1_hover_depth})

  }

shinyApp(ui, server)
