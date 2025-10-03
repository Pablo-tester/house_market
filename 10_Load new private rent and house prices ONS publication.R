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

# 2. Address latest rows containing 1 Feb 2025 [r] character in "time_period" column: 
Original_date_fix <- House_price_data_raw

time_period_values <- Original_date_fix %>% select(time_period) %>% distinct()

# From row 163 to row 175, time_period column contains an extra [r] character:
# I will split initial Original_date_fix into two halves to fix rows with trailing character

names(House_price_data_raw)

fixing_time_period_01 <- House_price_data_raw %>% 
                            mutate(date_clean =  str_sub(time_period, 1, 8)) %>% 
                            select(date_clean,united_kingdom,great_britain,england,wales,scotland,northern_ireland_note_3,
                                   north_east,north_west,yorkshire_and_the_humber,east_midlands,west_midlands,east,london,south_east,south_west)

fixing_time_period_01

# 3. CREATE NEW DATE FORMAT VARIABLE USING LUBRIDATE

# 3.1 Use str_sub() function from {stringr} package  to create individual day month year variables from initial date_clean string variable

# I need to account for these dates  "Jul 2024 [r]" 
# This [r] is not working with the above data manipulation !
library(stringr)


fixing_time_period_02 <- fixing_time_perio_01 %>% 
                  mutate(
                    day = '01',
                    year = str_sub(date_clean, -4, -1),
                         month = str_sub(date_clean, 1,3)) 
fixing_time_period_02

# 3.2 Then using ymd() function from  {lubridate} package, build the date format new date variable.

# Now I can turn the above three columns "day", "month" and "year" into a Date column using {lubridate}
library(lubridate)
fixing_time_period_03 <- fixing_time_period_02 %>%  mutate(date = paste0(year,"/",month,"/",day))

names(fixing_time_period_03)

#[1] "date_clean"               "united_kingdom"           "great_britain"            "england"                  "wales"                    "scotland"                 "northern_ireland_note_3" 
#[8] "north_east"               "north_west"               "yorkshire_and_the_humber" "east_midlands"            "west_midlands"            "east"                     "london"                  
#[15] "south_east"               "south_west"               "day"                      "year"                     "month"                    "date"   

# Parse dates using ymd() lubridate function:
fixing_time_period_04 <- fixing_time_period_03 %>%  
                         mutate(date_fmt = ymd(date)) %>% 
                         select(date_fmt,date,day,month,year,
                                united_kingdom,great_britain,england,wales,scotland,northern_ireland_note_3,
                                north_east,north_west,yorkshire_and_the_humber,east_midlands,west_midlands,east,london,south_east,south_west)
fixing_time_period_04                     

data_UK_House_Price_Inde_cleansed <- fixing_time_period_04

# 3.3 Save this date formatted dataframe as .csv file 
# Save time period formatted column dataframe in a new "cleansed_data" sub-folder in my WD
here()
if(!dir.exists("cleansed_data")){dir.create("cleansed_data")}
write.csv(data_UK_House_Price_Inde_cleansed,here("cleansed_data","data_UK_House_Price_Inde_cleansed.csv"), row.names = TRUE)


# 4. Split initial House Price index dataset into different geographies

# 4.1 United Kingdom
UK_House_price_fmted <- fixing_time_period_04 %>% select(date_fmt,united_kingdom)
write.csv(UK_House_price_fmted,here("cleansed_data","UK_House_price_fmted.csv"), row.names = TRUE)

# 4.2 Great Britain
GB_House_price_fmted <- fixing_time_period_04 %>% select(date_fmt,great_britain)
write.csv(GB_House_price_fmted,here("cleansed_data","GB_House_price_fmted.csv"), row.names = TRUE)

# 4.3 GB Countries - England, Wales, Scotland
COUNTRIES_House_price_fmted <- fixing_time_period_04 %>% select(date_fmt,england,wales,scotland,northern_ireland_note_3)
write.csv(COUNTRIES_House_price_fmted,here("cleansed_data","COUNTRIES_House_price_fmted.csv"), row.names = TRUE)

# 4.4 Regions
REGIONS_House_price_fmted <- fixing_time_period_04 %>% select(date_fmt,north_east,north_west,yorkshire_and_the_humber,east_midlands,west_midlands,east,london,south_east,south_west)
write.csv(REGIONS_House_price_fmted,here("cleansed_data","REGIONS_House_price_fmted.csv"), row.names = TRUE)

# Remove previous dataframes. Keeping just House_price_data_raw and UK_House_price_fmted,GB_House_price_fmted,COUNTRIES_House_price_fmted,REGIONS_House_price_fmted
rm(list=ls()[! ls() %in% c("House_price_data_raw","UK_House_price_fmted","GB_House_price_fmted","COUNTRIES_House_price_fmted","REGIONS_House_price_fmted")])

# 5. Plot house price data for UK 
# 5. Plot UK house price time series data
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
