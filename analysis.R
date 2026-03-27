# Load required libraries
library(ggplot2)
library(dplyr)

# Load cleaned data
data <- read.csv("data/cleaned_data.csv")

# Convert placed to factor for plotting
data$placed <- as.factor(data$placed)

# -------------------------------
# 1. Placement Distribution
# -------------------------------
table(data$placed)

ggplot(data, aes(x = placed, fill = placed)) +
  geom_bar() +
  ggtitle("Placement Distribution")

# -------------------------------
# 2. CGPA vs Placement
# -------------------------------
ggplot(data, aes(x = CGPA, fill = placed)) +
  geom_histogram(binwidth = 0.3, alpha = 0.6) +
  ggtitle("CGPA Distribution by Placement")

# Statistical Test
t.test(CGPA ~ placed, data = data)

# -------------------------------
# 3. Internships vs Placement
# -------------------------------
ggplot(data, aes(x = Internships, fill = placed)) +
  geom_bar(position = "fill") +
  ggtitle("Internships vs Placement")

chisq.test(table(data$Internships, data$placed))

# -------------------------------
# 4. Gender vs Placement
# -------------------------------
ggplot(data, aes(x = Gender, fill = placed)) +
  geom_bar(position = "fill") +
  ggtitle("Gender vs Placement")

chisq.test(table(data$Gender, data$placed))

# -------------------------------
# 5. Backlogs vs Placement
# -------------------------------
ggplot(data, aes(x = Backlogs, fill = placed)) +
  geom_bar(position = "fill") +
  ggtitle("Backlogs vs Placement")

chisq.test(table(data$Backlogs, data$placed))

# -------------------------------
# 6. Coding Skills Impact
# -------------------------------
ggplot(data, aes(x = Coding_Skills, fill = placed)) +
  geom_bar(position = "fill") +
  ggtitle("Coding Skills vs Placement")

# -------------------------------
# 7. Communication Skills Impact
# -------------------------------
ggplot(data, aes(x = Communication_Skills, fill = placed)) +
  geom_bar(position = "fill") +
  ggtitle("Communication Skills vs Placement")

# -------------------------------
# 8. Correlation (Numeric Features)
# -------------------------------
numeric_data <- data %>%
  select(CGPA, Internships, Projects, Coding_Skills,
         Communication_Skills, Aptitude_Test_Score,
         Soft_Skills_Rating, Certifications, Backlogs)

cor(numeric_data)