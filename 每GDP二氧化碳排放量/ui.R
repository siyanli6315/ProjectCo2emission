#1215shinyapp每GDP二氧化碳排放量
##ui部分
options(warn=-1)
library(shiny)
library(ggplot2)
library(showtext)
library(scales)
library("latex2exp")
library(grid)
library(grDevices)
showtext.auto(enable=T)

shinyUI(fluidPage(
  titlePanel("每GDP二氧化碳排放量地图"),
  sliderInput("year","年份",
              min=1990,max=2008,value=19),
  plotOutput("plot",height=500,width=900)
))