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

  row.names(full_taxonomy) <- full_taxonomy$species
  d3heatmap(full_taxonomy, scale = "column", col = 'RdYlGn',
            main = "Heatmap of all best hits' details", dendrogram = "row") %>%
    hmAxis("y", title = "species", location = 'right', font.size = 10) %>%
    hmAxis("x", title = "columns", location = 'bottom', font.size = 12)

}
