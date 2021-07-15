#' Create a stacked bar plot of multiple runs
#'
#' This function loads multiple ViruScreen output file as a dataframe and
#' creates a stacked bar plot
#'
#'
#' @param csv_file Path to the input folder
#' @import ggplot2
#' @import RColorBrewer
#' @export

compare_runs <- function(csv_folder){

  # create a dataset
  filenames <- list.files(csv_folder, pattern="*.csv", full.names=TRUE)

  for (file in filenames){
    run = unlist(strsplit(basename(file), ".csv"))[1]

    # if the merged dataset doesn't exist, create it
    if (!exists("dataset")){
      dataset <- read.csv(file, header=TRUE)
      dataset['run']=run
    }

    # if the merged dataset does exist, append to it
    if (exists("dataset")){
      temp_dataset <-read.csv(file, header=TRUE)
      temp_dataset['run']=run
      dataset<-rbind(dataset, temp_dataset)
      rm(temp_dataset)
    }
  }

  # Stacked + percent
  nb.species <- length(unique(dataset$species))
  mycolors <- colorRampPalette(brewer.pal(12, "Paired"))(nb.species)
  ggplot(dataset, aes(fill=species, y=Total_reads, x=run)) +
    geom_bar(position="fill", stat="identity") +
    scale_fill_manual(values = mycolors) +
    theme(axis.text.x = element_text(angle = 90)) +
    scale_y_continuous(labels = scales::percent_format(accuracy = 1))
}
