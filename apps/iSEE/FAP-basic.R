library(rprojroot)
root <- find_root_file(criterion=criteria$is_git_root)
sce <- readRDS(file.path(root, "data/allen.rds"))

library(iSEE)
app <- iSEE(sce, initial=list(
    FeatureAssayPlot(PanelWidth=6L),
    FeatureAssayPlot(PanelWidth=6L)
))
