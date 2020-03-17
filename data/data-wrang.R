library(magrittr)
library(lubridate)
library(tidyr)
library(dplyr)
#setwd("~/covid-dash/data")
system("wget https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")

covid_df <- read.csv("time_series_19-covid-Confirmed.csv")
covid_long <- covid_df %>% gather(var,val,-c(1:4))
covid_long$date <- substring(covid_long$var, 2) %>%
  as.Date(.,"%m.%d.%y") 

covid_long <- covid_long %>% select(Country.Region,Lat,Long,date,val)
names(covid_long)[1]<- "Country"

covid_long$date <- as.Date(covid_long$date)
covid_long_d <- covid_long %>%
  filter(val != 0) %>%
  group_by(Country) %>%
  mutate(diff = date - min(date)) %>%
  ungroup()

covid_long_d$Countr_id <- dplyr::id(covid_long_d[,"Country"])

write.csv(covid_long_d,"../data/covid-long17Mar.csv")
