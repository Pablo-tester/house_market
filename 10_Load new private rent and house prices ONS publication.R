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

# 2 Split Dataframe to treat trailing [r] character at the end: 
# From raw 1 to raw 162. Then I will union this dataframe to the last section from 163 to 175 

First_section_data_raws_01_162 <- House_price_data_raw %>% 
                                  slice(1:162)

Second_section_data_raws_163_175 <- House_price_data_raw %>% 
                                    slice(163:175)

###   3.First_section_data_raws_01_162

# 3.1 Create new date_fmtd variables in First_section_data_raws_01_165 dataframe
library(stringr)

fixing_time_period_01_FIRST_HALF <- First_section_data_raws_01_162 %>% 
                                    mutate(date_clean =  str_sub(time_period, 1, 9)) %>%  # Subtract from 1 to 9 to get full year month values
                                    select(time_period,date_clean,united_kingdom,great_britain,england,wales,scotland,northern_ireland_note_3,
                                    north_east,north_west,yorkshire_and_the_humber,east_midlands,west_midlands,east,london,south_east,south_west)

check_new_cols_period_01_FIRST_HALF  <- fixing_time_period_01_FIRST_HALF %>%  select(time_period,date_clean)
check_new_cols_period_01_FIRST_HALF

fixing_time_period_02_FIRST_HALF  <- fixing_time_period_01_FIRST_HALF %>% 
  mutate(
    day = '01',
    year = str_sub(date_clean, -4, -1),
    month = str_sub(date_clean, 1,3)) 

fixing_time_period_02_FIRST_HALF

check_new_cols <- fixing_time_period_02_FIRST_HALF %>%  select(date_clean,day,month,year)
check_new_cols 

# 3.2  CREATE NEW DATE FORMAT VARIABLE USING LUBRIDATE
library(lubridate)

# Now I can turn the above three columns "day", "month" and "year" into a Date column using function ymd(date) from  {lubridate} library

fixing_time_period_03_FIRST_HALF <- fixing_time_period_02_FIRST_HALF %>%  mutate(date = paste0(year,"/",month,"/",day))
fixing_time_period_03_FIRST_HALF

names(fixing_time_period_03_FIRST_HALF)

fixing_time_period_04_FIRST_HALF <- fixing_time_period_03_FIRST_HALF %>%  
  mutate(date_fmt = ymd(date)) %>% 
  select(date_fmt,date,day,month,year,
         united_kingdom,great_britain,england,wales,scotland,northern_ireland_note_3,
         north_east,north_west,yorkshire_and_the_humber,east_midlands,west_midlands,east,london,south_east,south_west)
fixing_time_period_04_FIRST_HALF     

# Keep just relevant colums from formatted fixing_time_period_04_FIRST_HALF dataframe: 
names(fixing_time_period_04_FIRST_HALF)

#[1] "date_fmt"                 "date"                     "day"                      "month"                    "year"                    
#[6] "united_kingdom"           "great_britain"            "england"                  "wales"                    "scotland"                
#[11] "northern_ireland_note_3"  "north_east"               "north_west"               "yorkshire_and_the_humber" "east_midlands"           
#[16] "west_midlands"            "east"                     "london"                   "south_east"               "south_west"   

House_prices_FIRST_HALF_DATE_FMTD <- fixing_time_period_04_FIRST_HALF %>% 
                                      select("date_fmt","united_kingdom","great_britain","england","wales","scotland","northern_ireland_note_3","north_east","north_west",
                                             "yorkshire_and_the_humber", "east_midlands","west_midlands","east","london","south_east","south_west")

rm(fixing_time_period_01_FIRST_HALF,
   fixing_time_period_02_FIRST_HALF,
   fixing_time_period_03_FIRST_HALF )


# 4 Second_section_data_raws_163_175
# 4.1 Create new date_fmtd variables in First_section_data_raws_01_165 dataframe
library(stringr)
library(lubridate)

fixing_time_period_01_SECOND_HALF <- Second_section_data_raws_163_175 %>% 
                                      mutate(date_clean =  str_sub(time_period, 1, 9)) %>%  # Subtract from 1 to 9 to get full year month values
                                      select(time_period,date_clean,united_kingdom,great_britain,england,wales,scotland,northern_ireland_note_3,
                                             north_east,north_west,yorkshire_and_the_humber,east_midlands,west_midlands,east,london,south_east,south_west) %>% 
                                      mutate(
                                        day = '01',
                                        year = str_sub(date_clean, -6, -1),
                                        month = str_sub(date_clean, 1,3)) %>% 
                                      mutate(date = paste0(year,"/",month,"/",day))

# Then we can apply ymd(date) function from lubridate 
fixing_time_period_02_SECOND_HALF <- fixing_time_period_01_SECOND_HALF %>%  
                                      mutate(date_fmt = ymd(date)) %>% 
                                      select("date_fmt","united_kingdom","great_britain","england","wales","scotland","northern_ireland_note_3","north_east","north_west",
                                             "yorkshire_and_the_humber", "east_midlands","west_midlands","east","london","south_east","south_west")
House_prices_SECOND_HALF_DATE_FMTD <- fixing_time_period_02_SECOND_HALF

# 5. Then we can union both halves as they have not the correct date format applied to the newly created date_fmt colum, using {stringr} and {lubridate} packages:
# We union two dataframes with same columns in R using {dplyr} bind_rows(df1, df2) function 
House_price_data_FMTD <- bind_rows(House_prices_FIRST_HALF_DATE_FMTD,
                                   House_prices_SECOND_HALF_DATE_FMTD)

House_price_data_FMTD

# 6. Save this date formatted dataframe as .csv file 
# Save time period formatted column dataframe in a new "cleansed_data" sub-folder in my WD
here()
if(!dir.exists("cleansed_data")){dir.create("cleansed_data")}
write.csv(House_price_data_FMTD,here("cleansed_data","UK_House_price_data_FMTD_Jan_2011_July_2025.csv"), row.names = TRUE)

# 7. Split initial House Price index dataset into different geographies
# 7.1 United Kingdom
UK_House_price_fmted <- House_price_data_FMTD %>% select(date_fmt,united_kingdom)
write.csv(UK_House_price_fmted,here("cleansed_data","UK_House_price_fmted.csv"), row.names = TRUE)
# 7.2 Great Britain
GB_House_price_fmted <- House_price_data_FMTD %>% select(date_fmt,great_britain)
write.csv(GB_House_price_fmted,here("cleansed_data","GB_House_price_fmted.csv"), row.names = TRUE)
# 7.3 GB Countries - England, Wales, Scotland
COUNTRIES_House_price_fmted <- House_price_data_FMTD %>% select(date_fmt,england,wales,scotland,northern_ireland_note_3)
write.csv(COUNTRIES_House_price_fmted,here("cleansed_data","COUNTRIES_House_price_fmted.csv"), row.names = TRUE)
# 7.4 Regions
REGIONS_House_price_fmted <- House_price_data_FMTD %>% select(date_fmt,north_east,north_west,yorkshire_and_the_humber,east_midlands,west_midlands,east,london,south_east,south_west)
write.csv(REGIONS_House_price_fmted,here("cleansed_data","REGIONS_House_price_fmted.csv"), row.names = TRUE)
# Remove previous dataframes. Keeping just House_price_data_raw and UK_House_price_fmted,GB_House_price_fmted,COUNTRIES_House_price_fmted,REGIONS_House_price_fmted
rm(list=ls()[! ls() %in% c("House_price_data_raw","UK_House_price_fmted","GB_House_price_fmted","COUNTRIES_House_price_fmted","REGIONS_House_price_fmted")])


# 8. Plot house price data for UK 

# Data set: UK_House_price_fmted
# 5. Plot UK house price time series data
min_date <- min(UK_House_price_fmted$date_fmt)
max_date <- max(UK_House_price_fmted$date_fmt)

#> min_date
#[1] "202-06-01"
#> max_date
#[1] "2025-07-01"

# Setup color palette manually
# scale_color_manual(values = c("#00AFBB", "#E7B800", "#FC4E07"))
# install.packages("viridis",dependencies = TRUE)
library(wesanderson) #  blog Wes Anderson Palettes.  https://github.com/karthik/wesanderson
library(viridis)

# 8.1 Plot UK House Prices using ggplot2
str(UK_House_price_fmted)

# Testing final plot details
plot_checks_2011 <- UK_House_price_fmted %>% filter(date_fmt >= '2011-01-01' & date_fmt <= '2011-12-01')
plot_checks_2023 <- UK_House_price_fmted %>% filter(date_fmt >= '2023-01-01' & date_fmt <= '2023-12-01')
plot_checks_2025 <- UK_House_price_fmted %>% filter(date_fmt >= '2025-01-01' & date_fmt <= '2025-07-01')

test_UK_price_plot_2011 <- ggplot(data = plot_checks_2011, aes( x = date_fmt, y = united_kingdom )) + 
  labs(title ="UK Average house prices into reverse from last year all time high. Jan 2011-Dec 2011",
       subtitle = "Source:ONS.Private rent and house prices, UK: September 2025") +
  geom_line(color = "darkgreen") 

test_UK_price_plot_2023 <- ggplot(data = plot_checks_2023, aes( x = date_fmt, y = united_kingdom )) + 
  labs(title ="UK Average house prices into reverse from last year all time high. Jan 2023-Dec 2023",
       subtitle = "Source:ONS.Private rent and house prices, UK: September 2025") +
  geom_line(color = "darkblue") 

test_UK_price_plot_2025 <- ggplot(data = plot_checks_2025, aes( x = date_fmt, y = united_kingdom )) + 
  labs(title ="UK Average house prices into reverse from last year all time high. Jan 2025-Jul 2025",
       subtitle = "Source:ONS.Private rent and house prices, UK: September 2025") +
  geom_line(color = "orange") 

# UK House price plot 

UK_monthly_house_price_plot <- ggplot(data = UK_House_price_fmted, aes( x = date_fmt, y =united_kingdom )) + 
  geom_line(color = "mediumpurple2") +
   labs(title ="UK Average house prices into reverse from last year all time high. Jan 2011- July 2025",
       subtitle = "Source: ONS-Private rent and house prices- UK:September 2025",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) +
 scale_y_continuous(breaks = seq(0,300000, by = 20000)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  scale_color_viridis(discrete=TRUE) +
  theme_bw() + 
  theme(legend.position = c(.88,.15),
    legend.title=element_blank()) # removed legend title
UK_monthly_house_price_plot

ggsave(paste0("plots/19_Average_UK_House_Price_ONS_private_rent_and_house_prices_Jan2011_July2025.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")

# 9. Compute Month over month percent change and year over year percent change
# For UK House prices

rm(list=ls()[! ls() %in% c("UK_House_price_fmted","GB_House_price_fmted","COUNTRIES_House_price_fmted","REGIONS_House_price_fmted")])

UK_House_price_changes <- UK_House_price_fmted %>% 
                          select(date_fmt, 
                                 UK_house_price = united_kingdom)

names(UK_House_price_changes)

UK_House_price_changes_calc  <- UK_House_price_changes %>%  
  mutate(
    MoM_n = UK_house_price - lag(UK_house_price,1),
    MoM_perc = ((UK_house_price - lag(UK_house_price,1))/lag(UK_house_price,1)*100),
    MoM_percr = round(((UK_house_price - lag(UK_house_price,1))/lag(UK_house_price,1)*100),2), # We will use this calculation  in next section
    YoY_n = UK_house_price - lag(UK_house_price,12),
    YoY_perc = ((UK_house_price - lag(UK_house_price,12))/lag(UK_house_price,12)*100),    # We will use this calculation  in next section
    YoY_percr = round(((UK_house_price - lag(UK_house_price,12))/lag(UK_house_price,12)*100),2),
    Price_change_m = ifelse(MoM_percr < 0,"Drops","Increses"),
    Price_change_y = ifelse(YoY_percr < 0,"Drops","Increses")
    # ifelse(a %% 2 == 0,"even","odd")
  )
UK_House_price_changes_calc 

# 10. Creating chart for MoM and YoY UK House price changes for Jan 2011- July 2025 period.
# Pivot longer  previous dataset
# using pivot_longer() function from {tidyr} package
# https://tidyr.tidyverse.org/reference/pivot_longer.html

# Note: I have created a similar plot to this one below in this script: 
# https://github.com/Pablo-tester/house_market/blob/main/01_House_price_UK_descriptive_analysis_R_scripts/04_House_price_change_plots.R


# 10.1 Select YoY_perc_change and MoM_perc_change from previous data and pivot dataset fropm wide to LONG format:
library(tidyr)

Price_change_data <- UK_House_price_changes_calc %>% 
  select(date_fmt,YoY_perc_change = YoY_percr,MoM_perc_change = MoM_percr)%>% 
  pivot_longer(cols = !date_fmt,
               names_to = "metric",values_to = "percent")

# 10.2 Create new labels required to populate the final chart (these are adhoc labels that will replace existing ggplot2 labels. )
Price_change_labels <- Price_change_data %>% 
  select(date_fmt,metric_reode = metric,percent) %>% 
  mutate(metric = recode(metric_reode,
                               YoY_perc_change = "YoY percent change",
                               MoM_perc_change = "MoM percent change"))

Price_change_labels_plot <- Price_change_labels %>%  select(date_fmt,metric,percent)


# 10.3 Compute reference point (latest value) for each series (MoM and YoY percent change)
endv <- group_by(Price_change_labels, metric) %>% 
        filter(date_fmt == max(date_fmt)) %>% 
        select(date_fmt,metric,percent)
endv


# 11.Final plot displaying MoM and YoY percent change UK House price for July 2011-July 2025 period. 

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
  theme(
    legend.position = c(.90,+.80),
    legend.title=element_blank()) # removed legend title

UK_House_price_yoy_perc_endv


ggsave(paste0("plots/20_Average_UK_House_Price_ONS_private_rent_and_house_prices_Jan2011_July2025_end_value.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")

# 12. Combining YoY and MoM UK Average House price change with UK Average House price

# Created a grid of 2 columns to display both charts on same png file

# 12.1 UK Monthly House price

# 12.1.1 Including end value
UK_House_price_latest_value <- UK_House_price_fmted  %>%  select(date_fmt,united_kingdom)
endv <- UK_House_price_latest_value %>% filter(date_fmt == max(date_fmt))


UK_monthly_house_price_plot <- ggplot(data = UK_House_price_fmted, aes( x = date_fmt, y =united_kingdom )) + 
  geom_line(color = "mediumpurple2") +
  labs(title ="UK Average house prices into reverse from last year all time high. Jan 2011- July 2025",
       subtitle = "Source: ONS-Private rent and house prices- UK:September 2025",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) +
  scale_y_continuous(breaks = seq(0,300000, by = 20000)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  scale_color_viridis(discrete=TRUE) +
  theme_bw() + 
  theme(legend.position = c(.88,.15),
        legend.title=element_blank()) +  # removed legend title
  # Introduce Latest UK House price value label 
  # First I include a dot at the end of the existing geom_line chart
  geom_point(data = endv, col = 'mediumpurple2') +
  # End value label (date and value)
  geom_text(data = endv, aes(label = date_fmt), hjust =1.9, nudge_x = 5,vjust = 1.0) +
  geom_text(data = endv, aes(label = paste0("Most recent value: ",united_kingdom), hjust = 1.5, nudge_x = 5,vjust = -1)) 

UK_monthly_house_price_plot

# 12.2 UK MoM and YoY average House price change
UK_House_price_yoy_perc_endv <-ggplot(data = Price_change_labels_plot, aes( x = date_fmt, y = percent, color = metric )) + 
  
  geom_line() +
  # Adding end value metric dot shape and label
  geom_point(data = endv, col = 'darkgray') +
  geom_text(data = endv, aes(label = percent), hjust = -0.4, nudge_x = 2) +
  labs(title ="UK Average house prices show positive growth from last year small drop. July 2011-July 2025",
       subtitle = "UK YoY percent price change.Source: ONS UK House Price Index. September 2025 data",
       # Change X and Y axis labels
       x = "Year", y = "House price change (%)" ) +
  scale_y_continuous(breaks = seq(-16,16, by = 2)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  theme_bw() + 
  theme(
    legend.position = c(.90,+.80),
    legend.title=element_blank()) # removed legend title

UK_House_price_yoy_perc_endv

GRID_PLOT <-grid.arrange(AVG_HPRICE_grid,CHG_HPRICE_grid,ncol=2)


ggsave(paste0("plots/21_Average_and_MoM_YoY_UK_Grid_House_Price_ONS_private_rent_and_house_prices_Jan2011_July2025.jpeg"),width = 30, height = 20, dpi = 150, units = "cm")

