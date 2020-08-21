install.packages("dplyr")
install.packages("readr")
install.packages("tidyverse")
install.packages("zeallot")
install.packages("vctrs")


library("readr")
library("dplyr")
library(tidyverse)

cotton_prices <- read_csv("/Users/prudhviteja/desktop/Cotton_Price-Forecasting/prices.csv")

# Take a glimpse at the contents
glimpse(cotton_prices)

cotton_prices <- read_csv("/Users/prudhviteja/desktop/Cotton_Price-Forecasting/prices.csv", 
                          col_types = cols_only(
                            state = "c", 
                            market="c", 
                            commodity="c",
                            month="i", 
                            year="i", 
                            modal_price="d"))

cotton_prices_renamed<-rename(cotton_prices, 
       region=state, 
       market=market, 
       commodity_kg=commodity, 
       month=month, 
       year=year, 
       price_rwf=modal_price )


glimpse(cotton_prices_renamed)
cotton_prices_renamed %>% head()

library(lubridate)
library(dplyr)


cotton_prices_cleaned <- cotton_prices_renamed %>% 
  
  mutate(date = ymd(paste(year, month, "01", sep="-"))) %>% 
  select(-c(month, year)) 


glimpse(cotton_prices_cleaned)
cotton_prices_cleaned %>% head()


p

cotton_prices_summarized <- cotton_prices_cleaned %>% 
  group_by(date) %>% 
  summarize(median_price_rwf = median(price_rwf))


glimpse(cotton_prices_summarized)
cotton_prices_summarized %>% head()

library(magrittr)
cotton_time_series <- cotton_prices_summarized %$%
  ts(
    median_price_rwf,
    start = c(year(min(date)), month(min(date))),
    end   = c(year(max(date)), month(max(date))),
    frequency = 12
  )

glimpse(cotton_time_series)
cotton_time_series

install.packages("forecast")
library(forecast)

cotton_price_forecast <- cotton_time_series %>% forecast()


cotton_price_forecast


cotton_price_forecast %>% autoplot(main = "Cotton price forecast")
