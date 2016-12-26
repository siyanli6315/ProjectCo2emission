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

pfun=function(fill){
  options(warn=-1)
  tmp=all_region[!all_region$region=="全球",]
  tmp=tmp[tmp$fill==fill,]
  tmp2=tmp[tmp$year==2008,]
  levels=as.character(tmp2$region[order(tmp2$y,decreasing = T)])
  tmp$region=factor(tmp$region,levels = levels)
  if(fill=="二氧化碳排放总量"){
    ph1=ggplot(data=tmp)+
      geom_bar(aes(x=region,y=y,fill=y),
               stat="identity")+
      labs(x="地区",y=fill)+
      scale_fill_gradient(low="gray",high=muted("red"))+
      scale_y_continuous(breaks=c(0,2.5e6,5e6,7.5e6,1e7),
                         labels=c(TeX("$\\0.0 \\times 10^{6}$"),
                                  TeX("$\\2.5 \\times 10^{6}$"),
                                  TeX("$\\5.0 \\times 10^{6}$"),
                                  TeX("$\\7.5 \\times 10^{6}$"),
                                  TeX("$\\1.0 \\times 10^{7}$")))+
      theme(legend.position = "None",
            axis.title.x=element_text(size=18),
            axis.title.y = element_blank(),
            axis.text.y=element_text(size=10),
            axis.text.x=element_text(size=8,angle=45,
                                     vjust=1,hjust=0.9))+
      coord_flip()+
      facet_wrap(~year,ncol=4)
  }
  
  if(fill!="二氧化碳排放总量"){
    ph1=ggplot(data=tmp)+
      geom_bar(aes(x=region,y=y,fill=y),
               stat="identity")+
      labs(x="地区",y=fill)+
      scale_fill_gradient(low="gray",high=muted("red"))+
      theme(legend.position = "None",
            axis.title.x=element_text(size=18),
            axis.title.y=element_blank(),
            axis.text=element_text(size=10))+
      coord_flip()+
      facet_wrap(~year,ncol=4)
  }
  return(ph1)
}

shinyServer(function(input,output){
  output$plot=renderPlot(pfun(input$fill))
})