#1215shinyapp气泡图
##ui部分
options(warn=-1)
library(shiny)
library(ggplot2)
library(showtext)
library(scales)
library("latex2exp")
library(plyr)
library(grid)
showtext.auto(enable=T)

shinyUI(fluidPage(
  titlePanel("气泡图"),
  sliderInput("year","年份",
              min=1990,max=2008,value=19),
  plotOutput("plot",height=500,width=700)
))