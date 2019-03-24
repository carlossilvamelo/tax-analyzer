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
  maxScore = resultRequest$hits$max_score
  hits = as.data.frame(resultRequest$hits)
  hits = hits[hits$hits._score == maxScore,]
  return(hits)
}

lawNames = c(
  "Impostos sobre a Importação",
  "Impostos sobre Exportação",
  "Imposto sobre a Propriedade Territorial Rural",
  "Impostos sobre a Propriedade Predial e Territorial Urbana",
  "Imposto sobre a Transmissão de Bens Imóveis e de Direitos a eles Relativos",
  "Impostos sobre a Renda e Proventos de Qualquer Natureza",
  "Imposto sobre Produtos Industrializados",
  "Imposto sobre Operações de Crédito, Câmbio e Seguro, e sobre Operações Relativas a Títulos e Valores Mobiliários",
  "Imposto sobre Serviços de Transportes e Comunicações"
)
lawCode = c("II", 
            "IE", 
            "ITR",
            "IPTU",
            "ITBI",
            "IR",
            "IPI",
            "IOF",
            "ISTC"
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
  0.08
  )
taxList = data.frame(name=lawNames, code = lawCode, aliquot = aliquotList)


#imp = "I Imposto sobre Propriedade Territorial Rural O imposto competencia Uniao sobre propriedade territorial ruraltem fato gerador propriedade dominio util posse imovel natureza definido lei civil localizacao zona urbana Municipio A base calculo imposto e valor fundiario Contribuinte imposto e proprietario imovel titular dominioutil possuidor qualquer titulo"
#str_detect(str_split(toupper("Imposto sobre a Propriedade Territorial Rural"),fixed(" "))[[1]],toupper(imp))
#str_detect("%carlos%","carlos melo")




classifyByName <- function(lawList){
  for (name in taxList$name) {
    #if(str_detect(toupper(name),toupper(lawList)))
    if(grepl(x=lawList,
             pattern = str_split(name,fixed(" "))[[1]],
             ignore.case = TRUE)) 
     return(taxList[taxList$name == name,])
  }
  return(NULL)
}
