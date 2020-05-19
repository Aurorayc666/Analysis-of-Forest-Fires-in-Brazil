# Yucong Hu Forest fires in Brazil

library(shiny)
library(readxl)
library(ggplot2)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(DT)

ForestFire <- read.csv("ForestFire.csv")


shinyServer(function(input, output) {
    # Create text output for Description tab
    output$text <- renderText({
        "Forest fires are a serious problem for the preservation of the Tropical Forests. Understanding the frequency of forest fires in a time series can help to take action to prevent them. Brazil has the largest rainforest on the planet that is the Amazon rainforest. This application analyses report of the number of forest fires in Brazil divided by states. (http://dados.gov.br/dataset/sistema-nacional-de-informacoes-florestais-snif). The database includes terror attacks since 1975 from around the world. This application focuses on the years 1998 to 2017 for Brazil only. This application allows the user to perform geo-spatial analysis on forest fires in Brazil."
    })
   # Create plot 1 - not interactive
    output$plot1 <- renderPlot({
        # Create plot for type of attack
        g <- ggplot(ForestFire, aes(x = ForestFire$year, fill = state)) + geom_bar() +
            xlab('Year') +
            ylab('Number of forest fires')
            guides(fill=guide_legend(title="year"))
        # Return plot 1
        g
    })
    # Create plot 2 - interactive
    output$plot2 <- renderPlot({
        # Read input file
        ForestFire <- read.csv("ForestFire.csv")
        dataP2 <- data.frame(ForestFire$year,
                             ForestFire$state,
                             ForestFire$month,
                             ForestFire$number)
        # Manipulate input file
        colnames(dataP2) <- c('year', 'state', 'month', 'number')
        dataP2 <- dataP2[complete.cases(dataP2),]
        
        # Filter the data for different years and states selected by user in plot 2 tab
        target1 <- c(input$YearPlot2)
        target2 <- c(input$StatesPlot2)
        df_plot2 <- dataP2[dataP2$year %in% target1 & dataP2$state %in% target2,]
        df_plot2 <- dataP2 %>% filter(year == input$YearPlot2) %>% filter(state == input$StatesPlot2)
        # Create plot for forest fire by month
        df_plot2 <- within(df_plot2, month <- factor(month,levels=names(sort(table(month),decreasing=F))))
        p <- ggplot(df_plot2, aes(x = month)) + geom_bar() +
            coord_flip() +
            ylab('Number of Forest Fires') +
            xlab('')
        # Return plot 2
        p
    })
    # Create data table output
    output$table <- renderTable({
        ForestFire <- read.csv("ForestFire.csv")
        # Manipulate input file
        colnames(ForestFire) <- c('nrow','year', 'state', 'month', 'number', 'date')
        ForestFire <- ForestFire[complete.cases(ForestFire),]
        # Show entire table when no state is selected by user 
        if(is.null(input$states)){return(ForestFire)}
        # Filter the data for different states selected by user input
        ForestFire <- ForestFire[ForestFire$state %in% input$states,][,-1]
        # Return table
        return(ForestFire)
    })
})
    