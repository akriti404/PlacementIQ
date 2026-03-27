#Load required package
library(dplyr)

#Load data
data <- read.csv("data/placement.csv")

# Inspect structure
str(data)

# -------------------------------
# Cleaning
# -------------------------------
data <- data %>%
  
  # Remove missing CGPA rows (important feature)
  filter(!is.na(CGPA)) %>%
  
  mutate(
    # Target variable (IMPORTANT)
    placed = ifelse(Placement_Status == "Placed", 1, 0),
    
    # Convert categorical variables
    Gender = as.factor(Gender),
    Degree = as.factor(Degree),
    Branch = as.factor(Branch),
    Placement_Status = as.factor(Placement_Status),
    
    # Convert numeric columns safely
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
# Remove unnecessary column
# -------------------------------
data <- data %>% select(-Student_ID)

# -------------------------------
# Quick Checks
# -------------------------------
summary(data)

# Check target distribution
table(data$placed)

# Check unique values
unique(data$Placement_Status)

# Preview data
head(data)

# Save cleaned data
write.csv(data, "cleaned_data.csv", row.names = FALSE)