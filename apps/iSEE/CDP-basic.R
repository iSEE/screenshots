library(rprojroot)
root <- find_root_file(criterion=criteria$is_git_root)
sce <- readRDS(file.path(root, "data/allen.rds"))

library(iSEE)
app <- iSEE(sce, initial=list(
    ColumnDataPlot(YAxis="NREADS", PanelWidth=6L, DataBoxOpen=TRUE),
    ColumnDataPlot(YAxis="TOTAL_DUP", PanelWidth=6L, DataBoxOpen=TRUE)
))
