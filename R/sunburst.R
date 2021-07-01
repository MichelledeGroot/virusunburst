#' Create a sunburst
#'
#' This function loads a ViruScreen output file as a dataframe and creates a sunburst of the
#' taxonomy and total reads
#'
#' @param csv_file Path to the input file
#' @import plotme
#' @import dplyr
#' @export
make_sunburst <- function(csv_file, size_col){
  full_taxonomy <- read.csv(csv_file
                            ,header=T
                            ,stringsAsFactors = FALSE
  )

  full_taxonomy = full_taxonomy[order(full_taxonomy[,'species'],-full_taxonomy[,'Total_reads']),]
  full_taxonomy = full_taxonomy[!duplicated(full_taxonomy$species),]

  full_taxonomy %>%
    count(family, genus, species, wt = eval(as.name(size_col))) %>%
    count_to_sunburst(fill_by_n = TRUE)

}

