library(rprojroot)
root <- find_root_file(criterion=criteria$is_git_root)
sce <- readRDS(file.path(root, "data/allen.rds"))

library(iSEE)

# Preconfigure the receiver panel
cdArgs <- ColumnDataPlot(SelectionBoxOpen=TRUE, 
    ColumnSelectionSource="ReducedDimensionPlot1",
    SelectionEffect="Color", SelectionColor="purple", 
    ColorByDefaultColor="#BDB3B3", PanelWidth=6L)

# Preconfigure the sender panel, including the point selection
rdArgs <- ReducedDimensionPlot(
    BrushData=list(
        xmin = 2.8, xmax = 10.4, ymin = 0.6, ymax = 13.2, 
        mapping = list(x = "X", y = "Y"), domain = list(left = -14.0, right = 10.9, 
            bottom = -12.0, top = 16.4), range = list(left = 38.7, 
            right = 541.5, bottom = 466.0, top = 23.7), 
        log = list(x = NULL, y = NULL), direction = "xy", brushId = "redDimPlot1_Brush", 
        outputId = "redDimPlot1"
    ),
    PanelWidth=6L
)    

app <- iSEE(sce, initial=list(cdArgs, rdArgs))
