setwd("~/data/CaiT/sRNA/PSCSR-seq/R/")
infor<-read.table("~/data/CaiT/sRNA/cell_line/A549_2/new/stat_reads.txt", header = F, as.is = T, sep = "\t")
barcodes<-read.table("ICELL8_barcodes.txt", header = F, as.is = T)

#10X genomics criteria, expected cell 1173
n_cells <- 1173
totals <- infor[,5]
names(totals)<-infor[,1]
totals <- sort(totals, decreasing = TRUE)
thresh = totals[round(0.01*n_cells)]/10

plot(totals, pch=20, col="grey", xlab = "Barcodes", ylab = "Raw nUMI")
abline(v=sum(infor[,5]> thresh), col="red", lwd=2)
points(which(names(totals) %in% barcodes[,1]),totals[names(totals) %in% barcodes[,1]], pch=20)
legend(3000, 30000, legend = c("A549 Cells","Background"), pch=20, col=c("black", "grey"))

data<- read.table("~/data/CaiT/sRNA/cell_line/A549_2/new/ncRNA.count", header = T, sep = "\t", as.is = T)
print(data[1:3,])
library(reshape2)
count<- acast(data, gene~cell, value.var = "count")
dim(count)
countnew<-count
countnew[is.na(countnew)]<-0
countnew[1:5,1:5]

inx<-(colnames(countnew) %in% barcodes[,1] )&(colnames(countnew) %in% infor[,1][infor[,5]> thresh])
#inx<-(colnames(countnew) %in% incode[,1] )
sum(inx)
countnew<-countnew[,inx]
dim(countnew)
#write.csv(countnew, quote = F, file = "counts.csv")

#saturation analysis
infor2<-infor[infor$V1 %in% colnames(countnew),]
#summary of mapped reads
summary(infor2[,4])

saturation<-mean(1-(infor2[,5]/infor2[,4]))
print(saturation)

#
library(Seurat)
#cells<-CreateSeuratObject(countnew, min.cells = 20, min.genes = 200, project = "SCSR")
cells<-CreateSeuratObject(countnew,  project = "A549")
cells

data<-GetAssayData(object = cells, slot = "counts")
miRNA.genes <- grep("pre", rownames(data), value = T)
miRNA <- Matrix::colSums(data[miRNA.genes, ])/Matrix::colSums(data)

nmiRNA<- apply(data[miRNA.genes, ], 2, function(x){sum(x>0)})

rRNA.genes <- grep("rRNA", rownames(data), value = T)
rRNA <- Matrix::colSums(data[rRNA.genes, ])/Matrix::colSums(data)

snRNA.genes <- grep("snRNA", rownames(data), value = T)
snRNA <- Matrix::colSums(data[snRNA.genes, ])/Matrix::colSums(data)

snoRNA.genes <- grep("snoRNA", rownames(data), value = T)
snoRNA <- Matrix::colSums((data[snoRNA.genes, ]))/Matrix::colSums((data))


tRNA.genes <- grep("tRNA", rownames(data), value = T)
tRNA <- Matrix::colSums((data[tRNA.genes, ]))/Matrix::colSums((data))


protein <- ((data["protein", ]))/Matrix::colSums((data))

cells <- AddMetaData(cells, miRNA, "miRNA")
cells <- AddMetaData(cells, nmiRNA, "nmiRNA")

cells <- AddMetaData(cells, tRNA, "tRNA")
cells <- AddMetaData(cells, rRNA, "rRNA")
cells <- AddMetaData(cells, snRNA, "snRNA")
cells <- AddMetaData(cells, snoRNA, "snoRNA")
cells <- AddMetaData(cells, protein, "protein")

#write.table(rowMeans(as.matrix(data)), file="data_mean.txt", quote = F)

VlnPlot(cells, c("nCount_RNA", "nmiRNA", "nFeature_RNA") )
lapply(split(cells@meta.data$nCount_RNA, cells@meta.data$orig.ident ), mean)

VlnPlot(cells, c( "miRNA", "tRNA" , "rRNA","snRNA", "snoRNA","protein"))
#cells <- subset(x = cells, subset = rRNA <0.5  )

cells <- NormalizeData(object = cells, normalization.method = "LogNormalize",scale.factor = 10000)
cells <- FindVariableFeatures(object = cells, selection.method = "mean.var.plot",mean.cutoff = c(0.00125, Inf), dispersion.cutoff = c(0.1, Inf))
VariableFeaturePlot(object = cells)
length(x = VariableFeatures(object = cells))
cells <- ScaleData(object = cells, features = VariableFeatures(object = cells), vars.to.regress = c("nCount_RNA"))
cells <- RunPCA(object = cells, features = VariableFeatures(object = cells))

ElbowPlot(object = cells,ndims = 50)
cells <- RunTSNE(object = cells, dims = 1:50)
DimPlot(object = cells, reduction = "tsne", pt.size = 2)

cells <- FindNeighbors(object = cells, dims = 1:50)
cells <- FindClusters(object = cells, resolution =seq(0.1,1, 0.1))

Idents(object = cells)<-'RNA_snn_res.0.5'
DimPlot(object = cells, reduction = "tsne",label = T, pt.size = 2)

cells.markers <- FindAllMarkers(object = cells, only.pos = TRUE, min.pct = 0.5, logfc.threshold = 0.2)
Idents(object = cells)<-'orig.ident'
save(cells, file = "A549.dat")


#filter miRNA and calculate the top miRNAs
data.mean<-AverageExpression(cells, use.counts = T)

a549_pre<-data.mean$RNA[miRNA.genes,"A549"]
names(a549_pre)<-miRNA.genes
a549_pre<-sort(a549_pre, decreasing = T)
a549_pre[1:10]

cumsum(a549_pre[1:10])/sum(a549_pre)

#compare with cell altas
data<-read.table("../database/cell_atlas_s9.txt", header = T, as.is = T)
data[1:5,]
dim(data)
group<-data[,1]
m1<-matrix(0, nrow = length(unique(group)), ncol = 172)
colnames(m1)<-colnames(data)[2:173]
for(i in 2:173) {
  print(i-1)
  m1[,i-1]<-unlist(lapply(split(data[,i], group), sum))
}
rownames(m1)<-names(unlist(lapply(split(data[,i], group), sum)))
m1[1:5,1:5]
data1<-data.frame(m1)
data1$V1<-rownames(data1)

data.mean<-AverageExpression(cells)
data2<-data.mean$RNA[,1]
data2<-data.frame(data2)
data2$V2 <- rownames(data.mean$RNA)
#data1[1:5,]
data2[1:5,]
t=merge(data1,data2, by.x = "V1", by.y = "V2")
dim(t)
t[1:5,  1:5]
spearman.cor<-cor(t[,2:173], t[,174], method = "spearman")
sort(spearman.cor[,1], decreasing = F)
