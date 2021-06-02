library(shiny)
library(d3tm)

ui <- fluidPage(
  titlePanel("Zoomable Treemap Shiny Interactions"),
  sidebarLayout(
    sidebarPanel(
      uiOutput("zoom2node"),
      h4("Events"),

      tags$br(),
      tags$span(tags$b("Clicked ID: "),
                textOutput("ztm_1_clicked_id",inline = TRUE)),
      tags$br(),
      tags$span(tags$b("Clicked Depth: "),
                textOutput("ztm_1_clicked_depth",inline = TRUE)),
      tags$br(),
      tags$span(tags$b("Mouseover ID: "),
                textOutput("ztm_1_mouseover_id",inline = TRUE)),
      tags$br(),
      tags$span(tags$label("Children:")),
      tags$br(),
      textOutput("ztm_1_children"),
      tags$br(),
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
  output$ztm_1_clicked_depth <- renderText(input$ztm_1_clicked_depth)
  observeEvent(input$ztm_1_reset_click_events,{
    session$sendCustomMessage("resetInputValue", "ztm_1_clicked_id")
    session$sendCustomMessage("resetInputValue", "ztm_1_clicked_depth")
  })
  output$ztm_1_mouseover_id <- renderText(input$ztm_1_mouseover_id)
  output$ztm_1_children <- renderText(input$ztm_1_children)

  output$zoom2node <- renderUI({
    tagList(selectInput("z2node", "Zoom to Node", input$ztm_1_data_ids),
    actionButton("ztnode_confirm", "Go"))
  })

  observeEvent(input$ztnode_confirm,{
    session$sendCustomMessage("zoom2node", input$z2node)
  })
}

shinyApp(ui, server)
