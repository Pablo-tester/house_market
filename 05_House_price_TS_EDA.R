# 21/11/2023
# R Script: 05_House_price_univatiate_TS_models.R

# Open R project folder and create new script called “05_House_price_ARIMA_model.R”
# I will use TStudio to compare several TS models side by side
# https://github.com/RamiKrispin/TSstudio

source('01_Load_house_prices_data.R')
source('02_House_data_EDA.R')
source('03_House_prices_calculations.R')
source('04_House_price_change_plots.R')

# 1. Subset data for ARIMA model using TSstudio package
House_price_ts_prep <- House_price %>% select(datef, Avg_price)
House_price_ts_prep

# 2. Get min and max dates to transform intial data into a TS object (required to be used with TSStudio)
Min_date <- min(House_price$datef)
Min_date                                           
# [1] "2005-01-01"
Max_date <- max(House_price$datef)
Max_date  
# [1] "2023-09-01"

# 3. Subset Avg_price and turn it into a TS object

# 01 TS plot 

# ts function Parameters
# frequency = The number of observations per unit of time
# The “frequency” is the number of observations before the seasonal pattern repeats.1 When using the ts() function in R, the following choices should be used.
# Data	frequency
# Annual	1
# Quarterly	4
# Monthly	12
# Weekly	52

# In our example or data is monthly so we will adjust frequency to 12
# Start will be "2005-01-01" Jan 2005 (2005,1)
# End will be "2023-09-01" Sep 2023 (2023,9)
library(tidyverse)
library(TSstudio)

# House_price_ts_prep data set
# First column:
House_price_date_v <- House_price_ts_prep[,1]
# Second column: 
House_price_avg_price_v <- House_price_ts_prep[,2]

# 01 TS object
# We select just the numeric variable (Avg_price)
# And we use the Min and Max dates to define the TS object:
# Frequency set up to 12 as we are working with Monthly data
# Min_date  # [1] "2005-01-01"
# Max_date  # [1] "2023-09-01"

House_price_ts <- ts(House_price_ts_prep[,2], start = c(2005, 1), end = c(2023, 9), frequency = 12)
House_price_ts

# 4. Exploratory data analysis 

# 4.1 Plot TS object
House_price_plot <- ts_plot(House_price_ts,
                            title = "Average UK House price. 2005-2013",
                            Xtitle = "Date",
                            Ytitle = "Avg UK house price")
                            # slider = TRUE)
House_price_plot

# ggsave function not applicable with a plotly object
# ggsave (plot = House_price_plot,
#        path = "~/Documents/Pablo_zorin/Pablo_tester/house_market/plots",
#        filename = "04_Average_UK_House_price_2005_2013.png", 
#        width = 10, height = 8, bg = "white")

#In addition: Warning message:
#  'plotly::export' is deprecated.
#Use 'orca' instead.
# library(plotly)
# plotly::export(p = House_price_plot, #the graph to export
#                file = "graph 1.png") #the name and type of file (can be .png, .jpeg, etc.)

# Export charts using standard Export menu from Viwer pane by now. 

# Error: Package `webshot` required for `export`.
# Please install and try again.
# In addition: Warning message:
#   'plotly::export' is deprecated.
# Use 'orca' instead.

# 4.2 TS decomposition
# The TS decomposition must be "additive", "multiplicative", or "both"
Decompose_Additive <- ts_decompose(House_price_ts, type = "additive", showline = TRUE)
Decompose_Additive

Decompose_Multip <- ts_decompose(House_price_ts, type = "multiplicative", showline = TRUE)
Decompose_Multip

Decompose_Both <- ts_decompose(House_price_ts, type = "both", showline = TRUE)
Decompose_Both

# Export charts using standard Export menu from Viwer pane by now. 

# 4.3 Seasonal plot
# Seasonal plot
ts_seasonal(House_price_ts, type = "all")

# 4.4 Heatmap plot
ts_heatmap(House_price_ts)

# end of EDA
