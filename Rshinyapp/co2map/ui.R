library(shiny)

shinyUI(fluidPage(
  titlePanel("二氧化碳排放总量"),
  selectInput("fill","比较项目",c("二氧化碳排放总量","每GDP二氧化碳排放量","人均二氧化碳排放量")),
  sliderInput("year","年份",
              min=1990,max=2008,value=19),
  plotOutput("plot",height=500,width=900)
))