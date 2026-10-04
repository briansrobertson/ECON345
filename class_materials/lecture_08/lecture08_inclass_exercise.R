### Set your working directory to the folder containing redfin_clean.csv
### and median_earnings.csv
# setwd()

## Installing and loading libraries
# install.packages("tidyverse")
# install.packages("broom")
# install.packages("gapminder")

library(tidyverse)
library(broom)
library(gapminder)

# Load the data ----------------------------------------------------------

median_earnings <- read_csv("median_earnings.csv")
redfin <- read_csv("redfin_clean.csv")

# The Grammar of Graphics -------------------------------------------------

# Building a plot step by step: data -> aesthetic mapping -> geometry
median_earnings %>%
  filter(age == "25 to 34 years") %>%
  ggplot(aes(x = date, y = median_weekly_earn)) +
  geom_line()

# Mapping a variable to color puts every group on one plot
median_earnings %>%
  ggplot(aes(x = date, y = median_weekly_earn, color = age)) +
  geom_line()

# Compare: setting color manually (outside aes()) instead of mapping it
median_earnings %>%
  filter(age == "25 to 34 years") %>%
  ggplot(aes(x = date, y = median_weekly_earn)) +
  geom_line(color = "darkolivegreen4", linewidth = 1)

# Beautifying the plot -----------------------------------------------------

age_plot <- median_earnings %>%
  ggplot(aes(date, median_weekly_earn, color = age)) +
  geom_line() +
  labs(title = "Median weekly earnings rise with age and over time",
       subtitle = "The biggest gap is between ages 24 and under versus 25 and older",
       caption = "Source: Bureau of Labor Statistics",
       x = "Date", y = "Median Weekly Earnings", color = NULL) +
  scale_y_continuous(labels = scales::dollar_format(accuracy = 1)) +
  theme_minimal() +
  theme(plot.title.position = "plot", plot.subtitle = element_text(face = "italic"))

age_plot

# Breakout: Gapminder -------------------------------------------------------

## Using the gapminder dataset (built into the gapminder package):
## 1. Filter to year == 2007.
## 2. Map GDP per capita to x, life expectancy to y, continent to color,
##    and population to size.
## 3. Represent the data with the point geometry.
## 4. Bonus: make the x-axis a log scale.

## Then, beautify your plot:
## 5. Add a title, subtitle, and caption with labs().
## 6. Add a pre-made theme.
## 7. Format the x-axis as a dollar scale.

# Exploring the Redfin Data -------------------------------------------------

glimpse(redfin)

# Correlation matrix: which variables move with price?
redfin %>%
  select(price, beds, baths, square_feet, ppsf, lot_size, metro_distance) %>%
  cor(use = "pairwise.complete.obs") %>%
  round(2)

# A first scatterplot: price vs. square footage
ggplot(redfin, aes(x = square_feet, y = price / 1000)) +
  geom_point(shape = ".") +
  labs(x = "Area (sq. ft.)", y = "Price ($ thousands)", title = "Home Price vs. Area")

# Regression I: lm() and the tidy workflow ----------------------------------

price_mod <- lm(price ~ square_feet, data = redfin)

# Never pull coefficients with coef() or summary(price_mod)$coefficients --
# broom gives us clean tibbles instead.
tidy(price_mod)                                   # coefficient-level results
glance(price_mod) %>% select(r.squared, nobs)      # model-level fit

# broom::augment() adds fitted values, so we can plot the line with
# geom_line() instead of manually extracting an intercept and slope
augment(price_mod) %>%
  ggplot(aes(x = square_feet, y = price / 1000)) +
  geom_point(size = 0.4, color = "grey40") +
  geom_line(aes(y = .fitted / 1000), color = "firebrick", linewidth = 1) +
  labs(x = "Area (sq. ft.)", y = "Price ($ thousands)",
       title = "Price vs. Area, With Fitted Line")

# Finding and fixing an outlier ---------------------------------------------

# Price per square foot vs. distance from the metro
ggplot(redfin, aes(x = metro_distance, y = ppsf)) +
  geom_point(size = 0.3, color = "steelblue")

# One listing has ppsf far outside the rest -- the sale price was entered
# off by a factor of 10. Correct it rather than drop the row.
redfin %>%
  filter(ppsf > 2000) %>%
  select(id, price, square_feet, ppsf)

redfin <- redfin %>%
  mutate(ppsf = if_else(id == "10349836", ppsf / 10, ppsf))

# Breakout: Regress and Plot -------------------------------------------------

## 1. Regress ppsf on metro_distance with lm().
## 2. Pull the coefficients with broom::tidy().
## 3. Add the fitted line to a scatterplot using broom::augment().
## 4. What's the relationship between metro distance and price per
##    square foot? Is it statistically significant? Economically
##    significant, given the mean ppsf in this data?
