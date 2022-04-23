### Source files
source("./convenience.R")

### Libraries
library("tidyverse")
library("ggplot2")
library("UpSetR")
library("RColorBrewer")

### Import data
data_list <- import(path = "../Zarate-Potes/cluster_sets/wormexp_output", pattern="C\\d*", header = TRUE)


### Heatmap Type 1
temp_cluster <- data_list[["C1_new"]]
chemicals <- subset(temp_cluster, Category == "Chemicals/stress")

# Create Binary
chemicals_binary <- chemicals %>% 
  group_by(Term, OverlappedID) %>% 
  summarise(n = n()) %>%
  spread(OverlappedID, n, fill = 0) %>% 
  column_to_rownames(var="Term")

# Filter
chemicals_binary_filtered <- as.matrix(taxa.filter(chemicals_binary, percent.filter = 0.20, relabund.filter = 0.001))

# Create Heatmap
col_letters = c("0" = "white", "1" = "black", "2" = "red")

Heatmap(chemicals_binary_filtered, 
        col = col_letters,
        cluster_rows = FALSE,
        cluster_columns = FALSE,
        column_names_gp = gpar(fontsize = 8),
        row_names_gp = gpar(fontsize = 5),
        column_title = "Chemicals/stress gene overlaps",
        heatmap_legend_param = list(
          title = "Overlapped Genes", at = c(0, 1, 2), 
          labels = c("0", "1", "2")
        ))




### Heatmap Type 2

# remove all columns besides Category, Term and Overlapped ID
# keep only top 30
cluster_binary <- list()
for (i in 1:length(data_list)) {
  cluster_binary[[i]] <- data_list[[i]] %>% 
    arrange(FDR, decreasing = FALSE) %>% 
    slice(1:30) %>% 
    mutate(OverlappedID = strsplit(as.character(OverlappedID), "[,;]+")) %>%
    unnest(OverlappedID) %>% 
    group_by(Term, OverlappedID) %>% 
    distinct(OverlappedID, .keep_all = TRUE) %>% 
    summarise(n = n()) %>%
    spread(OverlappedID, n, fill = 0) %>% 
    column_to_rownames(var="Term")
}

# make matrix out of binary table and switch terms as column (for crossprod)
cluster_binary <- lapply(cluster_binary, function(x) t(x))

# calculate crossproduct -> how much overlap exists between terms and calculate percentages
cross_prod <- lapply(cluster_binary, function(x) crossprod(x))                         
cross_prod <- lapply(cross_prod, function(x) floor(t(x*100/diag(x))))

# name cross_prod objects
names(cross_prod) <- names(data_list)

# plot
title_list <- names(cross_prod)

for(i in 1:length(cross_prod)){
  
  # save file 
  png(paste("../Zarate-Potes/heatmaps/final", title_list[i], ".png", sep = "_", collapse = NULL), width = 900, height = 900)
  
  # plot file
  heatmap(cross_prod[[i]], 
          Rowv = TRUE, 
          Colv = "Rowv", 
          main = paste("Gene Overlap in", title_list[i], sep = " ", collapse = NULL),
          col = colorRampPalette(brewer.pal(8, "PiYG"))(5),
          cexRow = 1,
          cexCol = 1,
          margins = c(30,30)
  )
  
  legend(x = "topleft", 
         legend = c("0","25","50","75","100"),
         title = "[%] Overlapped Genes",
         fill = colorRampPalette(brewer.pal(8, "PiYG"))(5)
  )
  
  # remove settings
  dev.off()

}


