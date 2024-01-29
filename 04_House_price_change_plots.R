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


# 4. INCLUDE LATEST VALUES AS DOT PLOTS AT THE END OF THE LINE CHARTS 
# wip

# Dataset: Price_change_labels

# 3.1 Create labels for latest data points 
House_price_max_date <- Price_change_data %>%  select(datef,metric,percent)
endv <- House_price_max_date %>% filter(datef == max(datef))
endv

# yoy_perc_change_my <-ggplot(data = Price_changel_my, aes( x = datef, y = percent, color = metric )) + 
perc_change_dot  <-ggplot(data = Price_change_data, aes( x = datef, y = percent, color = metric )) + 
  geom_line() +
  labs(title ="UK Average house prices showing negative growth rates since 2011. November 2023 data.",
       subtitle = "UK YoY and MoM percent price change",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) +
  theme_bw()
perc_change_dot



# datef      metric          percent
# <date>     <chr>             <dbl>
#  1 2023-11-01 YoY_perc_change   -2.11
# 2 2023-11-01 MoM_perc_change   -0.82

# Now we use geom_text() function to include those end values

Endv_plot <- ggplot(data = Price_changel_my) +
             geom_line() +
             labs(title ="UK Average house prices showing negative growth rates since 2011. November 2023 data.",
             subtitle = "UK YoY and MoM percent price change",
             # Change X and Y axis labels
             x = "Year", y = "House price change (%)" ) +
             theme_bw()

Endv_plot








# 6. Adding annotations to the chart 

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
