# Rscript: "01_Load_house_prices_data.R"
library(readxl)
library(here)
library(dplyr)
library(janitor)

if(!dir.exists("data")){dir.create("data")}

files <- list.files(pattern = ".xls$", recursive = TRUE)
files

# 1-2 Annual Price change 
# Load in first "Annual price change" .xls file
# Latest published month: DEC2023
# Figure_1__Average_UK_house_prices_fell_in_the_12_months_to_December_2023_(provisional_estimate).xls
Annual_change_house_price_raw <- read_excel(here("data","Figure_1__Average_UK_house_prices_fell_in_the_12_months_to_December_2023_(provisional_estimate).xls"), 
                                        sheet = 1,
                                        skip = 6) %>% 
                             clean_names()

Annual_change_house_price_raw
names(Annual_change_house_price_raw)

# Rename default column names
Price_change <- Annual_change_house_price_raw %>% 
                select (Date = month, 
                        Price_change = x12_month_percentage_change)
Price_change
# Convert required numeric columns as numeric 
# This will turn the variable into double as required (double)
Price_change[,2] <- as.numeric(Price_change$Price_change)
Price_change

head(Price_change)
tail(Price_change)
# 2-2 Annual average house price
# Load in second "Average house price" .xls file
# Latest published month: DEC2023
# Figure_2__The_average_UK_house_price_was_£285,000_in_December_2023_(provisional_estimate).xls
Average_house_price_raw <- read_excel(here("data", "Figure_2__The_average_UK_house_price_was_£285,000_in_December_2023_(provisional_estimate).xls"), 
                                  sheet = 1,
                                  skip = 6) %>% 
                       clean_names()

Average_house_price_raw

# Rename default column names
Average_house_price <- Average_house_price_raw %>% 
                 select(Date = month, 
                        Average_price = uk_average_house_price)
Average_house_price
# This will turn the variable into double as required (double)
Average_house_price[,2] <- as.numeric(Average_house_price$Average_price)
Average_house_price

head(Average_house_price)
tail(Average_house_price)

## Final datasets
## Price_change (Annual_price_change data)
## Average_house_price (Average)house_price)
rm(Annual_change_house_price_raw)
rm(Average_house_price_raw)