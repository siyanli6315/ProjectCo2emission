#本代码绘制了文中的图3到图5
library(ggplot2)
library(showtext)
library(scales)
library("latex2exp")
library(plyr)
library(reshape2)
library(grid)
library(grDevices)
showtext.auto(enable=T)
setwd("~/Documents/作业/数据可视化作业/第三次作业2/中间数据/")

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

setwd("~/Documents/作业/数据可视化作业/第三次作业2/")

pdf("图3.pdf",width = 5,height = 8)
print(pfun("二氧化碳排放总量"))
dev.off()

pdf("图4.pdf",width = 5,height = 8)
print(pfun("每GDP二氧化碳排放量"))
dev.off()

pdf("图5.pdf",width = 5,height = 8)
print(pfun("人均二氧化碳排放量"))
dev.off()

pdf("图345合并.pdf",width = 15, height = 8)
grid.newpage()
pushViewport(viewport(layout = grid.layout(1,3)))
vplayout <- function(x,y){
  viewport(layout.pos.row = x, layout.pos.col=y)
}
print(pfun("二氧化碳排放总量"), vp = vplayout(1,1))
print(pfun("每GDP二氧化碳排放量"), vp = vplayout(1,2))
print(pfun("人均二氧化碳排放量"), vp = vplayout(1,3))
dev.off()
