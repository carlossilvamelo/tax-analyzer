removeStopWords <- function(phrase){
  
  stopWordList = c(stopwords(kind="portuguese"),"Art")
  return(tm::removeWords(phrase, stopWordList))
}

preProcessTexts <- function(list){
  
  list = str_replace_all(list, "\n", " ")
  list = str_replace_all(list, "\t"," ")
  list = str_replace_all(list, "\f"," ")
  list = str_replace_all(list, "-","")
  list = str_replace_all(list, "[:digit:]","")
  list = str_replace_all(list, "Art.","")
  list = str_replace_all(list, "[:punct:]","")
  list = str_replace_all(list, " {2,}"," ")
  list =stri_trans_general(list, "Latin-ASCII")

  return(list)
}

getLawList <- function(text){
  text = stri_trans_general(text, "Latin-ASCII")
  text = str_c('{"query": {"match": {"law": "',text,'"}}}')
  result = httr::POST("http://localhost:9200/_search",add_headers('Content-Type'='application/json'),body=text,encode = c("multipart", "form", "json", "raw"))
  
  
  parsedJson <- fromJSON(httr::content(result,"text"))
  return(parsedJson)
}


getBestScore <- function(resultRequest){


  if(resultRequest$hits$total == 0)
    return(NULL)
  maxScore = resultRequest$hits$max_score
  hits = as.data.frame(resultRequest$hits)
  hits = hits[hits$hits._score >= maxScore-0.7,]
  return(hits)
}

lawNames = c(
  "Impostos sobre Importacao",
  "Impostos sobre Exportacao",
  "Imposto sobre Propriedade Territorial Rural",
  "Impostos sobre Propriedade Predial Territorial Urbana",
  "Imposto sobre Transmissao Bens Imoveis Direitos Relativos",
  "Impostos sobre Renda Proventos Qualquer Natureza",
  "Imposto sobre Produtos Industrializados",
  "Imposto sobre Operacoes Credito Cambio Seguro",
  "Imposto sobre Servicos Transportes Comunicacoes",
  "Imposto sobre Operacoes Relativas Combustiveis Lubrificantes"
)
lawCode = c("II", 
            "IE", 
            "ITR",
            "IPTU",
            "ITBI",
            "IR",
            "IPI",
            "IOF",
            "ISTC",
            "Impostos especiais"
            )
aliquotList = c(
  0.18,
  0.13,
  0.11,
  0.15,
  0.30,
  0.13,
  0.11,
  0.32,
  0.08,
  0.12
  )
taxList = data.frame(name=lawNames, code = lawCode, aliquot = aliquotList)


#imp = "I Imposto sobre Propriedade Territorial Rural O imposto competencia Uniao sobre propriedade territorial ruraltem fato gerador propriedade dominio util posse imovel natureza definido lei civil localizacao zona urbana Municipio A base calculo imposto e valor fundiario Contribuinte imposto e proprietario imovel titular dominioutil possuidor qualquer titulo"
#res = str_detect(toupper(imp), str_split(toupper("Imposto sobre a Propriedade Territorial Rural"),fixed(" "))[[1]])


classifyByName <- function(lawText){
  result = data.frame()
  print(lawText)
  for (name in taxList$name) {
    #print(stri_trans_general(name, "Latin-ASCII"))
    #print(lawText)
    if(str_detect(stri_trans_general(toupper(lawText), "Latin-ASCII"), toupper(name))){

      result = rbind(taxList[taxList$name == name,])
    }
  }
  return(result)
  #return(taxList[taxList$name == name,])
}
