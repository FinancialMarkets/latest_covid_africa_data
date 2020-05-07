library(tidyverse)
library(reshape2)

alldata <- read_csv("../../african_latest_data.csv")

## cumulative cases and deaths per million---------

alldata$cum_cases_per_million <- round(alldata$cumulative_cases / alldata$popData2018, 3)
alldata$cum_deaths_per_million <- round(alldata$cumulative_deaths / alldata$popData2018, 3)

## for line chart, convert into days on file and cumulative cases/deaths by country in columns-----------

alldata$const <- 1

linedata <- alldata %>%
  group_by(countryterritoryCode) %>%
    arrange(dateRep) %>%
    filter(cumulative_cases > 2) %>%
  mutate(days_data = cumsum(const)) 

linedata_total_cases <- linedata[, c("days_data", "countriesAndTerritories", "cumulative_cases")]
linedata_total_deaths <- linedata[, c("days_data", "countriesAndTerritories", "cumulative_deaths")]

linedata_cases_per_million <- linedata[, c("days_data", "countriesAndTerritories", "cum_cases_per_million")]
linedata_deaths_per_million <- linedata[, c("days_data", "countriesAndTerritories", "cum_deaths_per_million")]

## reshape so country names are columns----------------------
cases_data_to_gchart <- dcast(linedata_total_cases, days_data ~ countriesAndTerritories)
deaths_data_to_gchart <- dcast(linedata_total_deaths, days_data ~ countriesAndTerritories)

##change NA to null
cases_data_to_gchart[is.na(cases_data_to_gchart)] <- ""
deaths_data_to_gchart[is.na(deaths_data_to_gchart)] <- ""

## remove France
cases_data_to_gchart <- cases_data_to_gchart[, !(names(cases_data_to_gchart) %in% c("France"))]
deaths_data_to_gchart <- deaths_data_to_gchart[, !(names(deaths_data_to_gchart) %in% c("France"))]


write_csv(cases_data_to_gchart, "line_chart_cases.csv")
write_csv(deaths_data_to_gchart, "line_chart_deaths.csv")


