library(Seurat)
setwd("~/data/CaiT/sRNA/PSCSR-seq/R/")
load("PBMCs_miRNA.dat")

data<-read.table("../database//human.srna.cpm.robust.txt", header = T, as.is = T)
#data<-read.table("~/data/CaiT/sRNA/human.srna.cpm.txt", header = T, as.is = T)
data[1:5,1:5]
dim(data)

cells.mean<-AverageExpression(cells, use.counts = T)
data2<-data.frame(cells.mean$RNA[,1])
data2$V2 <- rownames(cells.mean$RNA)
data2[1:5,]
dim(data2)
t=merge(data,data2, by.x = "miRNA", by.y = "V2")
dim(t)
t[1:5,  1:5]

spearman.cor<-cor(t[,2:400], t[,401], method = "spearman")
infor<-read.table("../database//human.srna.samples.tsv", header = T, as.is = T, sep = "\t", quote = "\"" )
samplename <-read.table("../database/human.srna.samples.tsv", header = T, sep = "\t", as.is = T,quote = "\"" )
n<-samplename$description
names(n)<-samplename$name
spearman.cor.info<-data.frame(value=spearman.cor[,1], desc=n[names(spearman.cor[,1])])
spearman.cor.info[order(spearman.cor.info$value,decreasing = T)[1:10],]
#write.table(spearman.cor.info, file = "PBMC.cor.txt",quote = F,sep = "\t")
library(gage)
cellgs<- readList("~/data/CaiT/sRNA/human.srna.cellontology.gmt")
p<- gage(spearman.cor, gsets = cellgs, ref = NULL, samp = NULL, set.size = c(3,500))

library(car)
qqPlot(p$greater[, "stat.mean"], id = T, ylab = "t-stat")
p$greater[1:10,]

