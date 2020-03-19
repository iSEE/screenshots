library(rprojroot)
root <- find_root_file(criterion=criteria$is_git_root)
sce <- readRDS(file.path(root, "data/allen.rds"))

library(iSEE)
cdp <- ColumnDataPlot(VisualBoxOpen=TRUE, VisualChoices=c("Color", "Shape"),
    ColorByColumnData="Core.Type", ShapeByColumnData="Core.Type",
    ColorBy="Column data", ShapeBy="Column data")

cdp2 <- cdp
cdp2[["ColorByColumnData"]] <- "TOTAL_DUP"
cdp2[["ShapeByColumnData"]] <- "driver_1_s"

app <- iSEE(sce, initial=list(cdp, cdp2))
