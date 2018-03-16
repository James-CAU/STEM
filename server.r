#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#



# Define server logic 
shinyServer(function(input, output) {
  
  # install.packages("curl")
  library("curl")
  
  # install.packages("networkD3")
  library("networkD3")
  
  # install.packages("RODBC")
  library("RODBC")
  
  
  #Action button trigger
  observeEvent(input$newplot,  {
    
    
    # Create a loading bar
    progress <- shiny::Progress$new()
    # Make sure it closes when we exit this reactive, even if there's an error
    on.exit(progress$close())
    
    progress$set(message = "Making diagram", value = 0)
    
    progress$inc(0, detail = "Doing part 1")
    
    
    #Getting variables to use in SQL code
    
    ##Import data from SQL:
    con<-odbcConnect('SQL') #opening odbc connection
    
    progress$inc(1/3, detail = "Doing part 2")
    
    #KS2 to KS4 connections 
    ks2toks4_1 <- sqlQuery(con, paste0("SELECT ", input$KS2, ", ", input$KS4 ,", COUNT(*) AS frequency
                                       
                                       FROM [MDR_Modelling_DSAG_STEM].[AD\\JLOWE2].[FULL_TABLE]
                                       WHERE [KS4_AY] = ",input$cohort1, 
                                       " AND [GENDER] IN ",input$gender1,
                                       input$FSM1,
                                       input$Region1,
                                       " GROUP BY ", input$KS2, " , " , input$KS4 ,
                                       " ORDER BY ", input$KS2, " , " , input$KS4  ), stringsAsFactors = FALSE, nullstring = "N/A"
    ) 
    
    ks2toks4_2 <- sqlQuery(con, paste0("SELECT ", input$KS2, ", ", input$KS4 ,", COUNT(*) AS frequency
                                       
                                       FROM [MDR_Modelling_DSAG_STEM].[AD\\JLOWE2].[FULL_TABLE]
                                       WHERE [KS4_AY] = ",input$cohort2,
                                       input$FSM2,
                                       input$Region2,
                                       " AND [GENDER] IN ",input$gender2,
                                       " GROUP BY ", input$KS2, " , " , input$KS4 ,
                                       " ORDER BY ", input$KS2, " , " , input$KS4  ), stringsAsFactors = FALSE, nullstring = "N/A"
    ) 
    
    #KS4 to FE connections 
    ks4toFE_1 <- sqlQuery(con, paste0("SELECT ", input$KS4, ", ", input$FE ,", COUNT(*) AS frequency
                                      
                                      FROM [MDR_Modelling_DSAG_STEM].[AD\\JLOWE2].[FULL_TABLE]
                                      WHERE [KS4_AY] = ",input$cohort1, 
                                      " AND [GENDER] IN ",input$gender1,
                                      input$FSM1,
                                      input$Region1,
                                      " GROUP BY ", input$KS4, " , " , input$FE ,
                                      " ORDER BY ", input$KS4, " , " , input$FE  ), stringsAsFactors = FALSE, nullstring = "N/A"
    )  
    
    ks4toFE_2 <- sqlQuery(con, paste0("SELECT ", input$KS4, ", ", input$FE ,", COUNT(*) AS frequency
                                      
                                      FROM [MDR_Modelling_DSAG_STEM].[AD\\JLOWE2].[FULL_TABLE]
                                      WHERE [KS4_AY] = ",input$cohort2, 
                                      " AND [GENDER] IN ",input$gender2,
                                      input$FSM2,
                                      input$Region2,
                                      " GROUP BY ", input$KS4, " , " , input$FE ,
                                      " ORDER BY ", input$KS4, " , " , input$FE  ), stringsAsFactors = FALSE, nullstring = "N/A"
    )  
    
    #FE to HE connections 
    FEtoHE_1 <- sqlQuery(con, paste0("SELECT ", input$FE, ", ", input$HE ,", COUNT(*) AS frequency
                                     
                                     FROM [MDR_Modelling_DSAG_STEM].[AD\\JLOWE2].[FULL_TABLE]
                                     WHERE [KS4_AY] = ",input$cohort1, 
                                     " AND [GENDER] IN ",input$gender1,
                                     input$FSM1,
                                     input$Region1,
                                     " GROUP BY ", input$FE, " , " , input$HE ,
                                     " ORDER BY ", input$FE, " , " , input$HE  ), stringsAsFactors = FALSE, nullstring = "N/A"
    )   
    
    FEtoHE_2 <- sqlQuery(con, paste0("SELECT ", input$FE, ", ", input$HE ,", COUNT(*) AS frequency
                                     
                                     FROM [MDR_Modelling_DSAG_STEM].[AD\\JLOWE2].[FULL_TABLE]
                                     WHERE [KS4_AY] = ",input$cohort2, 
                                     " AND [GENDER] IN ",input$gender2,
                                     input$FSM2,
                                     input$Region2,
                                     " GROUP BY ", input$FE, " , " , input$HE ,
                                     " ORDER BY ", input$FE, " , " , input$HE  ), stringsAsFactors = FALSE, nullstring = "N/A"
    )   
    
    close(con)
    
    
    progress$inc(1/3, detail = "Doing part 3")
  
    #Create output tables
    
    table2to4_1 <- percentages(ks2toks4_1)
    table2to4_2 <- percentages(ks2toks4_2)
    table4toFE_1 <- percentages(ks4toFE_1)
    table4toFE_2 <- percentages(ks4toFE_2)
    tableFEtoHE_1 <- percentages(FEtoHE_1)
    tableFEtoHE_2 <- percentages(FEtoHE_2)
    
    
    
    

    output$table_2to4_1 <- renderTable(table2to4_1)
    output$table_2to4_2 <- renderTable(table2to4_2)
    output$table_4toFE_1 <- renderTable(table4toFE_1)
    output$table_4toFE_2 <- renderTable(table4toFE_2)
    output$table_FEtoHE_1 <- renderTable(tableFEtoHE_1)
    output$table_FEtoHE_2 <- renderTable(tableFEtoHE_2)
    
    
    
      
    #Output sankey 1:
    #Need to have columns called the same ting
    colnames(ks2toks4_1) <- c("source","target","value")
    colnames(ks4toFE_1) <- c("source","target","value")
    colnames(FEtoHE_1) <- c("source","target","value")
    
    #This is to make sure the Sankey doesn't get confused if the same variable comes up twice.
    ks2toks4_1[,1] <- paste0(ks2toks4_1[,1], "")
    ks2toks4_1[,2] <- paste0(ks2toks4_1[,2], " " )
    
    ks4toFE_1[,1] <- paste0(ks4toFE_1[,1], " " )
    ks4toFE_1[,2] <- paste0( ks4toFE_1[,2], "  ")
    
    FEtoHE_1[,1] <- paste0(FEtoHE_1[,1], "  " )
    FEtoHE_1[,2] <- paste0(FEtoHE_1[,2], "   ")
    
    
    
    edgelist1 <- rbind(ks2toks4_1,ks4toFE_1, FEtoHE_1 )
    
    colnames(edgelist1) <- c("source","target","value")
    
    #make character rather than numeric for proper functioning
    
    edgelist1$source <- as.character(edgelist1$source)
    edgelist1$target <- as.character(edgelist1$target)
    
    
    #Gives the nodes their name and then creates links  
    node_names1 <- factor(sort(unique(c(as.character(edgelist1$source), 
                                        as.character(edgelist1$target)))))
    nodes1 <- data.frame(name = node_names1)
    links1 <- data.frame(source = match(edgelist1$source, node_names1) - 1, 
                         target = match(edgelist1$target, node_names1) - 1,
                         value = edgelist1$value)
    
    #Plot the sankey:
    output$sankey1 <- renderSankeyNetwork({sankeyNetwork(Links = links1, Nodes = nodes1, Source = 'source',
                                                         Target = 'target', Value = 'value', NodeID = 'name',
                                                         fontSize = 12, height = 5, width = 100, nodeWidth = 4, iterations = 0)     })
    
    #Output sankey 2:
    #Need to have columns called the same ting
    colnames(ks2toks4_2) <- c("source","target","value")
    colnames(ks4toFE_2) <- c("source","target","value")
    colnames(FEtoHE_2) <- c("source","target","value")
    
    #This is to make sure the Sankey doesn't get confused if the same variable comes up twice.
    ks2toks4_2[,1] <- paste0(ks2toks4_2[,1], "")
    ks2toks4_2[,2] <- paste0(ks2toks4_2[,2], " " )
    
    ks4toFE_2[,1] <- paste0(ks4toFE_2[,1], " " )
    ks4toFE_2[,2] <- paste0( ks4toFE_2[,2], "  ")
    
    FEtoHE_2[,1] <- paste0(FEtoHE_2[,1], "  " )
    FEtoHE_2[,2] <- paste0(FEtoHE_2[,2], "   ")
    
    edgelist2 <- rbind(ks2toks4_2,ks4toFE_2, FEtoHE_2 )
    
    colnames(edgelist2) <- c("source","target","value")
    
    #make character rather than numeric for proper functioning
    
    edgelist2$source <- as.character(edgelist2$source)
    edgelist2$target <- as.character(edgelist2$target)
    
    
    
    #Gives the nodes their name and then creates links  
    node_names2 <- factor(sort(unique(c(as.character(edgelist2$source), 
                                        as.character(edgelist2$target)))))
    nodes2 <- data.frame(name = node_names2)
    links2 <- data.frame(source = match(edgelist2$source, node_names2) - 1, 
                         target = match(edgelist2$target, node_names2) - 1,
                         value = edgelist2$value)
    
    #Plot the sankey:
    output$sankey2 <- renderSankeyNetwork({sankeyNetwork(Links = links2, Nodes = nodes2, Source = 'source',
                                                         Target = 'target', Value = 'value', NodeID = 'name',
                                                         fontSize = 12, height = 5, width = 100, nodeWidth = 4, iterations = 0)     })
    
    
    
    output$KS2_name <- renderPrint({input$KS2})
    output$KS4_name <- renderPrint({input$KS4})
    output$FE_name <- renderPrint({input$FE})
    output$HE_name <- renderPrint({input$HE})
    
    output$KS2_name2 <- renderPrint({input$KS2})
    output$KS4_name2 <- renderPrint({input$KS4})
    output$FE_name2 <- renderPrint({input$FE})
    output$HE_name2 <- renderPrint({input$HE})
    
  })
})