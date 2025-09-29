# Script: 10_Load new private and house prices ONS publication.R

#  - Private rent and house prices, UK: September 2025. (This is the latest release):
#  https://www.ons.gov.uk/economy/inflationandpriceindices/bulletins/privaterentandhousepricesuk/september2025

# Downloaded Excel file (.xls) from Figure 1: UK private rent and house prices

# Load required libraries
library(here)
library(dplyr)
library(ggplot2)
library(janitor)
library(readxl)

# 1. Load private rents index and house price index
# 1.1  It is located inside \data_UK_House_Price_Index folder 
here()
Excel_input_file <- list.files(path = "./data_UK_House_Price_Index", pattern = "xlsx$")

# [1] "ukhousepriceindexmonthlypricestatistics.xlsx"

# 1.2 Check sheet names from above Excel file: 
# excel_sheets() is part of {readxl} package:
path_to_file <- paste0("./data_UK_House_Price_Index/",Excel_input_file)
path_to_file

excel_sheets(path_to_file)

# > excel_sheets(path_to_file)
# [1] "Cover sheet" "Contents"    "Notes"       "1"           "2"           "3"           "4"          
# [8] "5"           "6"           "7"           "8"           "9"           "10"          "11" 

# 1.3 Import Excel data into R
# I will import data from sheet “2” where column “United Kingdom” includes UK Average House price 
# from 2011 to July 2025.
# - I will be importing data from row 3 until row 178 on Excel Sheet “2” from
# “ukhousepriceindexmonrthlypricestatistic.xlsx” Excel file. 
House_price_file_contents <- read_excel(here("data_UK_House_Price_Index","ukhousepriceindexmonthlypricestatistics.xlsx"),
                                   sheet = 2, 
                                   skip = 2,
                                   n_max = 178, col_names = TRUE) %>% 
                             clean_names()
House_price_file_contents

# Import data from fifth tab in the Excel file:
House_price_data_raw <- read_excel(here("data_UK_House_Price_Index","ukhousepriceindexmonthlypricestatistics.xlsx"),
                                        sheet = 5, 
                                        skip = 2,
                                        n_max = 178, col_names = TRUE) %>% 
                         clean_names()
House_price_data_raw

head(House_price_data_raw)
tail(House_price_data_raw)
names(House_price_data_raw)

# 2. Subset data for United Kingdom and create a quick chart
# 2.1 Build new date variables as strings from initial time_period column in original dataset 
library(stringr)

# IMPORTANT !!! 
# I need to account for these dates  "Jul 2024 [r]" 
# This [r] is not working with the above data manipulation !
UK_house_price <- House_price_data_raw %>% select(time_period,united_kingdom) %>% 
                  mutate(
                    day = '01',
                    year = str_sub(time_period, -4, -1),
                         month = str_sub(time_period, 1,3)) 
UK_house_price

# 3.Now I can turn the above three columns "day", "month" and "year" into a Date column using {lubridate}
library(lubridate)
UK_house_price <- UK_house_price %>%  mutate(date = paste0(year,"/",month,"/",day))
# Parse dates using lubridate
UK_house_price <- UK_house_price %>%  mutate(date_fmt = ymd(date))
str(UK_house_price)

UK_house_price_plot_data <- UK_house_price %>% select(date_fmt,united_kingdom)
UK_house_price_plot_data

str(UK_house_price_plot_data)

# 4. Plot UK house price time series data
min_date <- min(UK_house_price_plot_data$date_fmt)
max_date <- max(UK_house_price_plot_data$united_kingdom)

install.packages("wesanderson",dependencies = TRUE)
library(wesanderson)

# Setup color palette manually
# scale_color_manual(values = c("#00AFBB", "#E7B800", "#FC4E07"))
install.packages("viridis",dependencies = TRUE)
library(viridis)

UK_monthly_house_price_plot <- ggplot(data = UK_house_price_plot_data, aes( x = date_fmt, y = united_kingdom)) + 
  geom_line(color = "mediumpurple2") +
   labs(title ="UK Average house prices into reverse from last year all time high",
       subtitle = "Source:ONS.Private rent and house prices, UK: September 2025",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) +
 scale_y_continuous(breaks = seq(0,300000, by = 20000)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  scale_color_viridis(discrete=TRUE) +
  theme_bw() + 
  theme(legend.position = c(.88,.15),
    legend.title=element_blank()) # removed legend title
UK_monthly_house_price_plot

ggsave(paste0("plots/18_Average_UK_House_Price_ONS_private_rent_and_house_prices_SEP2025.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")
