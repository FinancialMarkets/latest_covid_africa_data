library(tidyverse)
library(reshape2)

alldata <- read_csv("../../../1_EU_Data/latest_data.csv")

alldata[alldata$countriesAndTerritories == "Eritrea", ]$popData2018 <- 3546000

alldata$dateRep <- as.Date(alldata$dateRep, format="%d/%m/%Y")

## get cumulative cases and deaths
alldata <- alldata %>% 
  group_by(countryterritoryCode) %>%
  arrange(dateRep) %>%
  mutate(cumulative_cases = cumsum(cases)) %>%
  mutate(cumulative_deaths = cumsum(deaths))

## cumulative cases and deaths per million---------

alldata$cum_cases_per_million <- alldata$cumulative_cases / alldata$popData2018
alldata$cum_deaths_per_million <- alldata$cumulative_deaths / alldata$popData2018

## for line chart, convert into days on file and cumulative cases/deaths by country in columns-----------

alldata$const <- 1

linedata <- alldata %>%
  group_by(countryterritoryCode) %>%
  arrange(dateRep) %>%
  mutate(days_data = cumsum(const)) 

linedata_cases <- linedata[, c("days_data", "countriesAndTerritories", "cum_cases_per_million")]
linedata_deaths <- linedata[, c("days_data", "countriesAndTerritories", "cum_deaths_per_million")]

## reshape so country names are columns----------------------
cases_data_to_gchart <- dcast(linedata_cases, days_data ~ countriesAndTerritories)
deaths_data_to_gchart <- dcast(linedata_deaths, days_data ~ countriesAndTerritories)

write_csv(cases_data_to_gchart, "line_chart_cases.csv")
write_csv(deaths_data_to_gchart, "line_chart_deaths.csv")


##to subset, maybe use later----------
ck <- read_csv("./country_key.csv")

alldata <- subset(data, (geoId %in% ck$geoId) | countriesAndTerritories == "Namibia")




write_csv(alldata, "./alldata.csv")
