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
# [1] 1989
Max_period <- CPI_yearly_data %>% select(date) %>% max()
# [1] 2023

# 2.1 CPI Exploratory plot
# Initial exploratory plot CPI data. 

cpi_endv <- CPI_yearly_data %>% 
  select(date,CPI) %>% 
  filter(date == max(date)) 
cpi_endv

UK_CPI_yearly_plot <-ggplot(data = CPI_yearly_data, aes( x = date, y = CPI)) +   
  geom_line(color = "orange") +
  # Adding end value metric dot shape and label
  geom_point(data = cpi_endv, col = 'darkgray') +
  geom_text(data = cpi_endv, aes(label = CPI), hjust = +0.9, nudge_x = 2) +
  labs(title ="UK Inflaction CIP Index. 1989-2023",
       subtitle = "UK Inflation CPI yearly data. Source:ONS economy,inflation and price indices") +
theme_bw() +
  geom_hline(yintercept = 0, linewidth = 0.3) +   # Add reference line at 0
theme(                                            # Add theme to plot
  panel.grid.major.x = element_blank(), # Remove x axis grid 
  legend.position = c(.90,+.80),
  legend.title=element_blank()) # removed legend title
UK_CPI_yearly_plot

# Save CPI plot
ggsave(paste0("Economic_indicators_plots/01_UK_CPI_index_yearly_data_1989_2023_period.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")

