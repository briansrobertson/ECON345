## Installing and loading libraries
# install.packages("tidyverse")
# install.packages("broom")

library(tidyverse)
library(broom)

# Setup -------------------------------------------------------------------

redfin_clean <- read_csv("data/redfin_clean.csv") %>%
  filter(ppsf < 2000)

# Indicator Variables -------------------------------------------------------

# A baseline regression: one explanatory variable, one slope, one intercept
regression_baseline <- lm(ppsf ~ metro_distance, data = redfin_clean)
tidy(regression_baseline)

# Adding `state` as an indicator gives each state its own intercept
regression_indicators <- lm(ppsf ~ metro_distance + state, data = redfin_clean)
tidy(regression_indicators)

# Pull one coefficient at a time with pull() -- never with $
md_indicator <- regression_indicators %>%
  tidy() %>%
  filter(term == "stateMD") %>%
  pull(estimate)
md_indicator

# Visualize the different intercepts (same slope) with augment()
regression_indicators %>%
  augment(redfin_clean) %>%
  ggplot(aes(x = metro_distance, y = .fitted, color = state)) +
  geom_line(linewidth = 1) +
  labs(title = "Price per Sq Ft vs Metro Distance, by State",
       x = "Metro distance (miles)", y = "Price per sq ft (fitted, USD)")

# Breakout Session: Indicator Variables --------------------------------------

redfin_houses <- redfin_clean %>%
  filter(property_type %in% c("Condo/Co-op", "Single Family Residential", "Townhouse"))

## Question 1: Fit a regression of ppsf on metro_distance and property_type,
## using redfin_houses. Use broom::tidy() to view the results -- do not use
## summary(model)$coefficients.

## Question 2: Which property_type is the base group? How can you tell?

## Question 3: Pick one property_type indicator. Is it statistically
## significant? What does that indicator's coefficient mean in plain English?


# Interaction Terms -----------------------------------------------------------

# Interactions let each state have both its own slope and intercept
regression_interactions <- lm(ppsf ~ metro_distance + state * metro_distance,
                               data = redfin_clean)
tidy(regression_interactions)

# Visualize different slopes and intercepts by state
regression_interactions %>%
  augment(redfin_clean) %>%
  ggplot(aes(x = metro_distance, y = .fitted, color = state)) +
  geom_line(linewidth = 1) +
  labs(title = "Price per Sq Ft vs Metro Distance, with Interactions",
       x = "Metro distance (miles)", y = "Price per sq ft (fitted, USD)")

# Breakout Session: Interaction Terms -----------------------------------------

## Question 1: Fit a regression of ppsf on metro_distance, property_type, and
## their interaction, using redfin_houses.

## Question 2: Using broom::tidy() and pull(), find the slope on
## metro_distance for the base property_type. Then find the slope for one
## other property_type by adding the base slope to that type's interaction
## coefficient.

## Question 3: Does allowing a different slope per property_type change your
## conclusions about how distance from the metro relates to price? Compare
## R-squared from broom::glance() for the indicator-only and interaction
## models to help answer this.


# Variable Transformations ----------------------------------------------------

# A log transformation can capture a non-linear relationship
regression_log <- lm(ppsf ~ log(metro_distance), data = redfin_clean)
tidy(regression_log)

# Compare the straight-line fit to the log fit
redfin_clean %>%
  ggplot(aes(x = metro_distance, y = ppsf)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, color = "red") +
  geom_smooth(method = "lm", formula = y ~ log(x), se = FALSE, color = "blue") +
  labs(title = "Straight-Line Fit (red) vs. Log Fit (blue)",
       x = "Metro distance (miles)", y = "Price per sq ft (USD)")

## Bonus: a 1% increase in metro_distance predicts a change in ppsf of about
## (the log coefficient) / 100. Pull the coefficient with tidy() + pull() and
## compute that number yourself.
