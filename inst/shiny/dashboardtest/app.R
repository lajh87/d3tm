library(shiny)
library(shinydashboard)
ui <- dashboardPage(dashboardHeader(title = "Zoomable Treemap"),
                    dashboardSidebar(disable = TRUE),
                    dashboardBody(fluidRow(
                      box(title = "Zoomable Treemap",
                          ztmOutput("ztm_1", height = 400)))
                    ))

server <- function(input, output, session) {

  output$ztm_1 <- renderZtm(ztm())

}

shinyApp(ui, server)
