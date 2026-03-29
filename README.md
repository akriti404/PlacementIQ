# PlacementIQ — Campus Placement Analysis using R

PlacementIQ is a data analysis and machine learning project that analyzes factors influencing campus placement outcomes using real-world student data. The project integrates data preprocessing, statistical analysis, and a predictive model with an interactive Shiny dashboard.

---

## 📌 Overview

The goal of this project is to identify key factors affecting student placements and build a reliable predictive system. The pipeline includes data cleaning, exploratory analysis, hypothesis testing, handling class imbalance, and building an interpretable machine learning model.

---

## 🚀 Key Features

- Data cleaning and preprocessing using R (centralized pipeline)
- Exploratory Data Analysis (EDA) using ggplot2
- Statistical testing (t-test, chi-square test)
- Weighted Logistic Regression for imbalanced data
- Proper model evaluation using:
  - Accuracy
  - Precision
  - Recall
  - F1 Score
- Confusion Matrix for detailed performance analysis
- Model interpretability using feature coefficients (odds ratios)
- Interactive Shiny dashboard with real-time predictions
- Explainable predictions with probability, confidence, and top factors

---

## 📊 Key Insights

- CGPA significantly increases placement probability  
- Internships and projects positively influence outcomes  
- Coding and communication skills are strong predictors  
- Backlogs negatively impact placement chances  
- Gender has minimal impact on placement decisions  

---

## 🤖 Model Details

- Model: **Weighted Logistic Regression**
- Dataset: Imbalanced (Handled using class weights)
- Train-Test Split: 70% training, 30% testing

### 📈 Performance Metrics
- Accuracy: ~86%
- Precision: ~76%
- Recall: ~89%
- F1 Score: ~82%

👉 High recall ensures that most placed students are correctly identified.

---

## 🧠 Features Used

- CGPA  
- Internships  
- Projects  
- Coding Skills  
- Communication Skills  
- Aptitude Test Score  
- Soft Skills Rating  
- Certifications  
- Backlogs  

---

## 🖥️ Dashboard Features

- Interactive filtering (Gender, CGPA, Internships)
- Multiple visualizations (placement distribution, skills impact, etc.)
- Real-time placement prediction
- Model performance metrics display
- Confusion matrix visualization
- Prediction explanation:
  - Probability
  - Confidence level
  - Top influencing features

---

## ▶️ How to Run

1. Clone the repository  
2. Open the project in RStudio or VS Code  
3. Run the following:

```r
source("cleaning.R")
source("model.R")
source("analysis.R")
shiny::runApp()
