

useShinyjs()#Utilizar javascript 

fluidPage(
  tags$head(
    useShinyjs(),useSweetAlert(),
    HTML('<meta charset="UTF-8">')
  ),
  dashboardPage(
    dashboardHeader(title = "taxEngine"),
    dashboardSidebar(
      
      sidebarMenu(
        menuItem("draft", tabName = "dataExplorerMenu"
                 , icon = icon("database", class = NULL, lib = "font-awesome"))
        
      )
    ),
    
    
    
    dashboardBody(class="containerIngestData",
                  tags$div(id="loader",class="loader"),
      tabItems(
        tabItem(class="","dataExplorerMenu",
                box(id="boxTablePreview",class="containerTable",width = "100%",
                    collapsible = T,
                    numericInput("inputValue", "R$:", 100, min = 0),
                    textAreaInput("textCenario",value = "objetos vindos de outro pais, produto extrangeiro Exportacao exportados", "cenario", width = "100%"),
                    
                    actionButton("btDescCenario", "send")
                ),
                box(id="boxTablePreview",class="containerTable",width = "100%",
                    collapsible = T,
                    
                    verbatimTextOutput("outputText")
                )
                
        )
      )
      )
)


)

