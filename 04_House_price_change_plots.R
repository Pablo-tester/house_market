# 04_House_price_change_plots

library(tidyverse)

House_price <-Average_priced %>% 
              mutate(
                MoM_n = Avg_price - lag (Avg_pricem1)
              )

House_price