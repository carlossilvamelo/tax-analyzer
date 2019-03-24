rm(list = ls())
#------------------------ imports ------------------------
#install.packages("readxl")
#install.packages("stringr")
#install.packages("shinyjs")
#install.packages("shinyWidgets")
#install.packages("shinydashboard")

#devtools::install_github("hadley/shinySignals")
#install.packages("plyr")
#library("readxl")
#library("doParallel")
library("stringr")
library("shinyjs")
#library("stats")
#library("compiler")
library(plyr)
library(shiny)
library(shinyWidgets)
library(jsonlite)
library(httr)
require(elasticsearchr)
#library(devtools)
#devtools::install_github("alexioannides/elasticsearchr")
#library(elasticsearchr)

library(shinydashboard)

#----------------------- initializarions -----------------

ROOT = paste(getwd(),"/",sep = "")

source("functions.R")
#--------------------------------

modalDicas <- function(texto) {
  blub <- modalDialog(
    title = "Informações",texto,
    footer = modalButton("Fechar")
  )
  return(blub)
}
