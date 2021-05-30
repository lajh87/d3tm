library(shiny)
library(d3tm)

ui <- fluidPage(
  titlePanel("Zoomable Treemap Shiny Interactions"),
  sidebarLayout(
    sidebarPanel(
      uiOutput("zoom_to_node"),
      uiOutput("highlight"),
      h4("Events"),
      actionButton("ztm_1_reset_click_events", "Resest Click Events"),
      tags$br(),
      tags$span(tags$b("Clicked ID: "),
                textOutput("ztm_1_clicked_id",inline = TRUE)),
      tags$br(),
      tags$span(tags$b("Mouseover ID: "),
                textOutput("ztm_1_mouseover_id",inline = TRUE)),
      tags$br(),
      tags$span(tags$label("Children")),
      tags$br(),
      textOutput("ztm_1_children")
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
  output$ztm_1_children <- renderText(input$ztm_1_children)
}

shinyApp(ui, server)
