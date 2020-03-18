# This is obtained pretty much verbatim from the iSEE vignette.

library(scRNAseq)
sce <- ReprocessedAllenData(assays = "tophat_counts") 

library(scater)
sce <- logNormCounts(sce, exprs_values="tophat_counts")

sce <- runPCA(sce)
sce <- runTSNE(sce)
reducedDimNames(sce)

rowData(sce)$mean_log <- rowMeans(logcounts(sce))
rowData(sce)$var_log <- apply(logcounts(sce), 1, var)

saveRDS(sce, file="allen.rds")
