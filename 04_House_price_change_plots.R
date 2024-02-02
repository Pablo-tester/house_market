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

# 1. Subset data from House_price set and turn long into wider format
# Using privot_longer() from dplyr package
Price_change_data <- House_price %>% 
  select(datef,YoY_perc_change = YoY_percr,
         MoM_perc_change = MoM_percr)%>% 
  pivot_longer(cols = !datef,
               names_to = "metric",values_to = "percent")
Price_change_data

# 2. Plot price MoM and YoY price change over time
yoy_perc_change <-ggplot(data = Price_change_data, aes( x = datef, y = percent, color = metric )) + 
  geom_line() +
  labs(title ="UK Average house prices into reverse from last year all time high",
       subtitle = "UK YoY percent price change",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) +
  theme_bw()
yoy_perc_change


ggsave(paste0("plots/02_UK_MoM_and_YoY_percent_price_change_NOV2023.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")

# 3. INCLUDE NEW LABEL FOR METRICS 
# 3.1 Change legend text labels

# 3.1.1 We need to create a new variable
# Recode "metric" variable into a new variable
Price_change_labels <- Price_change_data %>% 
                       select(datef,metric,percent) %>% 
                       mutate(metric_label = recode(metric,
                                                    YoY_perc_change = "YoY percent change",
                                                    MoM_perc_change = "MoM percent change"))
Price_change_labels

# 3.1.2 So then we can use this new variable as label
yoy_perc_change_label <-ggplot(data = Price_change_labels, aes( x = datef, y = percent, color = metric_label )) + 
  geom_line() +
  labs(title ="UK Average house prices into reverse from last year all time high",
       subtitle = "UK YoY percent price change",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) +
  theme_bw()
yoy_perc_change_label

ggsave(paste0("plots/03_UK_MoM_and_YoY_percent_price_change_NOV2023_LABELS.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")

# 3.2 Remove  Change legend text labels main text and place legend inside the chart

Price_change_labels <- Price_change_data %>% 
  select(datef,metric,percent) %>% 
  mutate(metric_label = recode(metric,
                               YoY_perc_change = "YoY percent change",
                               MoM_perc_change = "MoM percent change"))
Price_change_labels

# 3.1.2 So then we can use this new variable as label and also remove label title

yoy_perc_change_label <-ggplot(data = Price_change_labels, aes( x = datef, y = percent, color = metric_label )) + 
  geom_line() +
  labs(title ="UK Average house prices into reverse from last year all time high",
       subtitle = "UK YoY percent price change",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) +
  theme_bw() + 
  theme(
    # legend position = "none", "left", "right", "bottom","top"
    # legend.position = c(X,Y)
    legend.position = c(.88,.15),
    legend.title=element_blank()) # removed legend title
yoy_perc_change_label

ggsave(paste0("plots/03_UK_MoM_and_YoY_percent_price_change_NOV2023_LEGEND_POSITION.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")

