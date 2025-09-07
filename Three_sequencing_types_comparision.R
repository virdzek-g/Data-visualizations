library(ggplot2)
library(ggforce)
library(dplyr)

# data frame with columns sample, gene, variable and value
df <- read.delim()

# Constants for plotting
min_radius <- 0.3  # minimum radius for value = 1
max_radius <- 1.0  # max radius for value =100

# scale radius proportionally
scale_radius <- function(x) {
  (x / 100) * (max_radius - min_radius) + min_radius
}

# check if all 3 modalities are present for a given sample and gene
all_modalities_present <- function(sample, gene) {
  modalities <- unique(df[df$sample == sample & df$gene == gene, "variable"])
  all(c("WES_tumor", "WES_ctDNA", "PCP_ctDNA") %in% modalities)
}

# Add columns to indicate if all modalities are present and to set border color
df$all_present <- mapply(all_modalities_present, df$sample, df$gene)
df$border_color <- factor(ifelse(df$all_present, "#A2A1A1", "black"), levels = c("#A2A1A1", "black"))


ggplot(df) +
  # inner segments for WES_tumor, WES_ctDNA, and PCP_ctDNA with proportional scaling
  geom_arc_bar(
    aes(
      x0 = (as.numeric(factor(sample, levels = v_samples)) - 1) * circle_spacing,  
      y0 = (as.numeric(factor(gene, levels = v_genes)) - 1) * circle_spacing,  
      r0 = 0,  
      r = scale_radius(value),  
      start = (as.numeric(factor(variable)) - 1) * arc_part,
      end = as.numeric(factor(variable)) * arc_part,
      fill = ifelse(all_present, "#EFC808", variable),
      color = border_color
    ),
    size = 0.2,  # outline for inner segments
    show.legend = TRUE
  ) +
  # Outer border representing ctDNA (but this is optional and not advised)
  geom_arc(
    data = unique(df[, c("sample", "gene", "ctDNA")]),  # Data for outer circles
    aes(
      x0 = (as.numeric(factor(sample, levels = v_samples)) - 1) * circle_spacing,  
      y0 = (as.numeric(factor(gene, levels = v_genes)) - 1) * circle_spacing,  
      r = scale_radius(ctDNA),  #outer radius based on ctDNA
      start = 0,
      end = tau
    ),
    color = "black",  
    size = 0.2  
  ) +
  scale_fill_manual(values = c("WES_tumor" = "#E74C3C", "WES_ctDNA" = "#37BB6E", "PCP_ctDNA" = "#2980B9", "#EFC808" = "#A2A1A1")) +
  scale_color_manual(values = c("#A2A1A1" = "#A2A1A1", "black" = "black")) +
  theme_minimal() + 
  labs(
    x = "Samples",
    y = "Genes",
    title = "Segmented Circles with Custom Size Scaling",
    fill = "Variable"
  ) +
  scale_x_continuous(
    breaks = (seq_along(v_samples) - 1) * circle_spacing,
    labels = v_samples,
    name = "Samples"
  ) +
  scale_y_continuous(
    breaks = (seq_along(v_genes) - 1) * circle_spacing,
    labels = v_genes,
    name = "Genes"
  ) +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, size = 14), #8
    axis.text.y = element_text(size = 14),  
    panel.grid.minor = element_blank(),  
    panel.grid.major = element_line(color = "gray", size = 0.35)  
  )
ggsave(plot, 
        filename = "",
        device = "png",
        height = 5, width = 9, units = "in")
