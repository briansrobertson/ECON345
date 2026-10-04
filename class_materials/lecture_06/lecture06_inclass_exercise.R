### Set your working directory to the folder containing finra_clean.csv
### and studentdata_clean.csv
# setwd()

## Installing and loading libraries
# install.packages("tidyverse")
# install.packages("weights")

library(tidyverse)
library(weights)
library(infer)

# Load the cleaned FINRA dataset ---------------------------------------------
finra_clean <- read_csv("finra_clean.csv")

# Load the cleaned student dataset -------------------------------------------
studentdata_clean <- read_csv("studentdata_clean.csv")

# Correlation ------------------------------------------------------------

# Correlation of financial satisfaction and willingness to take risks
finra_clean %>%
  summarise(cor = cor(fin_satisfied, fin_risks))

# Correlation with weights
with(finra_clean, wtd.cors(x = fin_satisfied, y = fin_risks, weight = national_weight))

# Correlation matrix
finra_clean %>%
  select(fin_satisfied, fin_risks, too_much_debt) %>%
  cor()

# One-sample and two-sample t-tests --------------------------------------

# Two-sided, one-sample t-test
t_test(finra_clean, response = fin_satisfied, mu = 5.75)

# Two-sided, two-sample t-test
t_test(finra_clean, formula = fin_satisfied ~ gender)

# One-sided, one-sample t-test
t_test(finra_clean, response = fin_satisfied, mu = 5.75, alternative = "less")

# One-sided, two-sample t-test
t_test(studentdata_clean, formula = totalscore ~ group, alternative = "greater")

# Breakout Session 1 ------------------------------------------------------

## Question 1 (one-sample t-test): Is the average willingness to take
## financial risks statistically different from 5.0 (out of 10.0)?

## Question 2 (two-sample t-test): Is the willingness to take financial
## risks statistically different for those living in the Northeast versus
## those who do not?

## Hint: the relevant variables are fin_risks and northeast.

## Steps: (1) null and alternative hypotheses, (2) significance level,
## (3) code to run the test, (4) reject or fail to reject?



# Breakout Session 2 ------------------------------------------------------

## Question: Is the average student math score greater than 50?

## Hint: the relevant variable is math_score.

## Steps: (1) null and alternative hypotheses, (2) significance level,
## (3) code to run the test, (4) reject or fail to reject?
