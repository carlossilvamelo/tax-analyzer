# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  observeEvent(input$btDescCenario,{
    result = getLawList(input$textCenario)
    hits = getBestScore(result)
    #print(class(hits$hits._source$law))
    #print(hits$hits._source$law)
    hh = hits
    #print(hits)
    outputTax = ""
    for (i in 1:nrow(hits$hits._source)) {
      row = hits$hits._sourc[i,]
      taxList = classifyByName(row$law)
      taxName = as.character(taxList$name[1])
      code = as.character(taxList$code[1])
      aliquot = as.numeric(taxList$aliquot[1])
      value = as.numeric(input$inputValue)
      outputTax = str_c(outputTax, "Tax name: ",taxName," - ",code,
                        "\nAliquot: ",aliquot,
                        "\n value: ",value-(value*aliquot)
                        ,"\n -------------------------------------- \n")
      }
    
    output$outputText <- renderText({ 
      outputTax  })
  })
  
}