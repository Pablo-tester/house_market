# 04_House_price_change_plots
source('01_Load_house_prices_data.R')
source('02_House_data_EDA.R')
source('03_House_prices_calculations.R')

library(tidyverse)
library(here)

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

# 3. Subset data for MoM price change and turn long into wider format
House_price_change <- House_price %>% select(datef,YoY_perc = YoY_percr)
House_price_change

# 3.1 transform data from wide into long
# Using privot_longer() from dplyr package
Price_changel <- House_price_change %>% 
  pivot_longer(cols = !datef,
               names_to = "metric",values_to = "percent")
Price_changel

# 4. Plot price MoM and YoY price change over time

yoy_perc_change <-ggplot(data = Price_changel, aes( x = datef, y = percent, color = metric )) + 
  geom_line() +
  labs(title ="UK Average house prices into reverse from last year all time high",
       subtitle = "UK YoY percent price change",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) +
  theme_bw()
yoy_perc_change

# 5. Create plot including both MoM and YoY percent change chart
House_price_change_my <- House_price %>% select(datef,YoY_perc_change = YoY_percr,
                                                MoM_perc_change = MoM_percr)
House_price_change_my

# 5.1 transform data from wide into long
# Using privot_longer() from dplyr package
Price_changel_my <- House_price_change_my %>% 
  pivot_longer(cols = !datef,
               names_to = "metric",values_to = "percent")
Price_changel_my

# RE_DESIGNING THIS PLOT TO INCLUDE END OF YEAR VALUE
head(Price_changel_my)
tail(Price_changel_my)


yoy_perc_change_my <-ggplot(data = Price_changel_my, aes( x = datef, y = percent, color = metric )) + 
  geom_line() +
  labs(title ="UK Average house prices showing negative growth rates since 2011. November 2023 data.",
       subtitle = "UK YoY and MoM percent price change",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) +
  theme_bw()
yoy_perc_change_my

ggsave(paste0("plots/03_UK_MoM_and_YoY_percent_price_change_NOV2023.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")

# Write Price_changel_my data set (Long format) into a .csv file: 

write.csv(Price_changel_my,here("data","UK_MoM_and_YoY_perc_price_change_NOV23.csv"), row.names = TRUE)

# RE-DESIGNING THIS PLOT: 

# 1. Include latest values to be use in the dot chart in combination with the line chart
# Dataset:  Price_changel_my

House_price_max_date <- Price_changel_my %>%  select(datef,metric,percent)
endv <- House_price_max_date %>% filter(datef == max(datef))
endv

# datef      metric          percent
# <date>     <chr>             <dbl>
#  1 2023-11-01 YoY_perc_change   -2.11
# 2 2023-11-01 MoM_perc_change   -0.82




# 6. Include annotations in the chart

# Include a shadowed area:
# https://ggplot2.tidyverse.org/reference/annotate.html

# 6.1 Include a Horizontal line
yoy_annotations <-ggplot(data = Price_changel, aes( x = datef, y = percent, color = metric )) + 
  geom_line() +
  labs(title ="UK Average house prices into reverse from last year all time high",
       subtitle = "UK YoY percent price change",
       x = "Year", y = "House price change (%)" ) +
  # Include a Horizontal line in the chart
  geom_hline(yintercept = 8) +
  theme_bw()
yoy_annotations

# 6.2 Include a vertical reference line

# Try as.numeric(mydata$datefield[120]):
# https://stackoverflow.com/questions/5388832/how-to-get-a-vertical-geom-vline-to-an-x-axis-of-class-date
yoy_annotations <-ggplot(data = Price_changel, aes( x = datef, y = percent, color = metric )) + 
  geom_line() +
  labs(title ="UK Average house prices into reverse from last year all time high",
       subtitle = "UK YoY percent price change",
       x = "Year", y = "House price change (%)" ) +
  # Include a Vertical line in the chart
  geom_vline(xintercept=as.numeric(Price_changel$datef[c(44,65)]),
             linetype=2, colour="black") +
  theme_bw()
yoy_annotations

ggsave(paste0("plots/Vertical_reference_line_example.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")
