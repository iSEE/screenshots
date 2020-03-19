library(rprojroot)
root <- find_root_file(criterion=criteria$is_git_root)
sce <- readRDS(file.path(root, "data/allen.rds"))

library(iSEE)
app <- iSEE(sce, initial=list(
    ReducedDimensionPlot(DataBoxOpen=TRUE, Type="TSNE", 
        XAxis=2L, YAxis=1L, PanelWidth=6L)
))
