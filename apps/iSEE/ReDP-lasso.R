library(rprojroot)
root <- find_root_file(criterion=criteria$is_git_root)
sce <- readRDS(file.path(root, "data/allen.rds"))

library(iSEE)

# Preconfigure the sender panel, including the point selection
rdArgs <- ReducedDimensionPlot(
    PanelWidth=6L,
    BrushData=list(
        lasso = NULL, closed = TRUE, panelvar1 = NULL, panelvar2 = NULL, mapping = list(
            x = "X", y = "Y"), coord = structure(c(9.7, 4.0, 2.0, 
            8.2, 10.5, 9.7, 9.0, 12.8, 7.9, 0.9, 2.1, 9.0), .Dim = c(6L, 
            2L)
        )
    )
)

app <- iSEE(sce, initial=list(cdArgs, rdArgs))
