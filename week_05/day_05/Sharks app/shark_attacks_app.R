library(shiny)
library(ggplot2)
library(DT)
data <- shark

ui <- fluidPage(
  titlePanel("Global Shark Attacks"),
  
  tabsetPanel(
    tabPanel("Plot",
             sidebarLayout(
               sidebarPanel(
                 selectInput("variable1", "Select Variable 1:", choices = names(data)),
                 sliderInput("year_range", "Select Year Range:",
                             min = min(data$Year), max = max(data$Year),
                             value = c(min(data$Year), max(data$Year)),
                             step = 1)
               ),
               
               mainPanel(
                 plotOutput("count_plot")
               )
             )
    ),
    
    tabPanel("Info",
             fluidRow(
               column(width = 12, DTOutput("data_table_info"))
             )
    )
  )
)

server <- function(input, output) {
  
  filtered_data <- reactive({
    data %>%
      filter(Year >= input$year_range[1] & Year <= input$year_range[2])
  })
  
  output$count_plot <- renderPlot({
    var1_counts <- filtered_data() %>%
      count(!!sym(input$variable1), sort = TRUE)
    
    p <- ggplot(var1_counts, aes_string(x = input$variable1, y = "n")) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(x = input$variable1, y = "Count", title = "Attacks by variable") +
      coord_flip() +
      theme_minimal()
    
    print(p)
  })
  
  output$data_table_info <- renderDT({
    datatable(filtered_data(),
              options = list(pageLength = 12))
  })
}

shinyApp(ui = ui, server = server)
