# Specify sample order
set_order_of_samples <- function(sample_col) {
  sample_order <- c('Sample1')
  return(factor(sample_col, levels = sample_order))
}



# add color columns to the data table based on conditions
add_color_columns <- function(data) {
  data$fill_color <- ifelse(grepl("multi", data$Genes), "#D4AC0D",
                            ifelse(grepl("cfDNA", data$Genes), "transparent",
                                   ifelse(data$Sample == "T", "#E77B7B", "#2980B9")))
  data$border_color <- ifelse(grepl("multi", data$Genes), "transparent",
                              ifelse(grepl("cfDNA", data$Genes), "black",
                                     ifelse(data$Sample == "T", "transparent", "transparent")))
  return(data)
}

plot_gene_vaf_long <- function(table, gene_col, sample_col, vaf_col, dot_size, label_size, line_color = "black") {
  # Convert 'Genes' to factor 
  table[[gene_col]] <- factor(table[[gene_col]], levels = unique(table[[gene_col]]))
  # Reorder the data based on the order of samples
  table[[sample_col]] <- set_order_of_time_points(table[[sample_col]])

  p <- ggplot(table, aes(x = table[[sample_col]], y = factor(table[[gene_col]], levels = unique(table[[gene_col]])))) +
    geom_segment(aes(xend = table[[sample_col]], yend = factor(table[[gene_col]], levels = unique(table[[gene_col]])), color = line_color), size = 1) +
    geom_point(aes(size = table[[vaf_col]], color = border_color, fill = fill_color), 
               shape = 21, stroke = 0.5) +
    scale_size_continuous(range = c(1, 10) * dot_size, 
                         breaks = c(1, 20, 50, 70, 100), 
                         labels = c("1", "20", "50", "70", "100"),
                         guide = guide_legend(title = "VAF")) +
    scale_color_identity() +
    scale_fill_identity() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 0, hjust = 0.5),  #move the labels to the right
          legend.position = "bottom",
          axis.title = element_blank(),
          axis.text = element_text(size = label_size, color = "black"),  #
          strip.text = element_text(size = label_size),
          legend.key = element_rect(fill = "white"),
          legend.background = element_rect(fill = "white"))

  print(p)
}

### data table should contain 3 columns Genes, Sample or Sample and VAF
# Sample and Time point are used interchangeably, depending on what needs to be on x axis

data <- read.delim()
data1 <- add_color_columns(data)
data1$Genes <- sub('.*-','',data1$Genes)


# parameters
gene_col <- "Genes"
sample_col <- "Sample"
vaf_col <- "VAF"
dot_size <- 0.7                    
label_size <- 10                       
line_color <- "black"                   


plot_gene_vaf_long(data1, gene_col, sample_col, vaf_col, dot_size, label_size, line_color)
