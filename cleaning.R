# -------------------------------
# cleaning.R
# Purpose: Single source of truth for data preprocessing
# -------------------------------

library(dplyr)

# Main function to load and clean data
load_and_clean_data <- function() {
  
  # -------------------------------
  # Load raw dataset (ONLY here)
  # -------------------------------
  data <- read.csv("data/placement.csv", stringsAsFactors = FALSE)
  
  # -------------------------------
  # Basic Cleaning
  # -------------------------------
  data <- data %>%
    
    # Remove rows with missing critical values
    filter(!is.na(CGPA)) %>%
    
    mutate(
      # -------------------------------
      # Target variable (DO NOT convert later)
      # -------------------------------
      placed = as.numeric(ifelse(Placement_Status == "Placed", 1, 0)),
      
      # -------------------------------
      # Fix Gender encoding (important for UI)
      # -------------------------------
      Gender = case_when(
        Gender == 1 ~ "Male",
        Gender == 2 ~ "Female",
        TRUE ~ as.character(Gender)
      ),
      
      # -------------------------------
      # Convert categorical features
      # -------------------------------
      Gender = as.factor(Gender),
      Degree = as.factor(Degree),
      Branch = as.factor(Branch),
      
      # -------------------------------
      # Ensure numeric features are numeric
      # -------------------------------
      Internships = as.numeric(Internships),
      Projects = as.numeric(Projects),
      Coding_Skills = as.numeric(Coding_Skills),
      Communication_Skills = as.numeric(Communication_Skills),
      Aptitude_Test_Score = as.numeric(Aptitude_Test_Score),
      Soft_Skills_Rating = as.numeric(Soft_Skills_Rating),
      Certifications = as.numeric(Certifications),
      Backlogs = as.numeric(Backlogs)
    )
  
  # -------------------------------
  # Remove irrelevant columns
  # -------------------------------
  if ("Student_ID" %in% colnames(data)) {
    data <- data %>% select(-Student_ID)
  }
  
  # -------------------------------
  # Final sanity check
  # -------------------------------
  data <- data %>%
    filter(!is.na(placed))
  
  data$placed <- as.numeric(as.character(data$placed))
  
  return(data)
}