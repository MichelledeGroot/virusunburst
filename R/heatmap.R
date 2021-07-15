#' Create a heatmap
#'
#' This function loads a ViruScreen output file as a dataframe and creates a heatmap
#'  of all columns
#'
#' @param csv_file Path to the input file
#' @import tidyverse
#' @import d3heatmap
#' @export
make_heatmap <- function(csv_file){
  full_taxonomy <- read.csv(csv_file
                            ,header=T
                            ,stringsAsFactors = FALSE
  )

  full_taxonomy = full_taxonomy[order(full_taxonomy[,'species'],-full_taxonomy[,'Total_reads']),]
  full_taxonomy = full_taxonomy[!duplicated(full_taxonomy$species),]
  full_taxonomy = subset(full_taxonomy, select = -c(Ref_GC) )

  row.names(full_taxonomy) <- full_taxonomy$species
  suppressWarnings(d3heatmap(full_taxonomy, scale = "column", col = 'YlOrRd',
                             main = "Heatmap of all species' details", dendrogram = "none") %>%
                     hmAxis("y", title = "species", location = 'right', font.size = 8) %>%
                     hmAxis("x", title = "columns", location = 'bottom', font.size = 12) %>%
                     hmCells(font.size = 8, color = 'blue') %>%
                     hmLegend(show = T, title = "Legend", location = "tl"))
}
