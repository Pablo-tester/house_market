# 02_House_Data_EDA
# Call previous script to load in raw .xls data file
source('01_Load_house_prices_data.R')

library(tidyverse)
library(dplyr)
library(ggplot2)

# 1 Start exploring "Average_price" data set: 
head(Average_house_price)

# 1-2 Annual Price change 
Price_changed <- Price_change %>% 
                select(Date,Price_change) %>% 
                  mutate(
                    Year = substring(Date,5,8),
                    Month = substring(Date,1,3),
                    Day = 01,
                    date = paste0(Year,"/",Month,"/",Day)
                  ) %>% 
                  mutate(datef = as.Date(date, format = "%Y/%b/%d"))
Price_changed

Price_changed <- Price_changed %>% select(datef,Chnge_price = Price_change)
Price_changed

# Plot annual change in house price
CHG_HPRICE <-ggplot(data = Price_changed, aes( x = datef, y = Chnge_price)) + 
  geom_line(color="royalblue4") +
  labs(title ="UK Annual house price change in England 2005-2023. Latest data December 2023",
       subtitle = "% Annual change UK House pricess-Nationawide",
       x = "Date", y ="Price change %" ) +
  scale_y_continuous(breaks = seq(-20,20, by = 2)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  geom_hline(yintercept = 0, linewidth = 0.3)  +        # Add reference line at 0
  theme_bw()
CHG_HPRICE

ggsave(paste0("plots/Annual_house_price_change_percent.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")


# 2-2 Annual average house price
# August price data
# Year (Date, 5,8)
# Month (Date, 1,3)
Average_priced <- Average_house_price %>% 
  select(Date,Average_price) %>% 
  mutate(
    Year = substring(Date,5,8),
    Month = substring(Date,1,3),
    Day = 01,
    date = paste0(Year,"/",Month,"/",Day)
  ) %>% 
  mutate(datef = as.Date(date, format = "%Y/%b/%d"))
Average_priced

Average_priced <- Average_priced %>% select(datef,Avg_price = Average_price)
Average_priced

# Check start end Average house price time series
head(Average_priced)
tail(Average_priced)


# Plot average house prices
AVG_HPRICE <-ggplot(data = Average_priced, aes( x = datef, y = Avg_price)) + 
  geom_line(color="orange") +
  labs(title ="UK Average house price in England 2005-2023. Latest data December 2023",
       subtitle = "Average house price in pounds",
       x = "Date", y ="House price (£)") +
  scale_y_continuous(breaks = seq(150000,400000, by = 10000)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  theme_bw()
AVG_HPRICE

ggsave(paste0("plots/Average_house_price_in_pounds.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")

# 3. We can place both of the above charts on the same output chart using {gridExtra} package
install.packages("gridExtra",dependencies = TRUE)

# 3.1 Combine previous two charts for "UK Average House Price" and "UK Annual house price change" between Jan 2025 and Dec 2025

library(gridExtra)

# 2-1. Average House price data 
Min_date <- min(Average_priced$datef)
Max_date <- max(Average_priced$datef)
Min_date
Max_date

AVG_HPRICE_grid <-ggplot(data = Average_priced, aes( x = datef, y = Avg_price)) + 
  geom_line(color="orange") +
  labs(title ="UK Average house price in England 2005-2023. Jan-2005/Dec-2023",
       subtitle = "Average house price in pounds.Source: ONS Average_UK_house_prices",
       x = "Date", y ="House price (£)") +
  scale_y_continuous(breaks = seq(150000,400000, by = 10000)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  theme_bw()
AVG_HPRICE_grid

# 2.2 UK Average house price change
CHG_HPRICE_grid <-ggplot(data = Price_changed, aes( x = datef, y = Chnge_price)) + 
  geom_line(color="royalblue4") +
  labs(title ="UK Annual house price change in England. Jan-2005/Dec-2023",
       subtitle = "% Annual change UK House pricess.Source: ONS Average_UK_house_prices",
       x = "Date", y ="Price change %" ) +
  scale_y_continuous(breaks = seq(-20,20, by = 2)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  geom_hline(yintercept = 0, linewidth = 0.3)  +        # Add reference line at 0
  theme_bw()
CHG_HPRICE_grid


# Created a grid of 2 columns to display both charts on same png file
grid.arrange(AVG_HPRICE_grid,CHG_HPRICE_grid,ncol=2)
ggsave("plots/16_UK_House_prices_total_change_grid_Jan2025_Dec2023.png", width = 6, height = 4) 

