# 06_House_price_correlation_analysis.R

source('01_Load_house_prices_data.R')
source('02_House_data_EDA.R')
source('03_House_prices_calculations.R')
source('04_House_price_change_plots.R')

# Then we run a correlation analysis.
# On TS object: House_price_ts


# 6.1 Load first required libraries
library(tidyverse)
library(TSstudio)


# 6.2 Display correlation analysis
# Using ACF and PACF plots we assess with lags display seasonality 
# In this house price data set There is a strong seasonality in LAG 1
# Function ts_cor()
ts_cor(House_price_ts)

# 6.3 Lag plots
# Again we can plot the lags again to affirm previous observed seasonality
# We explore the first 12 lags for a start
# Lag 1 shows a strong seasonality. meaning what happens the previous month explains to 
# a certain degree what house price shows in current month
ts_lags(House_price_ts, lags = 1:12)

# We can also specify how many lags we want to analyse in our script
# In this particular example I want to focus on last (12,24,36,48)
# Going 1 year, 2, 3 and 4 years back in time in our analysis.
ts_lags(House_price_ts, lags = c(12,24,36,48))

# These specific set of lags do not show strong correlation