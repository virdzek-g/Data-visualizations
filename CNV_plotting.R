source("CNVPlottingLibrary.R")

sample_name <- ""
denoised_copy_ratios_file <- ".denoisedCR.tsv"
allelic_counts_file <- ".hets.tsv"
modeled_segments_file <- ".modelFinal.seg"
output_dir <- ''
output_prefix <- sample_name

contig_names <- as.list(as.character(c(1:22)))
contig_lengths <- as.list(c(
  249250621, 243199373, 198022430, 191154276, 180915260,
  171115067, 159138663, 146364022, 141213431, 135534747,
  135006516, 133851895, 115169878, 107349540, 102531392,
  90354753, 81195210, 78077248, 59128983, 63025520,
  48129895, 51304566, 155270560, 59373566  # X, Y
))
contig_ends <- cumsum(as.numeric(contig_lengths))
contig_starts <- c(0, head(contig_ends, -1))

WriteModeledSegmentsPlot = function(sample_name, allelic_counts_file, denoised_copy_ratios_file, modeled_segments_file, contig_names, contig_lengths, output_dir, output_prefix) {
    modeled_segments_df = ReadTSV(modeled_segments_file)

    plot_file = file.path(output_dir, paste(output_prefix, ".modeled.png", sep=""))
    num_plots = ifelse(all(file.exists(c(denoised_copy_ratios_file, allelic_counts_file))), 2, 1)
    png(plot_file, width = 12, height = 3.5 * num_plots, units = "in", res = 300, bg = "white")

    par(mfrow=c(num_plots, 1), las = 1, cex = 1, cex.lab = 1.2, cex.axis = 1.2)

    if (file.exists(denoised_copy_ratios_file) && denoised_copy_ratios_file!="null") {
        denoised_copy_ratios_df = ReadTSV(denoised_copy_ratios_file)

        #transform to linear copy ratio
        denoised_copy_ratios_df[["COPY_RATIO"]] = 2^denoised_copy_ratios_df[["LOG2_COPY_RATIO"]]

        #determine copy-ratio midpoints
        denoised_copy_ratios_df[["MIDDLE"]] = round((denoised_copy_ratios_df[["START"]] + denoised_copy_ratios_df[["END"]]) / 2)

        SetUpPlot(sample_name, "denoised copy ratio", 0, 4, "contig", contig_names, contig_starts, contig_ends, TRUE)
        PlotCopyRatiosWithModeledSegments(denoised_copy_ratios_df, modeled_segments_df, contig_names, contig_starts)
    }

    if (file.exists(allelic_counts_file) && allelic_counts_file!="null") {
        allelic_counts_df = ReadTSV(allelic_counts_file)

        SetUpPlot(sample_name, "alternate-allele fraction", 0, 1.0, "contig", contig_names, contig_starts, contig_ends, TRUE)
        PlotAlternateAlleleFractionsWithModeledSegments(allelic_counts_df, modeled_segments_df, contig_names, contig_starts)
    }

    dev.off()

    #check for created file and quit with error code if not found
    if (!file.exists(plot_file)) {
        quit(save="no", status=1, runLast=FALSE)
    }
}

WriteModeledSegmentsPlot(
  sample_name,
  allelic_counts_file,
  denoised_copy_ratios_file,
  modeled_segments_file,
  contig_names,
  contig_lengths,
  output_dir,
  output_prefix
)
