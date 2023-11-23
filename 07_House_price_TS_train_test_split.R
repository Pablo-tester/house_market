# 07_House_price_TS_train_test_split.R

# In this section we are going to split the initial TS series by Train and Test to fit some model later on

library(TSstudio)
library(tidyverse)

# Just to double check, display correlation analysis in a new plot
ts_cor(House_price_ts)

# 7.1 Split initial House_price_ts data set into train and test sets

# TRAIN TEST SPLIT
# Function: ts_split(ts.obj, sample.out = NULL)
# Arguments

House_price_ts_split <- ts_split(ts.obj = House_price_ts,sample.out = 12)


ffffff
fff
fff
ddddddsdsssssdds