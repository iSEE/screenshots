library(rprojroot)
root <- find_root_file(criterion=criteria$is_git_root)
sce <- readRDS(file.path(root, "data/allen.rds"))

library(iSEE)
cdp <- ColumnDataPlot(VisualBoxOpen=TRUE, 
    VisualChoices=c("Color", "Size", "Point", "Text"))

cdp2 <- cdp
cdp2[["ColorByDefaultColor"]] <- "chocolate3"
cdp2[["PointAlpha"]] <- 0.2
cdp2[["PointSize"]] <- 2
cdp2[["Downsample"]] <- TRUE
cdp2[["DownsampleResolution"]] <- 150
cdp2[["FontSize"]] <- 2

app <- iSEE(sce, initial=list(cdp, cdp2))
