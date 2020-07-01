library(dplyr)
library(Seurat)
setwd("~/data/CaiT/PBMC/2019_3_12/")
pbmc.data <- Read10X(data.dir = "PBMC/outs/filtered_feature_bc_matrix/")
pbmc <- CreateSeuratObject(counts = pbmc.data, min.cells = 3, min.features = 200,project = "10X_PBMC")
pbmc
mito.features <- grep(pattern = "^MT-", x = rownames(x = pbmc), value = TRUE)
percent.mito <- Matrix::colSums(x = GetAssayData(object = pbmc, slot = "counts")[mito.features,])/Matrix::colSums(x = GetAssayData(object = pbmc, slot = "counts"))
pbmc[["percent.mito"]] <- percent.mito
VlnPlot(object = pbmc, features = c("nFeature_RNA", "nCount_RNA", "percent.mito"),ncol = 3)
pbmc <- subset(x = pbmc, subset = nFeature_RNA > 200 & nFeature_RNA < 2000 & percent.mito < 0.05)
pbmc <- NormalizeData(object = pbmc, normalization.method = "LogNormalize",scale.factor = 10000)
#pbmc <- FindVariableFeatures(object = pbmc, selection.method = "mean.var.plot",mean.cutoff = c(0.0125, 4), dispersion.cutoff = c(0.5, Inf))
#test VST 
pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures = 2000)
VariableFeaturePlot(object = pbmc)
pbmc <- ScaleData(pbmc)
pbmc <- RunPCA(object = pbmc, features = VariableFeatures(object = pbmc))
#pbmc <- JackStraw(pbmc, num.replicate = 100)
#pbmc <- ScoreJackStraw(pbmc, dims = 1:20)
#JackStrawPlot(pbmc, dims = 1:15)

pbmc <- FindNeighbors(object = pbmc, dims = 1:10)
pbmc <- FindClusters(object = pbmc, resolution =seq(0.1,2, 0.2))
pbmc <- RunUMAP(pbmc, dims = 1:10)
Idents(object = pbmc)<-'RNA_snn_res.0.5'
DimPlot(pbmc, reduction = "umap", label = T)

pbmc.markers <- FindAllMarkers(object = pbmc, only.pos = TRUE, min.pct = 0.5)
pbmc.markers %>% group_by(cluster) %>% top_n(n = 2, wt = avg_logFC)
#write.csv(pbmc.markers,file = "pbmc_markers.csv")
FeaturePlot(pbmc, c("CD3D", "IL7R", "CD8B", "GNLY" ))
FeaturePlot(pbmc, c( "NKG7","MS4A1", "S100A8", "LYZ"))
FeaturePlot(pbmc, c("S100A8", "S100A9", "LYZ", "CD19"))
new.cluster.ids <- c("CD4 Tcells", "CD4 Tcells", "CD8 Tcells","NK cells", "CD8 Tcells", "CD8 Tcells","B cells", "Myeloid cells")
names(x = new.cluster.ids) <- levels(x = pbmc)
pbmc <- RenameIdents(object = pbmc, new.cluster.ids)
DimPlot(object = pbmc, reduction = 'umap', label = TRUE, pt.size = 0.5) + NoLegend()

