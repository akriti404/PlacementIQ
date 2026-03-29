# -------------------------------
# app.R
# Purpose: Shiny Dashboard (Improved Version)
# -------------------------------

library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)

# Load scripts
source("cleaning.R")
source("model.R")
source("analysis.R")

# -------------------------------
# Load data + train model ONCE
# -------------------------------
data <- load_and_clean_data()

model_obj <- train_model(data)
model <- model_obj$model
test_data <- model_obj$test

eval <- evaluate_model(model, test_data)

# -------------------------------
# UI
# -------------------------------
ui <- fluidPage(
  
  theme = shinytheme("cerulean"),
  
  titlePanel("PlacementIQ Dashboard"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      # Filters
      selectInput(
        "gender",
        "Select Gender:",
        choices = c("All", sort(unique(as.character(data$Gender))))),
      
      selectInput("intern", "Internships:",
                  choices = c("All", unique(data$Internships))),
      
      sliderInput("cgpa", "CGPA Range:",
                  min = min(data$CGPA),
                  max = max(data$CGPA),
                  value = c(min(data$CGPA), max(data$CGPA)),
                  step = 0.1),
      
      hr(),
      
      # Prediction Inputs
      h4("🔮 Predict Placement"),
      
      numericInput("p_cgpa", "CGPA", 7),
      numericInput("p_intern", "Internships", 1),
      numericInput("p_projects", "Projects", 3),
      numericInput("p_coding", "Coding Skills", 6),
      numericInput("p_comm", "Communication Skills", 6),
      numericInput("p_apt", "Aptitude Score", 70),
      numericInput("p_soft", "Soft Skills Rating", 6),
      numericInput("p_cert", "Certifications", 2),
      numericInput("p_backlogs", "Backlogs", 0),
      
      actionButton("predict_btn", "Predict"),
      
      br(), br(),
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
      h3("📈 Model Performance"),
      
      verbatimTextOutput("metrics"),
      verbatimTextOutput("confusion")
    )
  )
)

# -------------------------------
# SERVER
# -------------------------------
server <- function(input, output) {
  
  # -------------------------------
  # Filtering
  # -------------------------------
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
  
  # -------------------------------
  # Plots
  # -------------------------------
  output$placementPlot <- renderPlot({
    placement_plot(filtered_data())
  })
  
  output$cgpaPlot <- renderPlot({
    cgpa_plot(filtered_data())
  })
  
  output$skillsPlot <- renderPlot({
    skills_plot(filtered_data())
  })
  
  output$backlogPlot <- renderPlot({
    backlog_plot(filtered_data())
  })
  
  # -------------------------------
  # Model Metrics
  # -------------------------------
  output$metrics <- renderText({
    paste(
      "Accuracy:", round(eval$accuracy * 100, 2), "%",
      "\nPrecision:", round(eval$precision * 100, 2), "%",
      "\nRecall:", round(eval$recall * 100, 2), "%",
      "\nF1 Score:", round(eval$f1 * 100, 2), "%"
    )
  })
  
  # -------------------------------
  # Confusion Matrix
  # -------------------------------
  output$confusion <- renderText({
    paste(
      "Confusion Matrix:\n",
      "TP:", eval$TP,
      "TN:", eval$TN,
      "FP:", eval$FP,
      "FN:", eval$FN
    )
  })
  
  # -------------------------------
  # Prediction
  # -------------------------------
  observeEvent(input$predict_btn, {
    
    new_data <- data.frame(
      CGPA = input$p_cgpa,
      Internships = input$p_intern,
      Projects = input$p_projects,
      Coding_Skills = input$p_coding,
      Communication_Skills = input$p_comm,
      Aptitude_Test_Score = input$p_apt,
      Soft_Skills_Rating = input$p_soft,
      Certifications = input$p_cert,
      Backlogs = input$p_backlogs
    )
    
    pred <- predict_student(model, new_data)
    
    # Explainability
    contrib <- coef(model)[-1] * unlist(new_data)
    top <- names(sort(abs(contrib), decreasing = TRUE))[1:3]
    
    output$prediction <- renderText({
      paste(
        "Prediction:", pred$result,
        "\nProbability:", round(pred$prob, 3),
        "\nConfidence:", pred$confidence,
        "\nTop Factors:", paste(top, collapse = ", ")
      )
    })
  })
}

# Run app
shinyApp(ui, server)