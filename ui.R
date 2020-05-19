# changmengzhi teaching
# Yucong Hu forest fires in brazil
library(shiny)
ForestFire <- read.csv("ForestFire.csv")
# Define style of application and title
ui <- navbarPage("Forest Fires in Brazil",
                 # Create description panel, incl. text output and file input functionality
                 tabPanel("INTRODUCTION", h4('Analysing forest fires in brazil'), textOutput("text"), hr()),
                 # Create dropdown menu with two tabs
                 navbarMenu("PLOTS",
                            # create tab for plot 1 - forest fire by number
                            tabPanel("Forest Fire by Number", plotOutput("plot1")),
                            # create tab for plot 2 - forest fire by state
                            tabPanel("Forest Fire by State",plotOutput("plot2"), hr(),fluidRow( 
                              column(3, offset = 1,
                                     checkboxGroupInput("YearPlot2",
                                                        "Year of Forest Fire:",
                                                        choices = unique(ForestFire[,2]),
                                                        selected = unique(ForestFire[,2])
                             ),
                                column(3,
                                       checkboxGroupInput("StatesPlot2",
                                                          "States:",
                                                          choices = unique(ForestFire[,3]),
                                                          selected = c("Acre"))
                                )
                              ) 
                            ))),
                            # Create tab for data table
                  tabPanel('TABLE', 
                           fluidRow(
                             column(3,
                                    selectInput("states","Select states:", unique(ForestFire[,3], multiple=TRUE)
                                                )
                                             ),
                                      hr(),
                                      tableOutput('table'))
                           ))


