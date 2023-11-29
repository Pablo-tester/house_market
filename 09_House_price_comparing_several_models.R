# 08_Compare_several_models_side_by_side

source('01_Load_house_prices_data.R')
source('02_House_data_EDA.R')
source('03_House_prices_calculations.R')
source('04_House_price_change_plots.R')
source('05_House_price_TS_EDA.R')
source('06_House_price_correlation_analysis.R')
source('08_House_price_TS_train_test_split_ARIMA_model.R')

# Usint TStudio package
https://ramikrispin.github.io/TSstudio/
  
# 9.1 Let's build a set of models to compare their performance
  
methods <- list (ets1 = list (method = "ets",
                                method_arg = list(opt.crit = "lik"),
                                notes = "ETS model with opt.crit = lik"),
                   ets2 = list(method = "ets",
                                method_arg = list(opt.crit = "amse"),
                                notes = "ETS model with opt.crit = amse"),
                   hv = list(method = "HoltWinters",
                             method_arg = NULL,
                             notes = "HoltWinters Model"),
                   tslm = list(method = "tslm",
                               method_arg = list(formula = input ~ trend + season),
                               notes = "tslm model with trend and season components")
                    )

# Training the models with backtesting
# Testing the model with backtesting: 

md <- train_model(input = House_price_ts,
                  method = methods, 
                  train_method = list(partitions = 6, sample.out = 12, space = 3),
                  horizon = 12, 
                  error = "MAPE")

# Plot the performance of the different models on the testing partitions
plot_model(md)


# View the model performance on the backtesting partitions
md$leaderboard
