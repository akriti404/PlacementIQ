library(shiny)
library(ggplot2)
library(dplyr)
library(shinythemes)

# Load data
data <- read.csv("cleaned_data.csv")
data$placed <- as.factor(data$placed)

# Train model
model <- glm(placed ~ CGPA + Internships + Projects +
               Coding_Skills + Communication_Skills +
               Aptitude_Test_Score + Backlogs,
             data = data,
             family = "binomial")

# ---------------- UI ----------------
ui <- fluidPage(
  
  theme = shinytheme("cerulean"),
  
  titlePanel("PlacementIQ Dashboard"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput("gender", "Select Gender:",
                  choices = c("All", unique(data$Gender))),
      
      selectInput("intern", "Internships:",
                  choices = c("All", unique(data$Internships))),
      
      sliderInput("cgpa", "CGPA Range:",
                  min = min(data$CGPA),
                  max = max(data$CGPA),
                  value = c(min(data$CGPA), max(data$CGPA)),
                  step = 0.1),
      
      hr(),
      h4("🔮 Predict Placement"),
      
      numericInput("p_cgpa", "CGPA", value = 7),
      numericInput("p_intern", "Internships", value = 1),
      numericInput("p_projects", "Projects", value = 3),
      numericInput("p_coding", "Coding Skills", value = 6),
      numericInput("p_comm", "Communication Skills", value = 6),
      numericInput("p_apt", "Aptitude Score", value = 70),
      numericInput("p_backlogs", "Backlogs", value = 0),
      
      actionButton("predict_btn", "Predict"),
      
      br(), br(),
      
      # 🔥 Prediction result RIGHT HERE
      strong("Prediction Result:"),
      verbatimTextOutput("prediction")
    ),
    
    mainPanel(
      
      h3("📊 Dashboard"),
      
      fluidRow(
        column(6, plotOutput("placementPlot")),
        column(6, plotOutput("cgpaPlot"))
      ),
      
      fluidRow(
        column(6, plotOutput("skillsPlot")),
        column(6, plotOutput("backlogPlot"))
      ),
      
      hr(),
      h3("📈 Model Insights"),
      verbatimTextOutput("accuracy"),
      verbatimTextOutput("topFactors")
    )
  )
)

# ---------------- SERVER ----------------
server <- function(input, output) {
  
  filtered_data <- reactive({
    
    df <- data
    
    if (input$gender != "All") {
      df <- df %>% filter(Gender == input$gender)
    }
    
    if (input$intern != "All") {
      df <- df %>% filter(Internships == input$intern)
    }
    
    df <- df %>%
      filter(CGPA >= input$cgpa[1],
             CGPA <= input$cgpa[2])
    
    return(df)
  })
  
  # Plots
  output$placementPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = placed, fill = placed)) +
      geom_bar() +
      ggtitle("Placement Distribution")
  })
  
  output$cgpaPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = CGPA, fill = placed)) +
      geom_histogram(binwidth = 0.3, alpha = 0.6) +
      ggtitle("CGPA vs Placement")
  })
  
  output$skillsPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = Coding_Skills, fill = placed)) +
      geom_bar(position = "fill") +
      ggtitle("Coding Skills Impact")
  })
  
  output$backlogPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = Backlogs, fill = placed)) +
      geom_bar(position = "fill") +
      ggtitle("Backlogs Impact")
  })
  
  # Accuracy
  output$accuracy <- renderText({
    pred <- ifelse(predict(model, data, type = "response") > 0.5, 1, 0)
    acc <- mean(pred == data$placed)
    paste("Model Accuracy:", round(acc * 100, 2), "%")
  })
  
  # Top factors
  output$topFactors <- renderText({
    odds <- exp(coef(model))
    top <- sort(odds[-1], decreasing = TRUE)
    
    paste("Top Influencing Factors:\n",
          paste(names(top)[1:3], collapse = ", "))
  })
  
  # Prediction
  observeEvent(input$predict_btn, {
    
    new_data <- data.frame(
      CGPA = input$p_cgpa,
      Internships = input$p_intern,
      Projects = input$p_projects,
      Coding_Skills = input$p_coding,
      Communication_Skills = input$p_comm,
      Aptitude_Test_Score = input$p_apt,
      Backlogs = input$p_backlogs
    )
    
    prob <- predict(model, new_data, type = "response")
    result <- ifelse(prob > 0.5, "Placed", "Not Placed")
    
    output$prediction <- renderText({
      paste("Prediction:", result,
            "\nProbability:", round(prob, 3))
    })
  })
}

# Run app
shinyApp(ui = ui, server = server)