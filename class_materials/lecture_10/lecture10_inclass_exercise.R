## Installing and loading libraries
# install.packages("tidyverse")

library(tidyverse)

# Code Review ---------------------------------------------------------------

## Review each function below against the course style checklist (no `$` on
## a data frame, prefer tidyverse functions to base R ones) and for logic
## bugs. Leave yourself a comment with what you'd flag, then fix it.

loan_2013 <- read_csv("data/loan_2013.csv", show_col_types = FALSE)

## Review 1: style
average_payment <- function(loan_df) {
  mean(loan_df$payment)
}
# average_payment(loan_2013)

## Review 2: logic -- an 85 should be a "B"
grade <- function(score) {
  case_when(
    score >= 90 ~ "A",
    score >= 70 ~ "C",
    score >= 80 ~ "B",
    score >= 60 ~ "D",
    TRUE ~ "F"
  )
}
# grade(85)

## Review 3: a hidden single-input assumption
reverse_string <- function(string) {
  string %>%
    strsplit(split = NULL) %>%
    .[[1]] %>%
    rev() %>%
    paste0(collapse = "")
}

cipher <- c(".rehpic eht si sihT", ",boj dooG",
            "!rehpic eht dekcarc uoy",
            ".lufpleh repus eb nac gnimmargorp lanoitcnuF")

# reverse_string(cipher)   # only decodes the first message -- why?


# Writing Functions -----------------------------------------------------------

# Breakout: Converting Temperatures ------------------------------------------

## Write F_to_K(), using:   K = (F - 32) * (5 / 9) + 273.15
# F_to_K <- function(degrees_f) {
#
# }

## Write K_to_C(), using:   C = K - 273.15
# K_to_C <- function(degrees_k) {
#
# }

## Write F_to_C() by CALLING F_to_K() and K_to_C() -- don't re-derive the formula
# F_to_C <- function(degrees_f) {
#
# }

## Check your answers:
# F_to_C(98.6)   # body temperature -- should be about 37
# F_to_C(32)     # freezing -- should be 0


# Functional Programming -----------------------------------------------------

loan_files <- c("data/loan_2013.csv", "data/loan_2014.csv",
                "data/loan_2015.csv", "data/loan_2016.csv")

total_interest_paid <- function(file) {
  file %>%
    read_csv(show_col_types = FALSE) %>%
    pull(interest) %>%
    sum()
}

## Question 1: Use map_dbl() to get the total interest paid on all four loans
# map_dbl(loan_files, total_interest_paid)

## Question 2: Use sapply() on the same function and inputs. How does the
## output compare to map_dbl()'s?
# sapply(loan_files, total_interest_paid)

## Bonus: write total_principal_paid(), using the `principal` column instead
## of `interest`, and map_dbl() it across loan_files
# total_principal_paid <- function(file) {
#
# }
# map_dbl(loan_files, total_principal_paid)

## Breakout: Cracking the Cipher ----------------------------------------------

## reverse_string() and cipher are defined above, in the Code Review section.
## Use map_chr() to apply reverse_string() to every element of cipher, and
## decode the full message.
# map_chr(cipher, reverse_string)
