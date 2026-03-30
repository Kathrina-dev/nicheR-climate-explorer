library(shiny)
library(shinythemes)
library(terra)
library(geodata)

ui <- fluidPage(
  theme = shinytheme("darkly"),
  titlePanel("Climate Data Explorer"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("region", "Select Region",
                  choices = c("South America", "Africa", "Asia")),
      
      sliderInput("temp_range", "Temperature Range",
                  min = -10, max = 40, value = c(10, 25)),
      
      actionButton("run", "Run Workflow"),
      
      br(), br(),
      verbatimTextOutput("status")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Raw Data", plotOutput("plot_full")),
        tabPanel("Processing", plotOutput("plot_crop")),
        tabPanel("Niche", plotOutput("plot_filtered")),
        tabPanel("Prediction", plotOutput("plot_suitable"))
      )
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

    cropped <- crop_region(bio1, input$region)
    masked <- mask(cropped, cropped)
    
    list(
      full = clim,
      bio1 = bio1,
      cropped = cropped,
      masked = masked
    )
  })
  
  # reactive filtering
  filtered_data <- reactive({
    req(data())
    
    filtered <- data()$cropped
    
    vals <- values(filtered)
    vals[vals < input$temp_range[1] |
           vals > input$temp_range[2]] <- NA
    
    values(filtered) <- vals
    filtered
  })
  
  suitable_data <- reactive({
    req(filtered_data())
    filtered <- filtered_data()
    threshold <- mean(values(filtered), na.rm = TRUE)
    out <- filtered
    vals <- values(filtered)
    vals[vals <= threshold] <- NA
    values(out) <- vals
    out
  })

  output$plot_full <- renderPlot({
    req(data())
    terra::plot(data()$bio1, main = "BIO1 Global")
  })
  
  output$plot_crop <- renderPlot({
    req(data())
    terra::plot(data()$cropped, main = "Cropped Data")
  })

  output$plot_filtered <- renderPlot({
    req(filtered_data())
    terra::plot(filtered_data(), main = "Filtered (Niche)")
  })

  output$plot_suitable <- renderPlot({
    req(suitable_data())
    terra::plot(suitable_data(), main = "Suitability Map")
  })
  
  output$status <- renderText({
    if (input$run == 0) {
      "Click 'Run Workflow'"
    } else {
      "Processing complete!"
    }
  })
}

run_app <- function() {
  shinyApp(ui, server)
}