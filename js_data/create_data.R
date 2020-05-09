library(tidyverse)

alldata <- read_csv("../african_latest_data.csv")

## get all africa data by day (cumulative cases and deaths and new cases and deaths)------

columns <- c("dateRep", "cases", "deaths", "countriesAndTerritories", "cumulative_cases", "cumulative_deaths")

alldata <- alldata[, names(alldata) %in% columns]

alldata <- alldata[alldata$countriesAndTerritories != "France", ]

newdata <- alldata %>%
    group_by(dateRep) %>%
    mutate(total_new_cases = sum(cases)) %>%
    mutate(total_new_deaths = sum(deaths)) %>%
    mutate(total_cumulative_cases = sum(cumulative_cases)) %>%
    mutate(total_cumulative_deaths = sum(cumulative_deaths))

remove <- c("cases", "deaths", "countriesAndTerritories", "cumulative_cases", "cumulative_deaths")

newdata <- newdata[, !(names(newdata) %in% remove)]

newdata <- unique(newdata)

write_csv(newdata, "all_africa_data.csv")


