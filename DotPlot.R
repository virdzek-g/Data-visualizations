library(Seurat)
DotPlot(seu, features=genes,dot.scale =6, group.by='cell_type')+ theme(axis.text.x = element_text(angle = 90))+ scale_colour_gradient2(low = "#398CB3", mid = "#C9D9E0", high = "#C21212")
