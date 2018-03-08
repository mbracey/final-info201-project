library("dplyr")
library("reshape2")
library("ggthemes")
library(ggplot2)
library("maps")
library("tidyr")
library("ggplot2")

# FIRST TAB DATA
map <- map_data(map = "world")

gdp <- read.csv("data/gdp.csv", stringsAsFactors = FALSE, skip = 4)
gdp <- gdp[ , -3]
gdp <- gdp[ , -3]
gdp2 <- melt(gdp, id.vars = c("Country.Name", "Country.Code"))
colnames(gdp2) <- c("Name", "Code", "Year", "GDP")



### SECOND TAB DATA ###
one.dday <- read.csv("data/pov.dday.1.09.csv", stringsAsFactors = FALSE)
colnames(one.dday)[1] <- "Country_Name"

## Combines Latitude/Long Data with $1.09/day data
one.dday <- one.dday[ , -3]
one.dday <- one.dday[ , -3]
one.dday.long <- melt(one.dday, id.vars = c("Country_Name", "Country_Code"))
colnames(one.dday.long) <- c("Name", "Code", "Year", "dollars.day")

# Translates iso3 into country codes
country.code <- iso.alpha(map$region, n = 3)

# Merges the map and data for access
one.world.merge <- map %>%
  mutate("Code" = country.code) %>%
  left_join(one.dday.long)



## Combines Latitude/Long Data with $3.20/day data
three.dday <- read.csv("data/pov.dday.3.20.csv", stringsAsFactors = FALSE)
colnames(three.dday)[1] <- "Country_Name"

three.dday <- three.dday[ , -3]
three.dday <- three.dday[ , -3]
three.dday.long <- melt(three.dday, id.vars = c("Country_Name", "Country_Code"))
colnames(three.dday.long) <- c("Name", "Code", "Year", "dollars.day")

# Merges the map and data for access
three.world.merge <- map %>%
  mutate("Code" = country.code) %>%
  left_join(three.dday.long)



## Combines Latitude/Long Data with $5.50/day data
five.dday <- read.csv("data/pov.dday.5.50.csv", stringsAsFactors = FALSE)
colnames(five.dday)[1] <- "Country_Name"

five.dday <- five.dday[ , -3]
five.dday <- five.dday[ , -3]
five.dday.long <- melt(five.dday, id.vars = c("Country_Name", "Country_Code"))
colnames(five.dday.long) <- c("Name", "Code", "Year", "dollars.day")

# Merges the map and data for access
five.world.merge <- map %>%
  mutate("Code" = country.code) %>%
  left_join(five.dday.long)
