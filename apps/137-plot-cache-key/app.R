### Keep this line to manually test this shiny application. Do not edit this line; shinycoreci::::is_manual_app


library(shiny)
dataset <- reactiveVal(data.frame(x = rnorm(400), y = rnorm(400)))

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", "Number of points to display", 50, 400, 100, step = 50),
      actionButton("newdata", "Generate new data")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output, session) {
  # When the newdata button is clicked, change the data set to new random data
  observeEvent(input$newdata, {
    dataset(data.frame(x = rnorm(400), y = rnorm(400)))
  })

  output$plot <- renderCachedPlot(
    {
      Sys.sleep(2)     # Add an artificial delay
      d <- dataset()
      rownums <- seq_len(input$n)
      plot(d$x[rownums], d$y[rownums], xlim = range(d$x), ylim = range(d$y))
    },
    cacheKeyExpr = {
      list(input$n, dataset())
    }
  )
}

shinyApp(ui, server)
