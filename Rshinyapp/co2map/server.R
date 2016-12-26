library(shiny)
library(ggplot2)
library(showtext)
library(scales)
library("latex2exp")
library(plyr)
library(grid)
library(grDevices)
showtext.auto(enable=T)

load("totb.rda")
load("tot.rda")
load("pgb.rda")
load("pg.rda")
load("pcb.rda")
load("pc.rda")

pfun1=function(data1,data2,year){
  yr=paste("X",year,sep="")
  tmp1=data1[,c(1:8)]
  tmp1$fill=data1[,yr]
  ph1=ggplot(tmp1,aes(x=long, y=lat,group=group,fill=fill))+
    scale_fill_gradient2(midpoint=median(tot$X2008,na.rm=T),
                         high=muted("red"),
                         mid="gray",
                         low="blue")+
    geom_polygon()+
    theme_classic()+
    theme(legend.title=element_blank(),
          legend.position="None",
          axis.title=element_blank(),
          axis.text=element_blank(),
          axis.ticks=element_blank(),
          axis.line=element_blank())
  data2=data.frame(ID=data2[,23],y=data2[,yr])
  tmp2=data2[order(data2$y,decreasing=T)[1:10],]
  tmp2$ID=factor(tmp2$ID,levels=tmp2$ID)
  ph2=ggplot(tmp2,aes(x=ID,y=y,fill=y))+
    geom_bar(stat="identity")+
    scale_fill_gradient(high=muted("red"),
                        low="gray")+
    scale_y_continuous(breaks=c(0,2e6,4e6,6e6),
                       labels=c(TeX("$ \\0.0 \\times 10^{6}$"),
                                TeX("$ \\2.0 \\times 10^{6}$"),
                                TeX("$ \\4.0 \\times 10^{6}$"),
                                TeX("$ \\6.0 \\times 10^{6}$")))+
    theme_classic()+
    theme(legend.position="None",
          axis.title=element_blank(),
          axis.text.x=element_text(size=10,angle=45,
                                   vjust=1,hjust=0.9),
          axis.text.y=element_text(size=10,vjust=-0.1))
  tmp3=rbind(tmp2[1:5,],data.frame(ID="其他",y=sum(data2$y[!data2$ID%in%tmp2$ID[1:5]],na.rm=T)))
  tmp3$ID=factor(tmp3$ID,levels=tmp3$ID[6:1])
  tmp3$y2=(c(0,cumsum(tmp3$y)[-6])+cumsum(tmp3$y))/2
  tmp3$y3=paste(round(tmp3$y/sum(tmp3$y)*100,0),"%",sep="")
  ph3=ggplot(tmp3)+
    geom_bar(aes(x=factor(1),y=y,fill=ID),
             stat="identity",position="stack",width=0.7)+
    geom_text(aes(x=factor(1),y=y2,label=ID),
              size=3.5,nudge_x=0.5)+
    geom_text(aes(x=factor(1),y=y2,label=y3),
              size=3,nudge_x=0.25)+
    scale_fill_brewer(palette="Reds")+
    coord_polar(theta="y")+
    theme_classic()+
    theme(legend.position="None",
          axis.title=element_blank(),
          axis.text=element_blank(),
          axis.ticks=element_blank(),
          axis.line=element_blank())
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(2,10)))
  vplayout <- function(x,y){
    viewport(layout.pos.row = x, layout.pos.col=y)
  }
  print(ph1, vp = vplayout(1:2,1:6))
  print(ph3, vp = vplayout(1,7:10))
  print(ph2, vp = vplayout(2,7:10))
}

pfun2=function(data1,data2,year){
  yr=paste("X",year,sep="")
  tmp=data1[,c(1:8)]
  tmp$fill=data1[,yr]
  ph1=ggplot(tmp,aes(x=long, y=lat,group=group,fill=fill))+
    scale_fill_gradient(high=muted("red"),
                        low="gray")+
    geom_polygon()+
    theme_classic()+
    theme(legend.title=element_blank(),
          legend.position=c(0.55,0.1),
          legend.text=element_text(size=10,angle=20,vjust=-3),
          legend.direction="horizontal",
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

pfun3=function(data1,data2,year){
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

pfun=function(fill,year){
  if(fill=="二氧化碳排放总量"){
    pfun1(totb,tot,year)
  }
  if(fill=="每GDP二氧化碳排放量"){
    pfun2(pgb,pg,year)
  }
  if(fill=="人均二氧化碳排放量"){
    pfun3(pcb,pc,year)
  }
}

shinyServer(function(input,output){
  output$plot=renderPlot(pfun(input$fill,input$year))
})