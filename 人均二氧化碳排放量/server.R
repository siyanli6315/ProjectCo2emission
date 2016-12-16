#1215shinyapp人均二氧化碳排放量
##server部分
options(warn=-1)
library(shiny)
library(ggplot2)
library(showtext)
library(scales)
library("latex2exp")
library(grid)
library(grDevices)
showtext.auto(enable=T)

load("pcb.rda")
load("pc.rda")

pfun1=function(data1,data2,year){
  yr=paste("X",year,sep="")
  tmp=data1[,c(1:8)]
  tmp$fill=data1[,yr]
  ph1=ggplot(tmp,aes(x=long, y=lat,group=group,fill=fill))+
    scale_fill_gradient(limits=c(0,30),
                        high=muted("red"),
                        low="gray")+
    geom_polygon()+
    theme_classic()+
    theme(legend.title=element_blank(),
          legend.position=c(0.55,0.1),
          legend.direction="horizontal",
          legend.text=element_text(size=10),
          axis.title=element_blank(),
          axis.text=element_blank(),
          axis.ticks=element_blank(),
          axis.line=element_blank())
  tmp2=data2[order(data2[,yr],decreasing=T)[1:20],]
  tmp2$ID=factor(tmp2$ID,levels=tmp2$ID)
  ph2=ggplot(tmp2,aes(x=ID,y=tmp2[,yr],fill=tmp2[,yr]))+
    geom_bar(stat="identity")+
    scale_fill_gradient(high=muted("red"),
                        low="gray")+
    coord_flip()+
    theme_classic()+
    theme(legend.position="None",
          axis.title=element_blank(),
          axis.text=element_text(size=10))
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(1,10)))
  vplayout <- function(x,y){
    viewport(layout.pos.row = x, layout.pos.col = y)
  }
  print(ph1, vp = vplayout(1,1:7))
  print(ph2, vp = vplayout(1,8:10))
}

shinyServer(function(input,output){
  output$plot=renderPlot(pfun1(pcb,pc,input$year))
})