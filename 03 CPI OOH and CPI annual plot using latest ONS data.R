# 02 CPI Inflation plot Jan2026.R
# Download them from ONS source: 
#  https://www.ons.gov.uk/economy/inflationandpriceindices/bulletins/consumerpriceinflation/latest
# - Download data as .xls 

# AIM: Replicate Figure 1: CPI annual inflation rate lowest since March 2025 chart


# Script sections
# 1. ONS data for Inflation indicators are .xls files
# 2. List tabs from above Excel file to know which tab to import 
# 3 Read in Excel .xls file into R
# 4. Give name to date column currently just x1
# 5. Then pivot data from Wide to Long Format WIP


# Use readxl package to read in .xls files
# use DPLYR package for data manipulation
# Use ggplot2 for plots
# Also use here package to create relative paths
# Also use janitor package to create consistent column names

if(!require("readxl")) install.packages("readxl",dependencies = TRUE)
if(!require("ggplot2")) install.packages("ggplot2",dependencies = TRUE)
if(!require("here")) install.packages("here",dependencies = TRUE)
if(!require("janitor")) install.packages("janitor",dependencies = TRUE)
# Install also pacman
if(!require("pacman")) install.packages("pacman",dependencies = TRUE)

# Using pacman to load several packages instead of library(readxl),library(ggplot2)
pacman::p_load(readxl,here,dplyr,janitor,tidyverse,ggplot2,gridExtra,lubridate)

# Somehow that didn't work, try standard library: (this works fine)
library(readxl)
library(here)
library(janitor)
library(ggplot2)
library(dplyr)
library(tidyr) # To use_pivot_longer()

# 1. ONS data for Inflation indicators are .xls files
ONS_Inflation_files <-list.files (path = "./data" ,pattern = "xls$")
ONS_Inflation_files
# [1] "Figure_1__CPIH_and_CPI_annual_inflation_rates_rose_for_the_first_time_since_July_2025.xls"

# 2. List tabs from above Excel file to know which tab to import 
excel_sheets("./data/Figure_1__CPIH_and_CPI_annual_inflation_rates_rose_for_the_first_time_since_July_2025.xls")
# [1] "data"

# 3 Read in Excel .xls file into R
Inflation_rates <- read_excel(here("data","Figure_1__CPIH_and_CPI_annual_inflation_rates_rose_for_the_first_time_since_July_2025.xls"), sheet = 1,
                              skip = 6,
                              col_types = c("text", "numeric", "numeric", "numeric")) %>% 
  clean_names()
Inflation_rates

# 4. Give name to date column currently just x1
names(Inflation_rates)

Inflation_rates_raw <- Inflation_rates %>% select( "date" = "x1", "cpih", "cpi", "ooh")
Inflation_rates_raw
names(Inflation_rates_raw)
head(Inflation_rates_raw)

# 5. Then pivot data from Wide to Long Format WIP
Inflation_rates_long <- Inflation_rates_raw %>% 
                        pivot_longer(names_to = "Indicator",cols = 2:ncol(Inflation_rates_raw)) 

Inflation_rates_long

# 6. Create R Date formatted field using > mutate(datef = as.Date(date, format = "%d/%b/%Y"))
# See how it is done in my repo
# using "Inflation_rates_long" input dataset

# using substring() function from stringr pacakge
#install.packages("stringr")

library(stringr)

# Extrac year from the end  -8, -5

nchar(Inflation_rates_long$date)

Inflation_inc_dates <- Inflation_rates_long %>% 
  select(date,Indicator,value) %>% 
                       mutate(
                              year =str_sub(date, -4, -1) ,  # Extract 4 characters from string, starting from the back (-1)
                              month = str_sub(date, 1,3),    # This ensures all Months have THREE characters (jan,feb,mar,apr) IMPORTANT
                              day = 01,
                              date_comb = paste0(day,"/",month,"/",year)
                        ) %>% 
                      mutate(datef = as.Date(date_comb, format ="%d/%b/%Y"))
Inflation_inc_dates

# 7. Inflation dataframe for plots with formatted daet

Inflation_plot_data <- Inflation_inc_dates %>% select(datef,Indicator,value) 
Inflation_plot_data

# 8. Subset each indicator


# 8 PLOT

# 8.1 All three Inflation measures combined
#  aes(colour = Indicator, group = Indicator)
Inflation_plot_single <- Inflation_plot_data %>% 
  ggplot() +
  geom_line(aes(datef, value, colour = Indicator, group = Indicator)) +
  theme_light() +
  labs(title = "UK Inflation measures - December 2025",
       subtitle ="CPI: Consumer Prices Index, CPIH: Consumer Prices Index including owner occupiers' housing costs, OOH: Owner Occupiers' Housing Costs",
       caption = "ONS: Consumer price inflation, UK: December 2025:https://www.ons.gov.uk/economy/inflationandpriceindices/bulletins/consumerpriceinflation/latest",
       y = NULL,colour = NULL, fill = NULL) 
  
Inflation_plot_single

ggsave("plots/01_UK_inflation_indicators_.png", width = 10, height = 4)

# 8.2 Each indicator on a different pane
Inflation_plot_panel <-  Inflation_plot_data %>% 
  ggplot( fill = Indicator) +
  geom_line(aes(datef,value,colour = Indicator, group = Indicator)) +
  facet_wrap(~ Indicator, nrow = 2) +
theme_light() +
  labs(title = "UK Inflation measures - December 2025",
       subtitle ="CPI: Consumer Prices Index, CPIH: Consumer Prices Index including owner occupiers' housing costs, OOH: Owner Occupiers' Housing Costs",
       caption = "ONS: Consumer price inflation, UK: December 2025:https://www.ons.gov.uk/economy/inflationandpriceindices/bulletins/consumerpriceinflation/latest",
       y = NULL,colour = NULL, fill = NULL) 
Inflation_plot_panel

ggsave("plots/02_UK_inflation_indicators_facet_plot.png", width = 10, height = 4)

# 8.3 Single chart with three lines one for each indicator
#    # Apply legend format here - change default colours to black and blue using "scale_colour_manual()" function.
# scale_colour_manual(values = c("blue", "black"),
#                    labels = c("Part Time employment rate (%)","Unemployment rate (%)"))
#

# Green colour: #00ACAB
# Purple colour: #B04968
# Violet colour: #7061A9
my_palette <- c("#00ACAB","#B04968","#7061A9")

Inflation_plot_colour_manual <- Inflation_plot_data %>% 
  ggplot( fill = Indicator) +
  geom_line(aes(datef, value, colour = Indicator, group = Indicator )) +
  theme_light() +
  labs(title = "UK Inflation measures - December 2025",
       subtitle ="CPI: Consumer Prices Index, CPIH: Consumer Prices Index including owner occupiers' housing costs, OOH: Owner Occupiers' Housing Costs",
       caption = "ONS: Consumer price inflation, UK: December 2025:https://www.ons.gov.uk/economy/inflationandpriceindices/bulletins/consumerpriceinflation/latest",
       y = NULL,colour = NULL, fill = NULL) +
  # Now we use scale_colour_manual() to apply custom colours 
  scale_colour_manual(values = my_palette,
                      labels = c("cpi","cpih","ooh"))
Inflation_plot_colour_manual

ggsave("plots/03_UK_inflation_indicators_custom_colours.png", width = 10, height = 4)

