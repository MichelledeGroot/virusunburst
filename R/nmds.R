#' Create a NMDS plot
#'
#' This function loads multiple ViruScreen output file as a dataframe and
#' creates a NMDS plot
#'
#' This method is currently not exported. uncomment export to enable.
#'
#' @param csv_file Path to the input file
#' @import vegan
#' @import dplyr
#' @import ggplot2
# @export
make_nmds <- function(csv_folder,show_species=FALSE){
  filenames <- list.files(csv_folder, pattern="*.csv", full.names=TRUE)

  for (file in filenames){
    run = unlist(strsplit(basename(file), ".csv"))[1]

    # if the merged dataset doesn't exist, create it
    if (!exists("dataset")){
      dataset <- read.csv(file, header=TRUE)
      dataset['run']=run
      dataset = subset(dataset, select = -c(Ref_GC,Minus_reads,Plus_reads,Median_fold,X.ID,family,genus,species) )
    }

    # if the merged dataset does exist, append to it
    if (exists("dataset")){
      temp_dataset <-read.csv(file, header=TRUE)
      temp_dataset['run']=run
      temp_dataset = subset(temp_dataset, select = -c(Ref_GC,Minus_reads,Plus_reads,Median_fold,X.ID,family,genus,species) )
      dataset<-rbind(dataset, temp_dataset)
      rm(temp_dataset)
    }
  }

  #make community matrix - extract columns with abundance information
  dune = subset(dataset, select = c(Avg_fold, Length, Covered_percent, Covered_bases,
                                    Read_GC, Std_Dev, Total_reads) )
  dune.env = dataset$run
  #turn abundance data frame into a matrix
  dune = as.matrix(dune)
  set.seed(123)
  nmds = metaMDS(dune, distance = "bray")
  en = envfit(nmds, dataset, permutations = 999, na.rm = TRUE)

  data.scores = as.data.frame(scores(nmds))
  data.scores$run = dataset$run
  en_coord_cont = as.data.frame(scores(en, "vectors")) * ordiArrowMul(en)
  en_coord_cat = as.data.frame(scores(en, "factors")) * ordiArrowMul(en)

  if (show_species){
  gg = ggplot(data = data.scores, aes(x = NMDS1, y = NMDS2)) +
    geom_point(data = data.scores, aes(colour = run), size = 3, alpha = 0.5) +
    #scale_colour_manual(values = c("orange", "steelblue"))  +
    geom_segment(aes(x = 0, y = 0, xend = NMDS1, yend = NMDS2),
                 data = en_coord_cont, size =1, alpha = 0.5, colour = "grey30") +
    geom_point(data = en_coord_cat, aes(x = NMDS1, y = NMDS2),
               shape = "diamond", size = 4, alpha = 0.6, colour = "navy") +
    geom_text(data = en_coord_cat, aes(x = NMDS1, y = NMDS2+0.01),
              label = row.names(en_coord_cat), colour = "navy", fontface = "bold") +
    geom_text(data = en_coord_cont, aes(x = NMDS1, y = NMDS2), colour = "grey30",
              fontface = "bold", label = row.names(en_coord_cont)) +
    theme(axis.title = element_text(size = 10, face = "bold", colour = "grey30"),
          panel.background = element_blank(), panel.border = element_rect(fill = NA, colour = "grey30"),
          axis.ticks = element_blank(), axis.text = element_blank(), legend.key = element_blank(),
          legend.title = element_text(size = 10, face = "bold", colour = "grey30"),
          legend.text = element_text(size = 9, colour = "grey30")) +
    labs(colour = "run")
  }
  else {
    gg = ggplot(data = data.scores, aes(x = NMDS1, y = NMDS2)) +
      geom_point(data = en_coord_cat, aes(x = NMDS1, y = NMDS2),
                 shape = "diamond", size = 4, alpha = 0.6, colour = "navy") +
      geom_text(data = en_coord_cat, aes(x = NMDS1, y = NMDS2+0.01),
                label = row.names(en_coord_cat), colour = "navy", fontface = "bold") +
      theme(axis.title = element_text(size = 10, face = "bold", colour = "grey30"),
            panel.background = element_blank(), panel.border = element_rect(fill = NA, colour = "grey30"),
            axis.ticks = element_blank(), axis.text = element_blank(), legend.key = element_blank(),
            legend.title = element_text(size = 10, face = "bold", colour = "grey30"),
            legend.text = element_text(size = 9, colour = "grey30")) +
      labs(colour = "run")
  }
  gg
}
