# 03_House_prices_calc

# This script will include calculations required to analyse UK house prices

source('01_Load_house_prices_data.R')
source('02_House_data_EDA.R')

library(tidyverse)

# 1. Keep just these two data sets
# Average_priced
# Price_changed

rm(list=ls()[! ls() %in% c("Average_priced","Price_changed")])

# 2. Compute MoM and YoY price change

library(stats)  # lag function

rm(list=ls()[! ls() %in% c("Average_priced")])

head(Average_priced)

House_price <- Average_priced %>%  
               mutate(
                 MoM_n = Avg_price - lag(Avg_price,1),
                 MoM_perc = ((Avg_price - lag(Avg_price,1))/lag(Avg_price,1)*100),
                 MoM_percr = round(((Avg_price - lag(Avg_price,1))/lag(Avg_price,1)*100),2),
                 YoY_n = Avg_price - lag(Avg_price,12),
                 YoY_perc = ((Avg_price - lag(Avg_price,12))/lag(Avg_price,12)*100),
                 YoY_percr = round(((Avg_price - lag(Avg_price,12))/lag(Avg_price,12)*100),2),
                 Price_change = ifelse(MoM_perc < 0,"Falling price","Price Increse")
                 # ifelse(a %% 2 == 0,"even","odd")
               )
House_price 

# Check start end Average house price time series
head(House_price)
tail(House_price)

# 3. Subset data for MoM and YoY prrice change and turn long into wider format
House_price_change <- House_price %>% select(datef,MoM_perc = MoM_percr,YoY_perc = YoY_percr)
House_price_change

# 3.1 transform data from wide into long
# Using privot_longer() from dplyr package
Price_changel <- House_price_change %>% 
                 pivot_longer(cols = !datef,
                              names_to = "metric",values_to = "percent")
Price_changel

tail(Price_changel)

# 4. Plot price MoM and YoY price change over time
Latest_data <- Price_changel %>% 
               mutate(Max_Date = max(datef)) %>% 
               mutate(Latest_month = ifelse(datef==Max_Date,1,0))
Latest_data

tail(Latest_data)

MoM_perc_change <-ggplot(data = Price_changel, aes( x = datef, y = percent, color = metric )) + 
  geom_line() +
  labs(title ="UK Average house prices into reverse from last year all time high",
       subtitle = "UK MoM and YoY percent price change. Latest data September 2023",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) 
  theme_bw()
MoM_perc_change

ggsave(paste0("plots/01_UK_MoM_and_YoY_percent_price_change.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")

# Include year to facet by year
library(lubridate)

Price_change_year <- Price_changel %>% 
                     mutate(
                       year = year(datef),
                       month = month(datef))  
Price_change_year


# 5. Identify Expansive and contraction house prices periods

# 5.1 Setup a rule: 
# If YoY percent change (lag 1) is lower that (YoY current percent change) tag = "Increse" otherwise "decrease"

Cycles <- Price_change_year %>% 
              filter(metric == "YoY_perc") %>% 
              mutate(
                Trend = ifelse(percent - lag(percent,1) <0,"decrease","increase")
              )
Cycles

