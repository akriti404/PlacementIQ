# -------------------------------
# model.R
# Purpose: Weighted Logistic Regression + Proper Evaluation
# -------------------------------

# -------------------------------
# Train Model with Class Weights
# -------------------------------
train_model <- function(data) {
  
  set.seed(123)
  
  # -------------------------------
  # Train-Test Split (70-30)
  # -------------------------------
  sample_size <- floor(0.7 * nrow(data))
  train_index <- sample(seq_len(nrow(data)), size = sample_size)
  
  train <- data[train_index, ]
  test <- data[-train_index, ]
  
  # -------------------------------
  # Compute Class Weights
  # -------------------------------
  count_0 <- sum(train$placed == 0)
  count_1 <- sum(train$placed == 1)
  
  weight_0 <- 1 / count_0
  weight_1 <- 1 / count_1
  
  # Assign weights row-wise
  train$weights <- ifelse(train$placed == 1, weight_1, weight_0)
  
  # -------------------------------
  # Logistic Regression Model
  # -------------------------------
  model <- glm(placed ~ CGPA + Internships + Projects +
                 Coding_Skills + Communication_Skills +
                 Aptitude_Test_Score + Soft_Skills_Rating +
                 Certifications + Backlogs,
               data = train,
               family = "binomial",
               weights = weights)
  
  return(list(model = model, train = train, test = test))
}

# -------------------------------
# Evaluation Metrics
# -------------------------------
evaluate_model <- function(model, test) {
  
  probs <- predict(model, test, type = "response")
  
  # Threshold (can tune later)
  threshold <- 0.5
  pred <- ifelse(probs > threshold, 1, 0)
  
  # -------------------------------
  # Confusion Matrix
  # -------------------------------
  TP <- sum(pred == 1 & test$placed == 1)
  TN <- sum(pred == 0 & test$placed == 0)
  FP <- sum(pred == 1 & test$placed == 0)
  FN <- sum(pred == 0 & test$placed == 1)
  
  # -------------------------------
  # Metrics
  # -------------------------------
  accuracy  <- (TP + TN) / nrow(test)
  precision <- TP / (TP + FP)
  recall    <- TP / (TP + FN)
  f1        <- 2 * (precision * recall) / (precision + recall)
  
  return(list(
    accuracy = accuracy,
    precision = precision,
    recall = recall,
    f1 = f1,
    TP = TP, TN = TN, FP = FP, FN = FN
  ))
}

# -------------------------------
# Prediction Function
# -------------------------------
predict_student <- function(model, new_data) {
  
  prob <- predict(model, new_data, type = "response")
  
  result <- ifelse(prob > 0.5, "Placed", "Not Placed")
  
  confidence <- ifelse(prob > 0.75, "High",
                       ifelse(prob > 0.5, "Medium", "Low"))
  
  return(list(result = result, prob = prob, confidence = confidence))
}