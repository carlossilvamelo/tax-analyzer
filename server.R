# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  observeEvent(input$btDescCenario,{
    result = getLawList(input$textCenario)
    hit = getBestScore(result)
    #print(hit$hits._source$law)
    #print(classifyByName(hit$hits._source$law))
    taxList = classifyByName(hit$hits._source$law)
    taxName = as.character(taxList$name[1])
    code = as.character(taxList$code[1])
    aliquot = as.numeric(taxList$aliquot[1])
    value = as.numeric(input$inputValue)
    output$outputText <- renderText({ 
      str_c("Imposto: ",taxName," - ",code,
            "\n Aliquota: ",aliquot,
            "\n value: ",value-(value*aliquot))  })
  })
  
}