#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#




#library(tidyverse)
library(shiny)

tib <- as_tibble(RegSeason.test)
tib$pred_Efg.y <- modeloutput
tib$EFG_Regular_Season <- tib$EfgPct.x
tib$EFG_Post_Season <- tib$EfgPct.y
tib$EFG_Predicted_Post_Season <- tib$pred_Efg.y

shinyApp(
    ui = pageWithSidebar(
        headerPanel("NBA EFG Percentage Playoffs"),
        sidebarPanel(
            selectizeInput('var1', 'Select a Player', choices = c("choose" = "", sort(unique(tib$Name)))),
            selectizeInput('var2', 'Select a Season', choices = c("choose" = "", unique(tib$Season[order(tib$Season)])))
        ),
        
        mainPanel(
            h4("Effective Field Goal Percentages"),
            tableOutput("table")
        )
    ),
    
    server = function(input, output, session) {
        
        tab <- reactive({ # <-- Reactive function here
            
            tib %>% 
                filter(Name == input$var1) %>% 
                filter(Season == input$var2) %>% 
                ###### PUT THE VARIABLES YOU WANT IN HERE    
                select(Name, Season, EFG_Regular_Season, EFG_Post_Season, EFG_Predicted_Post_Season)
            
        })
        
        output$table <- renderTable({ 
            
            tab()
            
        })
        
        
        
    },
    
    options = list(height = 500)
    
)
