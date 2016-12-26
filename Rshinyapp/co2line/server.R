#server

library(shiny)
library(ggplot2)
library(sysfonts)
library(showtext)
library(scales)
library("latex2exp")
library(plyr)
library(reshape2)
library(grid)
library(grDevices)
showtext.auto(enable=T)

all_region=read.csv("all_region.csv",header=T)

pfun=function(region){
  options(warn=-1)
  tmp=all_region[all_region$region==region,]
  tmp=na.omit(tmp)
  ph1=ggplot(data=tmp,aes(x=year,y=y))+
    geom_line(linetype=1,size=1,color="darkred")+
    geom_point(size=3,shape=15,color="darkred")+
    geom_point(size=0.1,color="white",aes(y=y*1.1))+
    geom_text(data=tmp[tmp$year%in%c(min(tmp$year),2000,max(tmp$year)),],aes(x=year,y=y,label=y),vjust=-1,color="darkred")+
    scale_x_continuous(limits=c(1990,2008),
                       breaks=c(1990:2008),
                       labels=as.character(1990:2008))+
    labs(x="年份",y="")+
    theme(legend.position = "None",
          axis.title=element_text(size=18),
          axis.text.y=element_text(size=10),
          axis.text.x=element_text(size=10,angle=45,
                                   vjust=1,hjust=0.9))+
    facet_wrap(~fill,ncol=1,scales = "free_y")
  
  cut=cumsum(c(table(tmp$fill)))
  n=nrow(tmp)
  year=(tmp$year[-1]+tmp$year[-n])/2
  rate=(tmp$y[-1]-tmp$y[-n])/tmp$y[-n]
  tmp2=data.frame(fill=paste(tmp$fill[-cut],"变化率",sep=""),year=year[-cut],rate=rate[-cut])
  tmp2$rate2=paste(round(tmp2$rate*100,1),"%",sep="")
  
  ph2=ggplot(data=tmp2)+
    geom_bar(aes(x=year,y=rate),
             stat="identity",fill="darkred")+
    geom_text(aes(x=year,y=rate,label=rate2),size=2)+
    scale_x_continuous(limits=c(1990,2008),
                       breaks=c(1990:2008),
                       labels=as.character(1990:2008))+
    #scale_y_continuous(limits = c(-0.06,0.06),
    #                   breaks = c(-0.06,0,0.06),
    #                   labels = c("-6%","0","6%"))+
    labs(x="年份",y="")+
    theme(legend.position = "None",
          axis.title=element_text(size=18),
          axis.text.y=element_text(size=10),
          axis.text.x=element_text(size=10,angle=45,
                                   vjust=1,hjust=0.9))+
    facet_wrap(~fill,ncol=1)
  
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(2,2)))
  vplayout <- function(x,y){
    viewport(layout.pos.row = x, layout.pos.col = y)
  }
  print(ph1, vp = vplayout(1:2,1))
  print(ph2, vp = vplayout(1:2,2))
}

shinyServer(function(input,output){
  output$plot=renderPlot(pfun(input$region))
})
