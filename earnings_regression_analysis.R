# ============================================================
# Aiden Akbarov | STA 4164 | University of Central Florida
# Project: What factors influence earnings of recent college graduates?
# ============================================================

library(car)
library(ggplot2)
library(olsrr)      # For model selection and diagnostics
library(Metrics)    # For MAE and MSE
library(rsample)    # For data partitioning

options(scipen = 999)

# ------------------------------------------------------------
# 1. DATA PREPARATION
# ------------------------------------------------------------
df <- data.frame(recent_grads)
df <- df[complete.cases(df), ]   # Remove rows with missing values (Food Science)

# ------------------------------------------------------------
# 2. TRAIN / TEST SPLIT (70/30)
# ------------------------------------------------------------
set.seed(4164)
data_split <- initial_split(df, prop = 0.70)
train_data <- training(data_split)
test_data  <- testing(data_split)

# Ensure all Major_category levels in test set exist in training set
test_data <- test_data[test_data$Major_category %in% unique(train_data$Major_category), ]

# ------------------------------------------------------------
# 3. FULL MODEL
# ------------------------------------------------------------
full_model <- lm(Median ~ ShareWomen + Unemployment_rate +
                   College_jobs + Low_wage_jobs + Major_category,
                 data = train_data)

# ------------------------------------------------------------
# 4. MODEL SELECTION — Backward Elimination via AIC
# ------------------------------------------------------------
selection_results <- ols_step_backward_aic(full_model)
final_model       <- selection_results$model
summary(final_model)

# ------------------------------------------------------------
# 5. MODEL DIAGNOSTICS
# ------------------------------------------------------------

# 5a. Multicollinearity — Variance Inflation Factors (VIF)
ols_coll_diag(final_model)

# 5b. Homoscedasticity — Residuals vs Fitted Plot
plot(final_model$fitted.values, residuals(final_model),
     main = "Residuals vs Fitted",
     xlab = "Fitted Values",
     ylab = "Residuals",
     pch  = 20, col = "darkblue")
abline(h = 0, col = "red", lty = 2)

# 5c. Normality of Residuals — Shapiro-Wilk Test (Original Model)
shapiro.test(residuals(final_model))

# 5d. Normality Remedy — Log Transformation of Response Variable
train_data$log_Median <- log(train_data$Median)
test_data$log_Median  <- log(test_data$Median)

log_model <- lm(log_Median ~ ShareWomen + Major_category, data = train_data)
shapiro.test(residuals(log_model))

# Residuals vs Fitted for Log Model (comparison)
plot(log_model$fitted.values, residuals(log_model),
     main = "Residuals vs Fitted (Log-Transformed Model)",
     xlab = "Fitted Values",
     ylab = "Residuals",
     pch  = 20, col = "darkgreen")
abline(h = 0, col = "red", lty = 2)

# 5e. Influential Observations — Cook's Distance
ols_plot_cooksd_bar(final_model)

# ------------------------------------------------------------
# 6. MODEL VALIDATION & PERFORMANCE METRICS
# ------------------------------------------------------------

# Generate predictions on the test set
test_preds <- predict(final_model, newdata = test_data)

# MAE and MSE
test_mae <- mae(test_data$Median, test_preds)
test_mse <- mse(test_data$Median, test_preds)

# Baseline MAE (predicting the mean salary for every observation)
null_mae <- mae(test_data$Median, rep(mean(train_data$Median), nrow(test_data)))

cat("--- Validation Results ---\n")
cat("Testing MAE:          $", round(test_mae, 2), "\n")
cat("Baseline (Mean) MAE:  $", round(null_mae, 2), "\n")
cat("MSE:                  $", round(test_mse, 2), "\n")

# ------------------------------------------------------------
# 7. VISUALIZATIONS
# ------------------------------------------------------------

# 7a. Predicted vs Actual Earnings (Test Set)
ggplot(test_data, aes(x = Median, y = test_preds)) +
  geom_point(alpha = 0.6, color = "darkblue") +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(title    = "Model Accuracy: Predicted vs. Actual Earnings",
       subtitle = paste("Testing MAE: $", round(test_mae, 2)),
       x        = "Actual Median Earnings ($)",
       y        = "Predicted Median Earnings ($)") +
  theme_minimal()