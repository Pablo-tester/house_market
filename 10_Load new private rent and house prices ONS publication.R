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



