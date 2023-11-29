# 07_House_price_TS_train_test_split.R
source('01_Load_house_prices_data.R')
source('02_House_data_EDA.R')
source('03_House_prices_calculations.R')
source('04_House_price_change_plots.R')
source('05_House_price_TS_EDA.R')
source('06_House_price_correlation_analysis.R')

# In this section we are going to split the initial TS series by Train and Test to fit some model later on

library(TSstudio)
library(tidyverse)

# Just to double check, display correlation analysis in a new plot
ts_cor(House_price_ts)

# 7.1 Split initial House_price_ts data set into train and test sets

# TRAIN TEST SPLIT
# Function: ts_split(ts.obj, sample.out = NULL)
# Arguments

# ts.obj > A univariate time series object of a class "ts" or "tsibble"
# sample.out >  An integer, set the number of periods of the testing or sample out partition, defualt set for 30 percent of the lenght of the series

House_price_ts_split <- ts_split(ts.obj = House_price_ts,sample.out = 12)

# Object: House_price_ts_split  is list object made of two components:
# $train
# $test 

# Object House_price_ts_split contains both the Train and Test sets

# Split initial set into training and testing sets:
# This will create two TS objects (one for train and another for test)

train <-House_price_ts_split$train
test <-House_price_ts_split$test

# We can save these two train and test splits into a .csv file
if(!dir.exists("Train_test_split")){dir.create("Train_test_split")}

library(here)
library(utils)

write.csv(train,here("Train_test_split","House_price_train.csv"), row.names = TRUE)
write.csv(test,here("Train_test_split","House_price_test.csv"), row.names = TRUE)


# ARIMA model

# Trying out an ARIMA model

# Just to recap from previous steps
# 1. Split data into train and test sets
House_price_ts_split <- ts_split(ts.obj = House_price_ts,sample.out = 12)
train <-House_price_ts_split$train
test <-House_price_ts_split$test

# 2. Apply auto.arima() function from {forecast} package
# library(forecast)

# 2.1 Apply ARIMA model
library(forecast)
arima_model <- auto.arima(train)
# 2.2 Forecast next 12 periods
arima_forecast <- forecast(arima_model, h=12)

# 2.3 Plot actual vs forecasted values
# Using test_forecast() function TSstudio package

# House_price_ts
# actual:  the full TS object, before we split it into train and test sets, that is House_price_ts
# forecast.obj:  The forecast outupt of the TRAINING set with horizon align aligned to the length of 
#                 the TESTING (support forecasted objects from "forecast" package) 
# test: the testing (hold-out) partition
  test_forecast(actual = House_price_ts,
                forecast.obj = arima_forecast,
                test = test)
  
# Plotting the forecast 
  plot_forecast(arima_forecast)

