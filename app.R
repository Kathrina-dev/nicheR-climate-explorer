library(shiny)
library(shinythemes)
library(terra)
library(geodata)

ui <- fluidPage(
  theme = shinytheme("darkly"),
  titlePanel("🌍 Climate Data Explorer"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("region", "Select Region",
                  choices = c("South America", "Africa", "Asia")),
      
      actionButton("run", "Run Workflow"),
      
      br(), br(),
      verbatimTextOutput("status")
    ),
    
    mainPanel(
      h3("Global BIO Data"),
      plotOutput("plot_full"),
      
      h3("BIO1 Layer"),
      plotOutput("plot_bio1"),
      
      h3("Cropped Region"),
      plotOutput("plot_crop"),
      
      h3("Final Masked Output"),
      plotOutput("plot_mask")
    )
  )
)

server <- function(input, output) {
  
  data <- eventReactive(input$run, {
    
    clim <- worldclim_global(var = "bio", res = 10, path = "data")
    bio1 <- clim[[1]]
    
    ext_val <- switch(input$region,
                      "South America" = ext(-90, -30, -60, 15),
                      "Africa" = ext(-20, 50, -35, 35),
                      "Asia" = ext(60, 150, 5, 55)
    )
    
    cropped <- crop(bio1, ext_val)
    
    # simple mask (just for demo)
    masked <- mask(cropped, cropped)
    
    list(
      full = clim,
      bio1 = bio1,
      cropped = cropped,
      masked = masked
    )
  })
  
  output$plot_full <- renderPlot({
    req(data())
    plot(data()$full)
  })
  
  output$plot_bio1 <- renderPlot({
    req(data())
    plot(data()$bio1)
  })
  
  output$plot_crop <- renderPlot({
    req(data())
    plot(data()$cropped)
  })
  
  output$plot_mask <- renderPlot({
    req(data())
    plot(data()$masked)
  })
  
  output$status <- renderText({
    if (input$run == 0) {
      "Click 'Run Workflow'"
    } else {
      "Processing complete!"
    }
  })
}

shinyApp(ui, server)