library(shiny)

shinyUI(fluidPage(
  titlePanel("分区域比较"),
  selectInput("fill","比较项目",c("二氧化碳排放总量","每GDP二氧化碳排放量","人均二氧化碳排放量")),
  plotOutput("plot",height=800,width=500)
))


