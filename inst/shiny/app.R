library(shiny)
library(d3tm)

data("Titanic")
json <- data.frame(Titanic) %>%
  dplyr::select(Class,Sex,Age,Survived,Freq) %>%
  d3_nest2(id_vars = c("Class", "Age","Sex", "Survived"),
           value_col="Freq", root="Titanic")

ui <- fluidPage(
    headerPanel("Test App"),
    tags$br(),HTML("&nbsp"),
    tags$br(),
    column(
      width = 6,
      fluidRow(ztmOutput("x1",width = "100%")),
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
      ),
      fluidRow(
        actionButton("reset_click_events", "Reset Click Events")
      )),
    column(
      width = 6,
      ztmOutput("x2", width = "100%")
    )
  )


server <- function(input, output, session) {

  output$x1 <- renderZtm({
    d3tm::ztm(json, background = "#bbb", header_background = "orange")
  })

  output$x2 <- renderZtm({
    d3tm::ztm(json, background = "#bbb", header_background = "orange")
  })


  output$clicked_node_id <- renderText({input$x1_clicked_id})
  output$clicked_node_label <- renderText(input$x1_clicked_label)
  output$clicked_node_depth <- renderText({input$x1_clicked_depth})

  output$hover_node_id <- renderText({input$x1_hover_id})
  output$hover_node_label <- renderText(input$x1_hover_label)
  output$hover_node_depth <- renderText({input$x1_hover_depth})

  observeEvent(input$reset_click_events,{

    session$sendCustomMessage("resetInputValue", "x1_clicked_id")
    session$sendCustomMessage("resetInputValue", "x1_clicked_label")
    session$sendCustomMessage("resetInputValue", "x1_clicked_depth")

  })


  }

shinyApp(ui, server)
