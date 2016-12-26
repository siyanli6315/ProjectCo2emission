#ui
library(shiny)
shinyUI(fluidPage(
  titlePanel("变化趋势"),
  selectInput("region","区域",c("东亚和太平洋","欧洲和中亚","拉美和加勒比海","中东和北非","南亚","撒哈拉以南非洲","全球","北美")),
  plotOutput("plot",height=500,width=800)
))
