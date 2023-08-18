# 1 Load house prices data into R
library(readxl)
library(here)
library(dplyr)
library(janitor)

if(!dir.exists("data")){dir.create("data")}

files <- list.files(pattern = ".xls$", recursive = TRUE)
files

# [1] "data/Figure_1__Average_UK_house_price_annual_change_was_1.9%_in_the_12_months_to_May_2023_(provisional_estimate)_.xls"
# [2] "data/Figure_2__The_average_UK_house_price_was_£286,000_in_May_2023_(provisional_estimate).xls"
# 1 sheet(s) found.

House_price_data <- read_excel(here("data", "Figure_2__The_average_UK_house_price_was_£286,000_in_May_2023_(provisional_estimate).xls"), sheet = 1) %>% 
  clean_names()

House_price_data