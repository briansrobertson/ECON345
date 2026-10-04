## Installing and loading libraries
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)

# Loops -----------------------------------------------------------------

# A simple for loop
example_vector <- c(2:6)
for (i in example_vector) {
  print(i^2)
}

# Looping over test scores
test_scores <- c(85, 55, 100, 67, 91)
for (score in test_scores) {
  print(paste("Student's test score is", score))
}

# Avoid hard-coded ranges: use seq_along() instead of 1:length(...)
for (i in seq_along(test_scores)) {
  print(test_scores[i])
}

# Cumulative sum, saving every intermediate result
num_vec <- 5:10
cumul_sum <- NULL
for (current_num in seq_along(num_vec)) {
  current_cumul_sum <- sum(num_vec[1:current_num])
  cumul_sum <- c(cumul_sum, current_cumul_sum)
}
cumul_sum

# Breakout Session: Budgeting --------------------------------------------

monthly_spending <- c(703, 200, 474, 576, 636, 369,
                      549, 553, 652, 435, 724, 910)

## Question 1: Use a for loop to compute your cumulative average spending
## each month. Save every intermediate result in a vector.

## Question 2: Combine a loop and if/else statement to flag which months
## your cumulative average was over your $520 limit. Save the result in a
## vector.

## Bonus: plot the cumulative average spent by month as a line chart.


# Debugging ---------------------------------------------------------------

## Each function below has a bug. Use print() statements or browser() to
## find it, then fix the function so it does what the name/comment says.

## Bug 1: should return the mean of a numeric vector
buggy_mean <- function(x) {
  total <- sum(x)
  n <- length(x)
  mean_val <- total / n
  print(n)
}

# buggy_mean(c(2, 4, 6, 8))

## Bug 2: should return TRUE if a Star Wars character is tall (height > 100)
check_tall <- function(character_row) {
  character_row %>%
    mutate(tall = (height = 100)) %>%
    pull(tall)
}

# check_tall(starwars[1, ])

## Bug 3: should count how many elements of a vector are above a threshold
count_above <- function(x, threshold) {
  count <- 0
  for (i in seq_along(x)) {
    if (x[i] >= threshold) {
      count <- 1
    }
  }
  count
}

# count_above(c(10, 55, 2, 90, 61), 50)
