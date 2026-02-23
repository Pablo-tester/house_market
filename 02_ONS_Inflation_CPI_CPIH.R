# Script: 02_ONS_Inflation_CPI_CPIH.R

# Inflation and price indices
# The rate of inflation is the change in prices for goods and services over time. Measures of inflation and prices
# include consumer price inflation, producer price inflation and the House Price Index.
# https://www.ons.gov.uk/economy/inflationandpriceindices

# Data: ONS_CPI_DEC2025.csv, ONS_CPIH_DEC2025.csv
# UK Inflation: 

# Load required libraries
library(here)
library(dplyr)
library(ggplot2)
library(janitor)
library(readxl)

# 1. ONS. Inflation and price indices
# 1.1  It is located inside \04_House_Market_Economic_Indicators
here()
inflation_csv_input_files <- list.files(path = "./04_House_Market_Economic_Indicators", pattern = "csv$")

# [1] "BoE-Database_export_20260116.csv" "ONS_CPI_DEC2025.csv"             
# [3] "ONS_CPIH_DEC2025.csv"  

# 1.2 Check sheet names from above Excel file: 
# excel_sheets() is part of {readxl} package:
# 1.2 Load CPI .csv file into R (CPI data csv file is [2] in "inflation_csv_input_files" previous object)
CPI_file <- paste0("./04_House_Market_Economic_Indicators/",inflation_csv_input_files[2])
CPI_file

# 2. Read in Consumer Prices Index (CPI) data
CPI_yearly_data  <-read.table(CPI_file,header =TRUE, sep =',',stringsAsFactors =TRUE,
                       skip = 7,
                       nrows = 35) %>% 
            clean_names() %>% 
            select(date = important_notes, CPI = x)
names(CPI_yearly_data)

head(CPI_yearly_data)
str(CPI_yearly_data)

Min_period <- CPI_yearly_data %>% select(date) %>% min()
Max_period <- CPI_yearly_data %>% select(date) %>% max()

# 2.1 CPI Exploratory plot
# Initial exploratory plot CPI data. 

cpi_endv <- CPI_yearly_data %>% 
  select(date,CPI) %>% 
  filter(date == max(date)) 
cpi_endv

UK_House_price_yoy_perc_endv <-ggplot(data = Price_change_labels_plot, aes( x = date_fmt, y = percent, color = metric )) +   
  geom_line() +
  # Adding end value metric dot shape and label
  geom_point(data = endv, col = 'darkgray') +
  geom_text(data = endv, aes(label = percent), hjust = -0.4, nudge_x = 2) +
  labs(title ="UK Average house prices into reverse from last year all time high. July 2011-July 2025",
       subtitle = "UK YoY percent price change.Source: ONS UK House Price Index. September 2025 data",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) +
  scale_y_continuous(breaks = seq(-16,16, by = 2)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  theme_bw() + 
  geom_hline(yintercept = 0, linewidth = 0.3)  + # Add reference line at 0
  theme(
    panel.grid.minor = element_blank(), # Removing minor grid
    panel.grid.major.x = element_blank(), # Remove x axis grid 
    legend.position = c(.90,+.80),
    legend.title=element_blank()) # removed legend title
UK_House_price_yoy_perc_endv