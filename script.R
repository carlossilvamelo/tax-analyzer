
library(tidyverse)
#install.packages("tidyverse")
require(stringi)
require(stringr)
require(tm)

tributes = c(read.delim2("tributario.txt", encoding = 'UTF-8'))
tributes = stringi::stri_join_list(tributes)
tributes = stringr::str_split(tributes,fixed("SEÇÃO"))

lawList = removeStopWords(tributes[[1]])
lawList = preProcessTexts(lawList)
lawList


names(lawList)[1] = "law"
View(lawList)

for (law in lawList) {
  print(law)
}

lawData = data.frame("law"=lawList,"index"=c(1:length(lawList)))

elastic("http://localhost:9200", "law", "law") %index% lawData

for_everything <- query('"min_score": "2.5",{
                        "match": {
                        "law": "objetos vindos de outro pais, produto extrangeiro Exportacao exportados"
                        }
                        }')

minScore <- select_fields('{"includes": ["_score"]}')
result = elastic("http://localhost:9200", "law", "law") %search% for_everything
View(result)

text = "objetos vindos de outro pais, produto extrangeiro Exportacao exportados"

result = getLawList(text)
result$hits
hit = getBestScore(result)
View(hit)
hits = as.data.frame(result$hits)

View(hits)
View(parsedJson$hits)
httr::headers(result)