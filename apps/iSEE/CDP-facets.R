library(rprojroot)
root <- find_root_file(criterion=criteria$is_git_root)
sce <- readRDS(file.path(root, "data/allen.rds"))

library(iSEE)
cdp <- ColumnDataPlot(VisualBoxOpen=TRUE, VisualChoices=c("Facet"),
    FacetByRow="driver_1_s", FacetByColumn="Core.Type", PanelWidth=4L)

cdp2 <- cdp
cdp2[["FacetByRow"]] <- "---"

cdp3 <- cdp
cdp3[["FacetByColumn"]] <- "---"

app <- iSEE(sce, initial=list(cdp, cdp2, cdp3))

