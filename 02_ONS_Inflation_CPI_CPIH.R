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