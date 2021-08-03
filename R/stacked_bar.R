#' Create a stacked bar plot of multiple runs
#'
#' This function loads multiple ViruScreen output file as a dataframe and
#' creates a stacked bar plot
#'
#'
#' @param csv_file Path to the input folder
#' @import ggplot2
#' @import RColorBrewer
#' @import reshape2
#' @export

compare_runs <- function(csv_folder, taxon_level="species", size_col="Total_reads", type="value"){
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

    reshaped <- dcast(dataset, run ~ eval(as.name(taxon_level)), value.var=size_col,fun.aggregate = sum)
    nb <- length(unique(dataset[,taxon_level]))
    mycolors <- colorRampPalette(brewer.pal(12, "Paired"))(nb)

    reshape2::melt(reshaped, id.vars='run') %>%
      group_by(run) %>%
      mutate(pct = value / sum(value), pct = as.numeric(scales::percent(pct, accuracy = 0.01,suffix = ""))) %>%
      plot_ly(x = ~run, y = ~eval(as.name(type)), type = 'bar',
              text = ~paste(variable,
                            "<br> Percentage: ",pct, "%",
                            "<br> Total: ", value),
              name = ~variable, textposition = "none", hoverinfo = 'text',
              color = ~variable, colors = mycolors) %>%
      layout(yaxis = list(title = type), barmode = 'stack',
             xaxis = list(tickangle = 45))
}
