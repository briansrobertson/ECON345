## Installing and loading libraries
# install.packages("tidyverse")
# install.packages("scales")

library(tidyverse)
library(scales)

# Setup -----------------------------------------------------------------

redfin <- read_csv("data/redfin_clean.csv", show_col_types = FALSE) %>%
  filter(ppsf < 2000)

redfin_main <- redfin %>%
  filter(property_type %in% c("Condo/Co-op", "Single Family Residential", "Townhouse"))

# Spurious Correlation ----------------------------------------------------

## From the slides: two unrelated random walks, correlated purely by chance
## because both happen to drift in the same direction.
set.seed(440)
n <- 72

trend_data <- tibble(
  month = 1:n,
  umbrellas_sold = cumsum(rnorm(n, mean = 0.5, sd = 2)),
  satellites_launched = cumsum(rnorm(n, mean = 0.4, sd = 2.5))
)

trend_data %>%
  summarise(cor = cor(umbrellas_sold, satellites_launched))

## Breakout: Finding (and Breaking) a Spurious Correlation -------------------

## Question 1: Pick your own seed, re-run the simulation above, and check the
## correlation.
# set.seed(1)
# trend_data <- tibble(
#   month = 1:n,
#   umbrellas_sold = cumsum(rnorm(n, mean = 0.5, sd = 2)),
#   satellites_launched = cumsum(rnorm(n, mean = 0.4, sd = 2.5))
# )
# trend_data %>% summarise(cor = cor(umbrellas_sold, satellites_launched))

## Question 2: Try at least three different seeds. How much does the
## correlation bounce around from one seed to the next?

## Question 3: Set mean = 0 in BOTH rnorm() calls (no drift in either
## direction) and re-run. What happens to the correlation, and why?


# Confounding Variables ---------------------------------------------------

## From the slides: does square footage really make price-per-square-foot
## cheaper, or is property_type doing the work?

redfin_main %>%
  summarise(cor = cor(square_feet, ppsf, use = "complete.obs"))

redfin_main %>%
  group_by(property_type) %>%
  summarise(cor = cor(square_feet, ppsf, use = "complete.obs"))

## Breakout: Is property_type Confounding This Too? --------------------------

## Question 1: Compute the overall correlation between beds and price.
# redfin_main %>%
#   summarise(cor = cor(beds, price))

## Question 2: Now compute that same correlation within each property_type.
# redfin_main %>%
#   group_by(property_type) %>%
#   summarise(cor = cor(beds, price))

## Question 3: Does the within-group correlation stay close to the overall
## number, or move a lot? Repeat Questions 1-2 for metro_distance and price.

## Question 4: Based on what you found, is property_type confounding
## beds-and-price the way it confounded square_feet-and-ppsf? Why or why not?


# Selection Bias -----------------------------------------------------------

## From the slides: an applicant pool where ability drives both SAT score
## and college GPA.
set.seed(22)
n_applicants <- 2000

applicants <- tibble(
  ability = rnorm(n_applicants),
  sat_score = round(1000 + 180 * ability + rnorm(n_applicants, 0, 90)),
  college_gpa = round(3.0 + 0.35 * ability + rnorm(n_applicants, 0, 0.4), 2)
) %>%
  mutate(sat_score = pmin(pmax(sat_score, 400), 1600),
         college_gpa = pmin(pmax(college_gpa, 0), 4.3))

applicants %>%
  summarise(cor = cor(sat_score, college_gpa))

admitted <- applicants %>%
  filter(sat_score >= quantile(sat_score, 0.90))

admitted %>%
  summarise(n = n(), cor = cor(sat_score, college_gpa))


# Simpson's Paradox ---------------------------------------------------------

## From the slides: a 1986 kidney stone treatment study (Charig et al.).
kidney_stones <- tribble(
  ~treatment,      ~stone_size,     ~success, ~total,
  "Open surgery",  "Small stones",  81,       87,
  "Percutaneous",  "Small stones",  234,      270,
  "Open surgery",  "Large stones",  192,      263,
  "Percutaneous",  "Large stones",  55,       80
)

## Breakout: Stress-Testing the Kidney Stone Example --------------------------

## Question 1: Recompute the success rate within each stone size, and the
## pooled success rate across both. Check that your numbers match the slides.
# kidney_stones %>%
#   mutate(success_rate = percent(success / total, accuracy = 1))
#
# kidney_stones %>%
#   group_by(treatment) %>%
#   summarise(success = sum(success), total = sum(total)) %>%
#   mutate(success_rate = percent(success / total, accuracy = 1))

## Question 2: Suppose percutaneous had instead been used on large stones
## just as often as open surgery, instead of only 23% of the time. Would you
## still expect a reversal when you pool? Why or why not? (Discuss -- no
## code required.)

## Question 3: In your own words, what has to be true about how patients
## were assigned to treatment for Simpson's paradox to show up here?
## (Discuss -- no code required.)
