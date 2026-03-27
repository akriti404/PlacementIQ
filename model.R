# Load required library
library(dplyr)

# Load cleaned data
data <- read.csv("data/cleaned_data.csv")

# -------------------------------
# Train-Test Split
# -------------------------------
set.seed(123)

sample_size <- floor(0.7 * nrow(data))
train_index <- sample(seq_len(nrow(data)), size = sample_size)

train <- data[train_index, ]
test <- data[-train_index, ]

# -------------------------------
# Logistic Regression Model
# -------------------------------
model <- glm(placed ~ CGPA + Internships + Projects +
               Coding_Skills + Communication_Skills +
               Aptitude_Test_Score + Backlogs,
             data = train,
             family = "binomial")

summary(model)

# -------------------------------
# Predictions
# -------------------------------
pred_probs <- predict(model, test, type = "response")

# Convert probabilities to 0/1
pred <- ifelse(pred_probs > 0.5, 1, 0)

# -------------------------------
# Model Evaluation
# -------------------------------
table(Predicted = pred, Actual = test$placed)

# Accuracy
mean(pred == test$placed)

# -------------------------------
# Explainability 
# -------------------------------
exp(coef(model))   # odds ratios