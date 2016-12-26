#数据预处理部分
setwd("~/Documents/作业/数据可视化作业/第三次作业2/原始数据")
#读取原始数据并删除多余的列
pc=read.csv("percapita.csv",header=T,sep=",")
pc=pc[,-c(3,4,5,6,26:28)]
pg=read.csv("pergdp.csv",header=T,sep=",")
pg=pg[,-c(3,4,5,6,26:28)]
tot=read.csv("total.csv",header=T,sep=",")
tot=tot[,-c(3,4,5,6,26:28)]
con=read.csv("country.csv",header=T,sep=",")

#将地区改成中文,将原始数据和国家信息数据连接起来，删除多余的行和列
library(plyr)
con$region2=con$Region
levels(con$region2)
levels(con$region2)=c("东亚和太平洋","欧洲和中亚","拉美和加勒比海","中东和北非","北美","南亚","撒哈拉以南非洲")
pc1=join(pc,con,by="Country.code",type="left")
pg1=join(pg,con,by="Country.code",type="left")
tot1=join(tot,con,by="Country.code",type="left")
pc1=pc1[!is.na(pc1$region2),]
pg1=pg1[!is.na(pg1$region2),]
tot1=tot1[!is.na(tot1$region2),]
pc1=pc1[,-c(22:26)]
pg1=pg1[,-c(22:26)]
tot1=tot1[,-c(22:26)]
write.csv(pc1,file='~/Documents/作业/数据可视化作业/第三次作业2/中间数据/pc1.csv',row.names = F)
write.csv(pg1,file='~/Documents/作业/数据可视化作业/第三次作业2/中间数据/pg1.csv',row.names = F)
write.csv(tot1,file='~/Documents/作业/数据可视化作业/第三次作业2/中间数据/tot1.csv',row.names = F)

#找出全球汇总数据和六区域（East Asia & Pacific、Europe & Central Asia、Latin America & Caribbean、Middle East & North Africa、North America、South Asia、Sub-Saharan Africa ）的汇总数据
#需要注意的是，汇总数据中没有北美的数据，所以北美数据是手工计算的。计算方法：二氧化碳排放总量数据求和，人均二氧化碳排放量和每GDP二氧化碳排放量数据平均。
region=c("World",levels(con$Region))
pg_region=pg[pg$Country.name%in%region,]
pc_region=pc[pc$Country.name%in%region,]
tot_region=tot[tot$Country.name%in%region,]
pg_region[8,]=c(NA,NA,colMeans(as.matrix(pg1[pg1$region2=="北美",][,3:21]),na.rm=T))
pc_region[8,]=c(NA,NA,colMeans(as.matrix(pc1[pc1$region2=="北美",][,3:21]),na.rm=T))
tot_region[8,]=c(NA,NA,colMeans(as.matrix(tot1[tot1$region2=="北美",][,3:21]),na.rm=T))
pg_region$Country.name=c("东亚和太平洋","欧洲和中亚","拉美和加勒比海","中东和北非","南亚","撒哈拉以南非洲","全球","北美")
pc_region$Country.name=c("东亚和太平洋","欧洲和中亚","拉美和加勒比海","中东和北非","南亚","撒哈拉以南非洲","全球","北美")
tot_region$Country.name=c("东亚和太平洋","欧洲和中亚","拉美和加勒比海","中东和北非","南亚","撒哈拉以南非洲","全球","北美")
write.csv(pg_region,"~/Documents/作业/数据可视化作业/第三次作业2/中间数据/pg_region.csv",row.names = F)
write.csv(pc_region,"~/Documents/作业/数据可视化作业/第三次作业2/中间数据/pc_region.csv",row.names = F)
write.csv(tot_region,"~/Documents/作业/数据可视化作业/第三次作业2/中间数据/tot_region.csv",row.names = F)
