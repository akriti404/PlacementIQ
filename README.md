# PlacementIQ — Campus Placement Analysis using R

PlacementIQ is a data analysis and machine learning project that studies factors influencing campus placement outcomes using real-world student data. The project combines statistical testing, interpretable modeling, and an interactive Shiny dashboard.

## Overview

The objective is to identify what truly drives placement decisions by validating common assumptions using data-driven methods. The workflow includes data preprocessing, exploratory analysis, hypothesis testing, and predictive modeling.

## Key Features

- Data cleaning and preprocessing in R  
- Exploratory data analysis using ggplot2  
- Statistical testing (t-test, chi-square)  
- Logistic regression model for placement prediction  
- Model interpretability using odds ratios  
- Interactive dashboard built with Shiny  

## Key Insights

- CGPA has a positive impact on placement  
- Internships improve placement probability  
- Coding and communication skills are strong predictors  
- Backlogs negatively affect placement  
- Gender has minimal influence on placement outcomes  

## Model

- Model: Logistic Regression  
- Accuracy: ~85%  
- Features: CGPA, Internships, Projects, Coding Skills, Communication Skills, Aptitude Score, Backlogs  

## How to Run

1. Clone the repository  
2. Open the project in RStudio  
3. Run:
```r
source("cleaning.R")
source("analysis.R")
shiny::runApp()
