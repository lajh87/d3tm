library(shiny)
library(d3tm)

data("Titanic")
json <- data.frame(Titanic) %>%
  dplyr::select(Class,Sex,Age,Survived,Freq) %>%
  d3_nest2(value_col="Freq", root="Titanic")

ui <- fluidPage(
    headerPanel("Test App"),
    tags$br(),HTML("&nbsp"),
    tags$br(),
    column(
      width = 6,
      fluidRow(ztmOutput("x1",width = "100%")),
      fluidRow(
        h4("Click Events"),
        tags$label("Click Index:"), textOutput("x1_clicked_child_index",inline = T),
        tags$label("Click Label:"), textOutput("x1_clicked_child_label",inline = T),
        tags$label("Click Depth:"), textOutput("x1_clicked_child_depth",inline = T)

      ),
      fluidRow(
        h4("Hover Events"),
        tags$label("Parent Hover Index:"), textOutput("x1_hover_parent_index",inline = T),
        tags$label("Parent Hover Label:"), textOutput("x1_hover_parent_label",inline = T),
        tags$label("Parent Hover Depth:"), textOutput("x1_hover_parent_depth",inline = T),
        tags$br(),
        tags$label("Child Hover Index:"), textOutput("x1_hover_child_index", inline = T),
        tags$label("Child Hover Label:"), textOutput("x1_hover_child_label",inline = T),
        tags$label("Child Hover Depth:"), textOutput("x1_hover_child_depth",inline = T)
      ),
      fluidRow(
        actionButton("x1_reset_click_events", "Reset Click Events")
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

  output$x1_clicked_child_index <- renderText(input$x1_clicked_child_index)
  output$x1_clicked_child_label <- renderText(input$x1_clicked_child_label)
  output$x1_clicked_child_depth <- renderText({input$x1_clicked_child_depth})

  output$x1_hover_child_index <- renderText(input$x1_hover_child_index)
  output$x1_hover_child_label <- renderText(input$x1_hover_child_label)
  output$x1_hover_child_depth <- renderText({input$x1_hover_child_depth})

  output$x1_hover_parent_index <- renderText(input$x1_hover_parent_index)
  output$x1_hover_parent_label <- renderText(input$x1_hover_parent_label)
  output$x1_hover_parent_depth <- renderText({input$x1_hover_parent_depth})

  observeEvent(input$x1_reset_click_events,{
    session$sendCustomMessage("resetInputValue", "x1_clicked_child_index")
    session$sendCustomMessage("resetInputValue", "x1_clicked_child_label")
    session$sendCustomMessage("resetInputValue", "x1_clicked_child_depth")


  })


  output$x2 <- renderZtm({
    d3tm::ztm(json, background = "#bbb", header_background = "orange")
  })



  }

shinyApp(ui, server)
