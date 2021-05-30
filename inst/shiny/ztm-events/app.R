library(shiny)
library(d3tm)

ui <- fluidPage(
  titlePanel("Zoomable Treemap Shiny Interactions"),
  sidebarLayout(
    sidebarPanel(
      uiOutput("zoom_to_node"),
      uiOutput("highlight"),
      h4("Events"),
      tags$span(tags$label("Clicked ID: "), textOutput("ztm_1_clicked_id")),
      tags$span(tags$label("Mouseover ID: "), textOutput("ztm_1_mouseover_id")),
      actionButton("ztm_1_reset_click_events", "Reset Click Events")
      ),
    mainPanel(
      ztmOutput("ztm_1", width = "100%", height = 400)
    )
  )
)

server <- function(input, output, session) {

  output$ztm_1 <- renderZtm(ztm())
  output$ztm_1_clicked_id <- renderText(input$ztm_1_clicked_id)
  observeEvent(input$ztm_1_reset_click_events,{
    session$sendCustomMessage("resetInputValue", "ztm_1_clicked_id")
  })
  output$ztm_1_mouseover_id <- renderText(input$ztm_1_mouseover_id)


  output$zoom_to_node <- renderUI({
    tagList(
      selectInput("zoom_to_node", "Zoom to Node",input$ztm_1_children),
      actionButton("ztn_confirm", "Confirm")
      )
  })

  observeEvent(input$ztn_confirm, {session$sendCustomMessage("shinySelect", input$zoom_to_node)})

  output$highlight <- renderUI({
    selectInput("highlight", "Highlight",input$ztm_1_children)
  })

}

shinyApp(ui, server)
