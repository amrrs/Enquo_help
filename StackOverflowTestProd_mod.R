#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(DT)
library(stringr)
library(tools)
library(dplyr)
library(tidyverse)
library(highcharter)

#load data file
ts_data <- read.csv("StackOverflow_Garret2.csv", stringsAsFactors = F)

source("Testmodule.R")

# Define UI for application 
ui <- fluidPage(
  
  # Application title ---------------------------------------------------------
  titlePanel("TeamSync - with modules"),
  
  # Sidebar layout 
  sidebarLayout(
    
    # Inputs: Select variables to plot ----------------------------------------
    sidebarPanel(
      
      # Select variable for y-axis --------------------------------------------
      selectInput(inputId = "y", 
                  label = "Choose Qty or $$Amt:",
                  choices = c("Quantity" = "Qty", 
                              "$$ Amt" = "Amount"), 
                  selected = "Qty"),
      
      # Select variable for x-axis --------------------------------------------
      selectInput(inputId = "x", 
                  label = "Time-Frame:",
                  choices = c("Monthly" = "Cal.Month", 
                              "Yearly" = "Year"), 
                  selected = "Cal.Month"),
      
      # Select variable for grouping ---------------------------------------------
      selectInput(inputId = "z", 
                  label = "Group by:",
                  choices = c("Region" = "Region",
                              "Industry" = "Industry", 
                              "Sales Team" = "SalesTeam"),
                  selected = "Region"),
      
      # Show data table -------------------------------------------------------
      checkboxInput(inputId = "show_data",
                    label = "Show data table",
                    value = TRUE)
      
    ),
    
    # Output: -----------------------------------------------------------------
    mainPanel(
      
      # Show line plot per respective tab 
      tabsetPanel(id = "ts_data", 
                  tabPanel("A", TS_module_UI("new")),
                  tabPanel("B", TS_module_UI("add")),
                  tabPanel("C", TS_module_UI("renew"))
      )
      
    )
  )
)

# Define server function required to create the lineplot -------------------
server <- function(input, output, session) {
  
  x     <- reactive(input$x)
  y     <- reactive(input$y)
  z     <- reactive(input$z)
  show_data <- reactive(input$show_data)
  
  # Create the scatterplot object the plotOutput function is expecting --------
  callModule(TS_module, "new", data = ts_data, prod_specific_type = "A", x, y, z, show_data)
  callModule(TS_module, "add", data = ts_data, prod_specific_type = "B", x, y, z, show_data)
  callModule(TS_module, "renew", data = ts_data, prod_specific_type = "C", x, y, z, show_data)
  
}


shinyApp(ui = ui, server = server)

