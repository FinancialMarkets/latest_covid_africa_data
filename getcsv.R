library(dplyr)
library(readr)

data <- read_csv("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv")

data$geoId <- tolower(data$geoId)

data[data$countriesAndTerritories == "Eritrea", ]$popData2018 <- 3546000 

write_csv(data, "./latest_data.csv")

ck <- read_csv("./country_key.csv")

african_data <- subset(data, (geoId %in% ck$geoId) | countriesAndTerritories == "Namibia")

african_data$dateRep <- as.Date(african_data$dateRep, format="%d/%m/%Y")

## get cumulative cases and deaths
african_data <- african_data %>% 
    group_by(countryterritoryCode) %>%
    arrange(dateRep) %>%
    mutate(cumulative_cases = cumsum(cases)) %>%
    mutate(cumulative_deaths = cumsum(deaths)) 

write_csv(african_data, "./african_latest_data.csv")
