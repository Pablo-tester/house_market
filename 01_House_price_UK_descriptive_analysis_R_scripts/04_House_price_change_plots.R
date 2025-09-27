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
    Price_change_m = ifelse(MoM_percr < 0,"Drops","Increses"),
    Price_change_y = ifelse(YoY_percr < 0,"Drops","Increses")
    # ifelse(a %% 2 == 0,"even","odd")
  )
House_price 

# 1. Subset data from House_price set and turn long into wider format
# Using privot_longer() from dplyr package
Price_change_data <- House_price %>% 
                    select(datef,YoY_perc_change = YoY_percr,MoM_perc_change = MoM_percr)%>% 
                    pivot_longer(cols = !datef,
                                 names_to = "metric",values_to = "percent")

# 2. Plot price MoM and YoY price change over time
yoy_perc_change <-ggplot(data = Price_change_data, aes( x = datef, y = percent, color = metric )) + 
  geom_line() +
  labs(title ="UK Average house prices into reverse from last year all time high",
       subtitle = "UK YoY percent price change",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) +
  scale_y_continuous(breaks = seq(-16,16, by = 2)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  theme_bw()
yoy_perc_change


ggsave(paste0("plots/02_UK_MoM_and_YoY_percent_price_change_DEC2023.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")

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
  scale_y_continuous(breaks = seq(-16,16, by = 2)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  theme_bw()
yoy_perc_change_label

# 3.2 Remove  Change legend text labels main text and place legend inside the chart

Price_change_labels <- Price_change_data %>% 
  select(datef,metric,percent) %>% 
  mutate(metric_label = recode(metric,
                               YoY_perc_change = "YoY percent change",
                               MoM_perc_change = "MoM percent change"))
Price_change_labels

# 3.3 Re-designed chart with legends inside plot area 

yoy_perc_change_label <-ggplot(data = Price_change_labels, aes( x = datef, y = percent, color = metric_label )) + 
  geom_line() +
  labs(title ="UK Average house prices into reverse from last year all time high",
       subtitle = "UK YoY percent price change. ONS UK House Price Index: December 2023",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) +
  scale_y_continuous(breaks = seq(-16,16, by = 2)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  theme_bw() + 
  theme(
    # legend position = "none", "left", "right", "bottom","top"
    # legend.position = c(X,Y)
    legend.position = c(.88,.15),
    legend.title=element_blank()) # removed legend title
yoy_perc_change_label

ggsave(paste0("plots/03_UK_MoM_and_YoY_price_change_DEC2023_legend.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")

# 4. INCLUDE END LINE DOT VALUE
# References for this new feature 
# ggplot2-visualizations/ 14 Sparkline OECD CPI.R 
# https://github.com/Pablo-source/ggplot2-visualizations/blob/main/14%20Sparkline%20OECD%20CPI.R

# 4.1 Compute reference point (latest value) for each series (MoM and YoY percent change)
 endv <- group_by(Price_change_labels, metric) %>% filter(datef == max(datef))
 endv

 yoy_perc_endv <-ggplot(data = Price_change_labels, aes( x = datef, y = percent, color = metric_label )) + 
   
   geom_line() +
   # Adding end value metric dot shape and label
   geom_point(data = endv, col = 'darkgray') +
   geom_text(data = endv, aes(label = percent), hjust = -0.4, nudge_x = 2) +
  
   labs(title ="UK Average house prices into reverse from last year all time high",
        subtitle = "UK YoY percent price change. ONS UK House Price Index: December 2023",
        # Change X and Y axis labels
        x = "Year", y = "House price change (%)" ) +
   scale_y_continuous(breaks = seq(-16,16, by = 2)) +
   scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
   theme_bw() + 
   theme(
     # legend position = "none", "left", "right", "bottom","top"
     # legend.position = c(X,Y)
     legend.position = c(.88,.15),
     legend.title=element_blank()) # removed legend title
 
 yoy_perc_endv
 
 ggsave(paste0("plots/03_UK_MoM_and_YoY_price_change_DEC2023_env_MARK.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")
 