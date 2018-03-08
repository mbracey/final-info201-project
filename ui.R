# Sets up neccesary libraries
library(shiny)
library(shinythemes)
#Sets up the UI
ui <- fluidPage(

  theme = shinytheme("superhero"),

  titlePanel("Understanding the World's Economy"),
  
    br(),

    tabsetPanel(type = "tabs",
      tabPanel("Information",
        h2("Introduction"),
        p("Our application aims to help curious college students who aren’t aware 
          of what various countries economic situations are learn more about the 
          global economy.
          Using World Bank data our analysis shows the economic state of each country
          and how this can effect different aspects of life.
          Using the data, we can show how GDP of a country can effect indicators 
          such as: female employment, life expectancy,
          military expenditure, refugee population, and gender equality in schools."),
        br(),
        h2("Question 1: ", em("Viewing the World's GDP")),
        p("Our first question was How does GDP relates to other important World Bank 
          indicators of a country such like Schooling, Military, and Social Development. 
          To answer this question we used indicators from the World Bank that we 
          believe are a good indicator of how well developed a country is.
          By using side-by-side trend graphs we can show whether or not an increase or
          decrease in GDP overtime has any effect on these indicators. While the 
          relative wealth and success of a country goes beyond GDP, we aimed to show 
          that countries with high GDP typically have better scores in these certain 
          indicators.  For example, a country with a higher GDP such as the U.S.A has 
          little to no refugees, about equal gender parity in schooling, and a high 
          level of female unemployment. Conversely a country with a lower GDP such as 
          Chad has higher level of refugees fleeing to other countries, very 
          disadvantaged schooling, and low levels of female employment.
          While this depends on the country, there is generally a correlation between 
          high GDP and better performance in the indicators we used."),
        br(),
        h2("Question 2: ", em("Viewing the World's Poverty")),
        p("Our second question was How impoverished is the world really? In order 
          to answer this question we looked at several Poverty indicator data sets 
          given by the World Bank.
          In order to analyze this question we provide a chloropleth map that shows 
          what percent of a country lives on either $1.09, $3.20, or $5.50 a day. 
          The global poverty threshold is $1.90 a day,
          so based on our map we can see how many people in every country are close 
          to or below the poverty threshold."),
        br(),
        h2("Conclusion"),
        p("Being able to visualize each countries economic standing is a very easy 
          way to get an idea of differences in development globally. Through our map
          and graph analysis of the World Bank data we can identify which countries 
          are experiencing economic and developmental growth and which continue to 
          struggle."),
        br(),
        p("Source: https://data.worldbank.org/indicator")

      ),
      tabPanel("Viewing the World's GDP",
        sidebarLayout(
          sidebarPanel(
             # Creates controls allowing user to choose types of info displayed
             checkboxInput('World',label = "World Stats",  value = FALSE),
             checkboxInput('Scale', label = "Scale to World", value = FALSE),
             selectInput('Indicator', label = "Choose an Indicator to Compare",
               choices = list("Female Employment (percent)" = "female_employment",
                "Male Life Expentency (years)" = "life_exp_male",
                 "Miltary Expenditure (% gov expenditure)" = "miltary_expend",
                 "Refugee Population (# of refugees in Other Countries)" =
                 "refugee_pop", "Gender Equality in School (Gender Parity Index)" =
                 "school_enroll")),
             textOutput('ind'),
             plotOutput('Ind_Line')
          ),
          mainPanel(
            plotOutput('Map', click = 'map_click'),
            textOutput('Country'),
            plotOutput('Lines')
          )
        )
      ),
      tabPanel("Viewing the World's Poverty",
        sidebarLayout(
          sidebarPanel(
            radioButtons("dday", label = "Living on _______ per day",
                         c("$1.09" = "1.09",
                           "$3.20" = "3.20",
                           "$5.50" = "5.50")),

            br(),

            selectInput('year', label = 'Year of data collection:', c('2015', '2014',
                        '2013', '2012', '2011', '2010', '2009', '2008', '2007',
                        '2006', '2005', '2004','2003', '2002', '2001', '2000',
                        '1999', '1998', '1997', '1996', '1995', '1994', '1993',
                        '1992', '1991', '1990', '1989', '1988', '1987', '1986',
                        '1985', '1984', '1983', '1982', '1981', '1980')),
            
            br()

          ),
          mainPanel(br(), p("This map shows the percentage of people in that country
                     who live on the selected amount per day in the selected
                     year."), br(), plotOutput('PovMap', click = 'map_click2'),
                   #p("Highlighting:",  strong(textOutput('selected', inline=TRUE)) )
                   #verbatimTextOutput("selected")
                   br(),
                   textOutput('CountryName'),
                   br(),
                   br(),
                   br()
                   
          )
        )
      )
    )
)
shinyUI(ui)
