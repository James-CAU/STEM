#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#



# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Sankey experiment"),
  
  # Controls at the top
  
  
  fluidRow(
    
    column(2,
           radioButtons("KS2", "KS2 subject:",
                        selected=NULL,
                        c("Maths"          = "[KS2_Maths_grouped]" ,
                          "Science"        = "[KS2_Sci_grouped]" 
                        ))),
    column(2,
           radioButtons("KS4", "KS4 subject:",
                        selected=NULL,
                        c("KS4 science type"          = "[KS4_Science_Type]" ,
                          "Maths attainment"          = "[GCSE_Maths]",
                          "Level 2 science type"      = "[Level_2_Science_Type]"
                        ))),
    
    column(2,
           radioButtons("FE", "KS5:",
                        selected=NULL,
                        c("KS5 science type (1)"                 = "[KS5_Science_Type_1]",
                          "KS5 science type (2)"                 = "[KS5_Science_Type_2]",
                          "KS5 science type (3)"                 = "[KS5_Science_Type_3]",
                          "Number of core STEM A-Levels"     = "[core_STEM_A_LEVELS_grouped]" ,
                          "Number of STEM related A-Levels"  = "[STEM_related_A_LEVELS_grouped]" ,
                          "Level 3 science type"             = "[Level_3_Science_Type]"
                        ))),
    
    column(2,
           radioButtons("HE", "HE:",
                        selected=NULL,
                        c("HE science type (comparable)"     = "[HE_Science_Type_comparable]" ,
                          "HE science type"                 = "[HE_Science_Type]" 
                        )))
  ),
  
  
  fluidRow(
    column(6,
           h4("Conditions on graph 1")),
    column(5,
           h4("Conditions on graph 2"))),
  
  fluidRow(
    
    #Conditioning 
    column(2, 
           radioButtons("gender1", "Gender:",
                        selected=NULL,
                        c("All"      = "('M', 'F')", 
                          "Female"          = "('F')" ,
                          "Male"        = "('M')" 
                        )),
           
           selectInput("FSM1", "Ever FSM:",
                       choices =
                         c("All"      = " AND [FSM_Ever] IN (0,1) ",
                           "Yes"      = " AND [FSM_Ever] = 1 ", 
                           "No"       = " AND [FSM_Ever] = 0 " 
                         )) 
           
    ), 
    
    
    
    
    column(3, 
           selectInput("cohort1", "AY of cohort at KS4:",
                       choices =
                         c("2006/07" = "'200607'",
                           "2007/08" = "'200708'",
                           "2008/09" = "'200809'",
                           "2009/10" = "'200910'")),
           
           selectInput("Region1", "Choose the region:", 
                       choices = 
                         c("All" = " ",
                           "01 North East"           = " AND [KS4_REGION] = '01_North East' ",
                           "02 North West"           = " AND [KS4_REGION] = '02_North West' ",
                           "03 Yorkshire & Humber"   = " AND [KS4_REGION] = '03_Yorkshire & Humber' ",
                           "04 East Midlands"        = " AND [KS4_REGION] = '04_East Midlands' ",
                           "05 West Midlands"        = " AND [KS4_REGION] = '05_West Midlands' ",
                           "06 East"                 = " AND [KS4_REGION] = '06_East' ",
                           "07 Inner London"         = " AND [KS4_REGION] = '07_Inner London' ",
                           "08 Outer London"         = " AND [KS4_REGION] = '08_Outer London' ",
                           "09 South East"         = " AND [KS4_REGION] = '09_South East' ",
                           "10 South West"         = " AND [KS4_REGION] = '10_South West' "))
           
           
    ),
    column(1, 
           h4(" ")),
    
    column(2, 
           radioButtons("gender2", "Gender:",
                        selected=NULL,
                        c("All"      = "('M', 'F')", 
                          "Female"          = "('F')" ,
                          "Male"        = "('M')" 
                        )),
           
           selectInput("FSM2", "Ever FSM:",
                       choices =
                         c("All"      = " AND [FSM_Ever] IN (0,1) ",
                           "Yes"      = " AND [FSM_Ever] = 1 ", 
                           "No"       = " AND [FSM_Ever] = 0 " 
                         )) 
           
    ), 
    
    
    
    
    column(3, 
           selectInput("cohort2", "AY of cohort at KS4:",
                       choices =
                         c("2006/07" = "'200607'",
                           "2007/08" = "'200708'",
                           "2008/09" = "'200809'",
                           "2009/10" = "'200910'")),
           selectInput("Region2", "Choose the region:", 
                       choices = 
                         c("All" = " ",
                           "01 North East"           = " AND [KS4_REGION] = '01_North East' ",
                           "02 North West"           = " AND [KS4_REGION] = '02_North West' ",
                           "03 Yorkshire & Humber"   = " AND [KS4_REGION] = '03_Yorkshire & Humber' ",
                           "04 East Midlands"        = " AND [KS4_REGION] = '04_East Midlands' ",
                           "05 West Midlands"        = " AND [KS4_REGION] = '05_West Midlands' ",
                           "06 East"                 = " AND [KS4_REGION] = '06_East' ",
                           "07 Inner London"         = " AND [KS4_REGION] = '07_Inner London' ",
                           "08 Outer London"         = " AND [KS4_REGION] = '08_Outer London' ",
                           "09 South East"         = " AND [KS4_REGION] = '09_South East' ",
                           "10 South West"         = " AND [KS4_REGION] = '10_South West' "))
    )),
  
  actionButton("newplot", "New plot"),
  
  # Show a plot of the generated distribution
  tabsetPanel(
    tabPanel("Graph 1", 
             fluidPage(
               fluidRow(
                 column(3, textOutput("KS2_name")),
                 column(4, textOutput("KS4_name")),
                 column(3, textOutput("FE_name")),
                 column(2, textOutput("HE_name"))
               ),
               sankeyNetworkOutput("sankey1"))), 
    tabPanel("Graph 2", 
             fluidPage(
               fluidRow(
                 column(3, textOutput("KS2_name2")),
                 column(4, textOutput("KS4_name2")),
                 column(3, textOutput("FE_name2")),
                 column(2, textOutput("HE_name2"))
               ),
               sankeyNetworkOutput("sankey2"))),
    
    
    #tables
    tabPanel("Table 1", 
             fluidRow(
               column(1, h5("Size of cohort 1:")),
               column(1, textOutput("cohort_1"))),
             
             tabsetPanel(
               tabPanel("KS2 to KS4",
               tableOutput("table_2to4_1")),
               
               tabPanel("KS4 to FE",
               tableOutput("table_4toFE_1")),
               
               tabPanel("FE to HE",
               tableOutput("table_FEtoHE_1"))
                 
               
             )
             ),

    
    tabPanel("Table 2", 
             fluidRow(
               column(1, h5("Size of cohort 2:")),
              column(1, textOutput("cohort_2"))),
             
             tabsetPanel(
               tabPanel("KS2 to KS4",
                        tableOutput("table_2to4_2")),
               
               tabPanel("KS4 to FE",
                        tableOutput("table_4toFE_2")),
               
               tabPanel("FE to HE",
                        tableOutput("table_FEtoHE_2"))
               
               
             )
    )
  )
  
)
)
