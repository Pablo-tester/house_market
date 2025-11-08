# house_market
House prices data analysis and visualisations 

## Latest Official Publication about House Prices in the UK 

New Private rent and house prices, UK. Most up to date House and rent prices.
Latest release 22 October 2025. Next release: 19 November 2025.
Private rent and house prices, UK: October 2025
The Price Index of Private Rents (PIPR) measures private rent inflation for new and existing tenancies. The UK House Price Index measures house price inflation.
House market data source:  ONS. UK House Price Index.
<https://www.ons.gov.uk/economy/inflationandpriceindices/bulletins/privaterentandhousepricesuk/october2025#uk-private-rent-and-house-prices>

- This new Publication replaces previous one UK House Price Index: December 2023
The UK House Price Index was discontinutes on December 2023, as can be read on the official ONS publication websiet:
<img width="974" height="463" alt="image" src="https://github.com/user-attachments/assets/08e90a67-143f-4aef-b977-a0268238f8ed" />

<https://www.ons.gov.uk/economy/inflationandpriceindices/bulletins/housepriceindex/december2023>


## Aim
Using Pablo-tester account build some charts and analysis of the Housing market using R Git and GitHub

## Analysis plan

1. Load in data into R from xls files downloaded from ONS website
2. Conduct some exploratory analysis using line charts and scatter plots with simple models to assess relationships between variables
3. Test several univariate time series model
4. Automate the analysis using Targets to build a pipeline to produce a final report
5. Output a Quarto report highlighting the main findings in the house market data downloaded from ONS website.

All this analysis will be done in a dedicated R project using Git and GitHub for version control, adding new analytical features as new branches to main using my local repo as Pablo-tester. 


### Using trunk development to add new features

In this project I use trunk-based development to add features to the main branch. Pablo-tester GitHub account creates the features and  Pablo-source GitHub accounts reviews and approves the changes applied.
![Git_commit_branch_ahead](https://github.com/Pablo-tester/house_market/assets/140793883/532ed3d0-1bae-435c-b1ac-26dbe3a42303)

Adding chages from Git to GitHub

![Close_issue_from_terminal](https://github.com/Pablo-tester/house_market/assets/140793883/3f86debc-e58e-4ca1-afd2-091cc9149fec)

Closing issues as I push the fix, referencing issue number in commit message

## 1. Exploratory data analysis 

### 1.1 Average house price change (%)

UK House price January 2005 December 2023
![35_ONS_Average_UK_House_prices_Jan2005_December2023_Annotated](https://github.com/user-attachments/assets/3dffa6b4-2ca2-4b43-abf3-4f71db13afdf)

UK Average House price 2005-2013
![01_Average_UK_house_price_2005_2013](https://github.com/Pablo-tester/house_market/assets/76554081/faae6f63-3ed6-4939-b1c8-9395636ac6f3)

UK Average House price Time Series decomposition (seasonality, trend and random):

![05_Average_UK_house_price_TS_decomposition_ADDITIVE](https://github.com/Pablo-tester/house_market/assets/76554081/4a1705af-70cd-47e4-87fa-0c5bda799c39)

Year on year and month on month UK Average house price change show negative rates for first time in September 2023 since 2011.
Included reference point (latest value) for each series (MoM and YoY percent change) by adding these to lines to *04_House_price_change_plots.R* script: 

'endv <- group_by(Price_change_labels, metric) %>% filter(datef == max(datef))
 geom_point(data = endv, col = 'darkgray') +
 geom_text(data = endv, aes(label = percent), hjust = -0.4, nudge_x = 2)'

![03_UK_MoM_and_YoY_price_change_DEC2023_env_MARK](https://github.com/Pablo-tester/house_market/assets/140793883/b2a5009c-0edc-48f5-8582-86a3bca68ca1)

Updated previous chart with ONS UK House Price Index. Latest available data from September 2025.

![23_Average_and_MoM_YoY_UK_Grid_House_Price_ONS_private_rent_and_house_prices_Jan2011_July2025](https://github.com/user-attachments/assets/c798c4ce-0647-4b07-a75f-e4d6ce210969)

Updated charts for UK Average house prices and MoM and YoY percent change. Source: ONS UK House Price Index. Jan 2011- July 2025 period. September 2025 data. 

<img width="1774" height="846" alt="image" src="https://github.com/user-attachments/assets/92c0adce-4a22-4143-b75d-2e102b5bb987" />


## 2. Univariate TS modelling using TSstudio

We will explore how to create, train and compare several TS univariate models using TSstudio, using UK Average House price data.

The TSstudio package provides a set of tools descriptive and predictive analysis of time series data. That includes utility functions for preprocessing time series data, interactive visualization functions based on the plotly package engine, and set of tools for training and evaluating time series forecasting models from the forecast, forecastHybrid, and bsts packages.

### 2.1 ARIMA model 12 months forecast

![14_ARIMA_model_forecast_CI_Objerved_forecasted](https://github.com/Pablo-tester/house_market/assets/76554081/257ad423-8e46-4578-9076-2a98217f3e61)


### 2.2 Trained model comparison using partitions

![15_Train_model_using_partitions](https://github.com/Pablo-tester/house_market/assets/76554081/d76ca441-da0c-47d9-85c0-069abc9c7121)

TSstudio: <https://ramikrispin.github.io/TSstudio/>
