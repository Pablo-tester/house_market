# 02_House_Data_EDA
# Call previous script to load in raw .xls data file
source('01_Load_house_prices_data.R')

library(tidyverse)
# 1 Start exploring "Average_price" data set: 

head(Average_price)

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
  labs(title ="UK Annual house price change in England 2005-2023",
       subtitle = "House price change percent") +
  theme_bw()
CHG_HPRICE

ggsave(paste0("plots/Annual_house_price_change_percent.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")


# 2-2 Annual average house price
Average_priced <- Average_price %>% 
  select(Date,Average_price) %>% 
  mutate(
    Year = substring(Date,1,4),
    Month = substring(Date,6,8),
    Day = 01,
    date = paste0(Year,"/",Month,"/",Day)
  ) %>% 
  mutate(datef = as.Date(date, format = "%Y/%b/%d"))
Average_priced

Average_priced <- Average_priced %>% select(datef,Avg_price = Average_price)
Average_priced


# Plot average house prices
AVG_HPRICE <-ggplot(data = Average_priced, aes( x = datef, y = Avg_price)) + 
  geom_line(color="dodgerblue") +
  labs(title ="UK Average house price in England 2005-2023",
       subtitle = "Average house price in pounds") +
  theme_bw()
AVG_HPRICE

ggsave(paste0("plots/Average_house_price_in_pounds.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")

