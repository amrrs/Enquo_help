# Module UI -------------------------------------------------------------------
TS_module_UI <- function(id) {
  ns <- NS(id)
  
  tagList(
    plotOutput(ns("lineplot")),
    dataTableOutput(ns("teamsynctable"))
  )
  
}

# Module server ---------------------------------------------------------------
TS_module <- function(input, output, session, data, prod_specific_type, x, y, z,show_data) {
  
  
  # Select product specific type and group either by Region, SalesTeam or Industry
  TS_with_type <- reactive({
  
    #Per @amrrs StackOverflow solution. Produces same error Object Cal.Month not found 
  
    first_group <- x()
    second_group <- z()
    #cat(first_group)
    #cat(second_group)
    data %>%
    filter(Prod.Specific == as.character(prod_specific_type)) %>%
      group_by_(first_group,second_group) %>%
      #group_by(eval(parse(text=first_group)), eval(parse(text=second_group))) %>%
      summarize(Amount = sum(Amount), Qty = sum(Qty))
    
    
    #Using Tidyverse programming with dplyr with enquo:
    
    # first_group<- x()
    # second_group<- z()
    # 
    # x<- enquo(first_group)
    # z<- enquo(second_group)
    # 
    # data %>%
    #   filter(Prod.Specific == as.character(prod_specific_type)) %>%
    #   group_by(!!x, !!z) %>%
    #   summarize(Amount = sum(Amount), Qty = sum(Qty))
 
    
    # Works if we input the z variable directly
    # data_filtered <- filter(data, Prod.Specific == as.character(prod_specific_type))
    # 
    # if(z() == "Region"){
    #   data_filtered %>% 
    #   group_by(Cal.Month, Region) %>% 
    #   summarize(Amount = sum(Amount), Qty = sum(Qty))
    # }
    # else if(z() == "Industry"){
    #   data_filtered %>% 
    #     group_by(Cal.Month, Industry) %>% 
    #     summarize(Amount = sum(Amount), Qty = sum(Qty))
    # }
    
    
  })
  
 #Create the lineplot object the plotOutput function is expecting --------
 output$lineplot <- renderPlot({
     ggplot(data = TS_with_type(), aes_string(x = x(), y = y())) +
     geom_line()

 })
  
  
  # Print data table if checked -----------------------------------------------
  output$teamsynctable <- DT::renderDataTable(
    if(show_data()){
      DT::datatable(data = TS_with_type(), 
                    options = list(pageLength = 10), 
                    rownames = FALSE)
    }
  )
  
}
