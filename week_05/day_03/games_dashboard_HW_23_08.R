library(shiny)
library(tidyverse)
library(bslib)
library(plotly)
library(CodeClanData) 

games <- game_sales

game_name <- games %>% 
  distinct(name) %>% 
  pull()

genre <- games %>% 
  distinct(genre) %>% 
  pull()

platform <- games %>% 
  distinct(platform) %>% 
  pull()

ui <- fluidPage(
  
  theme = bs_theme(bootswatch = "slate"),
  
  fluidRow(column(
    width = 8,
    offset = 4,
    
    titlePanel(tags$b("Video Games"))
  )),
  
  
  tabsetPanel(
    tabPanel("Filtering Score",
             sidebarLayout(
               sidebarPanel(
                 
                 radioButtons(
                   inputId = "use_genre",
                   label = "Use Genre Filter",
                   choices = c("Yes", "No"),
                   selected = "Yes"
                 ),
                 selectInput(
                   inputId = "genre",
                   label = "Genre",
                   choices = genre
                 ),
                 
                 
                 radioButtons(
                   inputId = "use_platform",
                   label = "Use Platform Filter",
                   choices = c("Yes", "No"),
                   selected = "Yes"
                 ),
                 selectInput(
                   inputId = "platform",
                   label = "Platform",
                   choices = platform
                 ),
                 
                 
                 radioButtons(
                   inputId = "use_name",
                   label = "Use Name Filter",
                   choices = c("Yes", "No"),
                   selected = "Yes"
                 ),
                 selectInput(
                   inputId = "name",
                   label = "Game Title",
                   choices = game_name
                 )
               ),
               
               
               mainPanel(
                 plotlyOutput("plot_gbn")
               )
             )
    )
  )
)

server <- function(input, output) {
  output$plot_gbn <- renderPlotly({
    filtered_games <- games
    
    if (input$use_genre == "Yes") {
      filtered_games <- filtered_games %>%
        filter(genre == input$genre)
    }
    
    if (input$use_platform == "Yes") {
      filtered_games <- filtered_games %>%
        filter(platform == input$platform)
    }
    
    if (input$use_name == "Yes") {
      filtered_games <- filtered_games %>%
        filter(name == input$name)
    }
    
    plot <- ggplot(filtered_games, aes(x = user_score, y = critic_score)) +
      geom_line(color = "blue") +
      geom_point() +
      labs(
        title = "Comparison of User Score and Critic Score",
        x = "User Score",
        y = "Critic Score"
      ) +
      theme_minimal()
    
    ggplotly(plot)
  })
}

shinyApp(ui = ui, server = server)

