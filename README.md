# house_market
House prices data analysis and visualisations 

House market data source:  ONS. UK House Price Index.

Latest data release: UK House Price Index: August 2023
Monthly house price inflation in the UK, calculated using data from HM Land Registry, Registers of Scotland, and Land and Property Services Northern Ireland.
<https://www.ons.gov.uk/economy/inflationandpriceindices/bulletins/housepriceindex/august2023>

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

Year on year and month on month UK Average house price change are approaching negative rates in August 2023.

![03_UK_MoM_and_YoY_percent_price_change_AUG2023](https://github.com/Pablo-tester/house_market/assets/140793883/d72e2be5-fbd6-416c-918e-82199b599223)
