# What Factors Influence College Graduate Earnings?

**Course:** STA 4164 – Statistical Methods III | University of Central Florida  
**Author:** Aiden Akbarov  
**Grade:** 95/100  

---

## Overview

This project investigates what characteristics of a college major are associated with higher median earnings for recent graduates in the United States. Using a dataset of 172 academic majors, I built a multiple linear regression model to identify the strongest predictors of post-graduation income.

**Key finding:** The field of study and gender composition of a major are the two most significant predictors of graduate earnings — not employment rates or job counts.

---

## Results Summary

| Metric | R | Python |
|--------|---|--------|
| Dataset size | 172 college majors | 172 college majors |
| Model type | Multiple Linear Regression | Multiple Linear Regression |
| Adjusted R² | 0.545 | ~0.545 |
| Testing MAE | 4,427 | 4,510 |
| Baseline MAE | 8,400 | 7,800 |
| Improvement over baseline | ~47% | ~42% |

*All earnings values in USD. Results differ slightly between R and Python due to differences in random number generation across languages. Core findings are consistent.*

**Top predictors:**
- Engineering majors earn ~20,400 more per year than the Agriculture & Natural Resources baseline
- For every 10% increase in female representation, predicted median salary drops ~1,700
- Business and Physical Sciences also show significant positive premiums

---

## Repository Structure

```
├── data/
│   └── recent-grads.csv                       # Raw dataset (source: GitHub/emjun)
├── R/
│   └── earnings_regression_analysis.R         # Full R analysis script
├── notebook/
│   └── earnings_regression_analysis.Rmd       # R Markdown source
│   └── earnings_regression_analysis.html      # Rendered R Markdown report
├── python/
│   └── earnings_regression_analysis.ipynb     # Python/Jupyter notebook
├── report/
│   └── Akbarov_STA4164_Final_Report.pdf       # Full written report
├── presentation/
│   └── Akbarov_STA4164_Presentation.pptx      # Slide deck
└── README.md
```

---

## Methods

- **Exploratory Data Analysis (EDA):** distribution analysis, correlation matrix, scatterplots, partial regression plots
- **Model Selection:** AIC-based backward elimination to handle multicollinearity (Non_college_jobs and Low_wage_jobs had r = 0.98)
- **Diagnostics:** VIF checks (all < 4.0), residuals vs. fitted, Shapiro-Wilk normality test, log transformation comparison, Cook's Distance influence analysis
- **Validation:** 70/30 train/test split, Mean Absolute Error (MAE) comparison against baseline mean model

---

## Tools & Technologies

**R:**
- `ggplot2` — data visualization
- `olsrr` — model diagnostics (VIF, Cook's Distance, backward elimination)
- `rsample` — train/test splitting
- `Metrics` — MAE/MSE calculation

**Python:**
- `pandas`, `numpy` — data manipulation
- `seaborn`, `matplotlib` — visualization
- `statsmodels` — OLS regression and diagnostics
- `scikit-learn` — train/test split and error metrics
- `scipy` — Shapiro-Wilk normality test

---

## How to Run

**R script:**
```r
# Install required packages
install.packages(c("ggplot2", "olsrr", "rsample", "Metrics", "car"))

# Run the analysis
source("R/earnings_regression_analysis.R")
```

**R Markdown (rendered report):**
```r
# Open in RStudio and click Knit
# Or view earnings_regression_analysis.html directly in browser
```

**Python notebook:**
```bash
pip install pandas numpy seaborn scikit-learn matplotlib statsmodels scipy
jupyter notebook python/earnings_regression_analysis.ipynb
```

---

## Data Source

Jun, E. (n.d.). *data_college_income* [Data set]. GitHub.  
https://github.com/emjun/data_college_income/tree/master

---

## Key Takeaways

1. **Major category is the strongest predictor** of graduate earnings — Engineering dominates with a ~20,400 premium
2. **Gender composition is statistically significant** even after controlling for field, suggesting systemic labor market patterns
3. **Job type and unemployment rate** were not significant predictors after backward elimination
4. The model explains **55% of variance** in median earnings using only two predictors
5. Results are **consistent across R and Python** implementations, confirming robustness

---

*Project completed May 2026 for STA 4164: Statistical Methods III, Dr. Nathaniel Simone, UCF*
