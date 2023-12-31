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

# 1-2 Annual Price change 

# Load in first "Annual price change" .xls file
# Latest published month: SEP2023
Annual_change_house_price <- read_excel(here("data","Figure_1__Average_UK_house_prices_were_little_changed_in_the_12_months_to_September_2023_(provisional_estimate)_.xls"), 
                                        sheet = 1,
                                        skip = 6) %>% 
                             clean_names()

Annual_change_house_price
names(Annual_change_house_price)

# Rename default column names
Price_change <- Annual_change_house_price %>% 
                select (Date = x1, 
                        Price_change = x12_month_percentage_change)
Price_change


# Convert required numeric columns as numeric 
# This will turn the variable into double as required (double)
Price_change[,2] <- as.numeric(Price_change$Price_change)
Price_change

# 2-2 Annual average house price
# Load in second "Average house price" .xls file
# Latest published month: SEP2023
Average_house_price <- read_excel(here("data", "Figure_2__The_average_UK_house_price_was_£291,000_in_September_2023_(provisional_estimate).xls"), 
                                  sheet = 1,
                                  skip = 6) %>% 
                       clean_names()

Average_house_price

# Rename default column names
Average_price <- Average_house_price %>% 
                 select(Date = x1, 
                        Average_price = uk_average_house_price)
Average_price

# This will turn the variable into double as required (double)
Average_price[,2] <- as.numeric(Average_price$Average_price)
Average_price

head(Average_price)
tail(Average_price)