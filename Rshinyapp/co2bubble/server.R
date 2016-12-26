library(shiny)
library(ggplot2)
library(showtext)
library(scales)
library("latex2exp")
library(plyr)
library(reshape2)
showtext.auto(enable=T)

all1=read.csv("all1.csv",header = T)

pfun=function(year,dat){
  options(warn=-1)
  year=paste("X",year,sep="")
  co2pc=dat[,year][dat$fill=="人均二氧化碳排放量"]
  co2pg=dat[,year][dat$fill=="每GDP二氧化碳排放量"]
  co2tot=dat[,year][dat$fill=="二氧化碳排放总量"]
  tmp=data.frame(co2pc,co2pg,co2tot,con=dat$Country.name[1:218],region=dat$region2[1:218])
  tmp$region2=as.character(tmp$region)
  tmp$region2[tmp$region%in%c("拉丁美洲和加勒比海地区","南亚","撒哈拉以南非洲","中东和北非")]="拉美.南亚.中东和非洲"
  tmp$region2[!tmp$region%in%c("拉丁美洲和加勒比海地区","南亚","撒哈拉以南非洲")]="北美.东亚.大洋洲和欧洲"
  ph=ggplot(data=tmp)+
    geom_point(aes(x=co2pc,y=co2pg,size=co2tot,color=region2),alpha=0.7)+
    labs(x="人均二氧化碳排放量",y="每GDP二氧化碳排放量",size="排放总量",color="地区")+
    geom_hline(aes(yintercept=median(co2pg,na.rm=T)),
               linetype=2,color="darkred",size=1)+
    geom_vline(aes(xintercept=median(co2pc,na.rm=T)),
               linetype=2,color="darkred",size=1)+
    annotate("text",
             x=30,
             y=median(tmp$co2pg,na.rm=T),
             label=paste("中位数",round(median(tmp$co2pg,na.rm=T),1)),
             hjust=1,vjust=1.5,size=5)+
    annotate("text",
             y=1500,
             x=median(tmp$co2pc,na.rm=T),
             label=paste("中位数",round(median(tmp$co2pc,na.rm=T),1)),
             hjust=0,vjust=1.5,size=5)+
    geom_text(data=tmp[order(tmp$co2tot,decreasing=T)[1:5],],
              aes(x=co2pc,y=co2pg,label=con),size=4,vjust=-1)+
    scale_size_continuous(range=c(1,10),
                          breaks=c(2e6,4e6,6e6),
                          labels=c(TeX("$ \\2.0 \\times 10^{6}$"),
                                   TeX("$ \\4.0 \\times 10^{6}$"),
                                   TeX("$ \\6.0 \\times 10^{6}$")))+
    scale_x_continuous(limits=c(0,30))+
    scale_y_continuous(limits=c(0,1500))+
    scale_color_manual(values=c(muted("red"),"darkblue"))+
    theme_classic()+
    theme(axis.title=element_text(size=18),
          axis.text=element_text(size=10),
          legend.text=element_text(size=10),
          legend.title=element_text(size=18))
  print(ph)
}

shinyServer(function(input,output){
  output$plot=renderPlot(pfun(input$year,all1))
})