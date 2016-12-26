library(shiny)
shinyUI(fluidPage(
  titlePanel("气泡图"),
  sliderInput("year","年份",
              min=1990,max=2008,value=19),
  plotOutput("plot",height=500,width=800)
))
