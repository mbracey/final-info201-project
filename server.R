library(shiny)
library(ggplot2)
library(ggthemes)
library(tidyr)

library(maps)
library(dplyr)
library(rsconnect)
library(RColorBrewer)


source("spatial_utils.R")
source("FinalProjectData.R")

# Define a server function
server <- function(input, output) {

  # Code for making the first tab
  output$Map <- renderPlot(
    ggplot(data = map) +
      geom_map(map=map, aes(map_id=region, x = long, y = lat), fill = "white", color = "black") +
      theme_stata()
  )

  # Observes clicks and displays the country name longitude and latitude
  observeEvent(input$map_click, {
    name <- GetCountryAtPoint(input$map_click$x, input$map_click$y)
    if(is.na(name)) {
      name <- "not found"
    }
      name <<- name
      text <- reactive({
        if(input$World) {
          name <- ("World GDP")
        } else {
          name <- paste(name, "GDP")
        }
        if(input$Scale) {
          name <- paste(name, "(y scale set to World GDP)")
        }
        return(name)
    })
  
  

    output$Country <- renderText(text())

    plot.data <- reactive({
      data <- gdp2
      if(name == "Russia") {
        name = "Russian Federation"
      }
      if(name == "Egypt") {
        name = "Egypt, Arab Rep."
      }
      if(name == "Venezuela") {
        name = "Venezuela, RB"
      }
      if(name == "Republic of Congo") {
        name = "Congo, Rep."
      }
      if(name == "Democratic Republic of the Congo") {
        name = "Congo, Dem. Rep."
      }
      if(name == "Iran") {
        name = "Iran, Islamic Rep."
      }
      if(!input$World) {
        data <- filter(data, Name == name | Code == name)
      } else {
        data <- filter(data, Name == "World")
      }
      data$Year <- c(1961 : 2019)
      data$GDP <- as.numeric(data$GDP)
      return(data)
    })

    ind_data <- reactive({
      word <- input$Indicator
      data <- read.csv(paste0("data/indicators/", word, ".csv"), stringsAsFactors = FALSE, skip = 4)
      data <- data[ , -3]
      data <- data[ , -3]
      data2 <- melt(data, id.vars = c("Country.Name", "Country.Code"))
      colnames(data2) <- c("Name", "Code", "Year", word)
      if(name == "Russia") {
        name = "Russian Federation"
      }
      if(name == "Egypt") {
        name = "Egypt, Arab Rep."
      }
      if(name == "Venezuela") {
        name = "Venezuela, RB"
      }
      if(name == "Republic of Congo") {
        name = "Congo, Rep."
      }
      if(name == "Democratic Republic of the Congo") {
        name = "Congo, Dem. Rep."
      }
      if(name == "Iran") {
        name = "Iran, Islamic Rep."
      }
      if(!input$World) {
        data2 <- filter(data2, Name == name | Code == name)
      } else {
        data2 <- filter(data2, Name == "World")
      }
      data2$Year <- c(1961 : 2019)
      data2[, 4] <- as.numeric(data2[, 4])
      return(data2)
    })

    g <- reactive({
      g <- ggplot(data = plot.data()) +
        geom_line(mapping = aes(x = Year, y = GDP, group = 1), size = 1.5) +
        theme_stata()
      if(input$Scale) {
        g <- g + scale_y_continuous(limits = c(0, 7.904521e+13))
      }
      return(g+ geom_smooth(aes(x = Year, y = GDP), method= "lm", formula = y ~ x))
    })

    output$ind <- renderText(input$Indicator)

    output$Lines <- renderPlot({
      g()

    })

    output$Ind_Line <- renderPlot({
      ggplot(data = ind_data()) +
        geom_line(mapping = aes(x = Year, y = ind_data()[, 4], group = 1), size = 1.5) +
        theme_stata() + geom_smooth(aes(x = Year, y = ind_data()[, 4]), method= "lm", 
                                    formula = y ~ x, color = "red") +
        ylab(colnames(ind_data()[4]))
    })
})
  
    # Code for making the second tab

    get.groups <- reactive({
      amount <- input$dday
      year <- paste0("X", input$year)
      # Determines which data set to use
      if (amount == "1.09") {
        dday.data.file <- one.world.merge
      } else if (amount == "3.20") {
        dday.data.file <- three.world.merge
      } else {
        dday.data.file <- five.world.merge
      }
      # Filters by year and Country name selected by the user
      dday.data.file <- dday.data.file %>%
        select(c("lat", "long", "group", "region","Name", "Code", "Year",
                 "dollars.day")) %>%
        filter(Year == year) 
      return(dday.data.file)
    })


    output$PovMap <- renderPlot({
      ggplot() +
        geom_map(data = map, map=map, aes(map_id=region, x = long, y = lat),
                 color = "black")  +
        geom_map(data = get.groups(), map = map, aes(map_id = region,
          x = long, y = lat, group = group, fill = dollars.day),
          color = "black")
    })

     observeEvent(input$map_click2, {
       
       name2 <- GetCountryAtPoint(input$map_click2$x, input$map_click2$y)
       amount <- input$dday
       year <- paste0("X", input$year)
       # Accounts for name discrepancies
       if(!is.na(name2)) {
         if(name2 == "Russia") {
           name2 = "Russian Federation"
         }
         if(name2 == "Egypt") {
           name2 = "Egypt, Arab Rep."
         }
         if(name2 == "Venezuela") {
           name2 = "Venezuela, RB"
         }
         if(name2 == "Republic of Congo") {
           name2 = "Congo, Rep."
         }
         if(name2 == "Democratic Republic of the Congo") {
           name2 = "Congo, Dem. Rep."
         }
         if(name2 == "Iran") {
           name2 = "Iran, Islamic Rep."
         }
         # Determines which data set to use
         if (amount == "1.09") {
           dday.data.file <- one.world.merge
         } else if (amount == "3.20") {
           dday.data.file <- three.world.merge
         } else {
           dday.data.file <- five.world.merge
         }
         # Filters by year and Country Name selected by the user
         dday.data <- dday.data.file %>%
           filter(Year == year) %>%
           filter(Name == name2) %>%
           summarize(dollars.day = median(dollars.day))
         # Accommodates for lack of data
         if (is.na(dday.data)) {
           sentence <- paste("Unfortunately, no data has been collected for the
                              percentage of the population that lives on $", amount,
                             "per day in", name2, ".")
         } else {
            sentence <- paste("In", name2, dday.data$dollars.day, "% of the population
                               live on $", amount, "per day")
         }
         output$CountryName <- renderText(sentence)
       }
     })
}

shinyServer(server)  # create the server
