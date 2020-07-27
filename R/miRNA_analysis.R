setwd("~/data/CaiT/sRNA/PSCSR-seq/R/")
data<- read.table("~/data/CaiT/sRNA/cell_line/A549_2/new/miRNA.count", header = T, sep = "\t", as.is = T)
print(data[1:3,])
library(reshape2)
count<- acast(data, gene~cell, value.var = "count")
dim(count)
countnew<-count
countnew[is.na(countnew)]<-0
countnew[1:5,1:5]
library(Seurat)
load("A549.dat")
cells2<-cells
#cells<-CreateSeuratObject(countnew, min.cells = 20, min.genes = 200, project = "SCSR")
cells<-CreateSeuratObject(countnew,  project = "A549")
cells
cells <- subset(x = cells, cells=rownames(cells2@meta.data) )
VlnPlot(cells, c("nCount_RNA", "nFeature_RNA") )

cells <- NormalizeData(object = cells, normalization.method = "LogNormalize",scale.factor = 10000)
#cells <- FindVariableFeatures(object = cells, selection.method = "mean.var.plot",mean.cutoff = c(0.00125, Inf), dispersion.cutoff = c(0.1, Inf), num.bin = 5)
cells <- FindVariableFeatures(object = cells, selection.method = "vst", nfeatures=400, num.bin = 10)
VariableFeaturePlot(object = cells)
length(x = VariableFeatures(object = cells))
cells <- ScaleData(object = cells)
cells <- RunPCA(object = cells, features = VariableFeatures(cells) ,npcs = 150)
ElbowPlot(object = cells,ndims = 150)
cells <- RunTSNE(object = cells, dims = 1:50)
DimPlot(object = cells, reduction = "tsne", pt.size = 2)

cells <- FindNeighbors(object = cells, dims = 1:50)
cells <- FindClusters(object = cells, resolution =seq(0.1,2, 0.1))

Idents(object = cells)<-'RNA_snn_res.0.5'
DimPlot(object = cells, reduction = "tsne",label = T)

Idents(object = cells)<-'orig.ident'
save(cells, file = "A549_miRNA.dat")

cells.markers <- FindAllMarkers(object = cells, only.pos = TRUE, min.pct = 0.5, logfc.threshold = 0.2)


#####
#heatmap for the detail relations
data<-GetAssayData(object = cells, slot = "count")
dim(data[VariableFeatures(cells),])
library(pheatmap)
library(RColorBrewer)
m<-as.matrix(data[VariableFeatures(cells),])
pheatmap(m ,clustering_method = "complete", show_colnames = F, fontsize_row = 1)
