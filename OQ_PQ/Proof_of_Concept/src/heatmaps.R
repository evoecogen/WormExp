### Source files
source("./convenience.R")

### Libraries
library("tidyverse")
library("ggplot2")
library("UpSetR")
library("ComplexHeatmap")
library("circlize")

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
col_fun = colorRamp2(c(0, 50, 100), c("white", "orange", "red"))
lgd <- Legend(col_fun = col_fun, title = "Overlapped Genes [%]")

plots <- list()
title_list <- names(cross_prod)

for (i in 1:length(cross_prod)) {
  
  # uncomment when no clustering is wanted
  row_col_order <- data_list[[i]] %>% 
    arrange(FDR, decreasing = FALSE) %>% 
    slice(1:30) %>% 
    select(Term) %>% 
    unlist() %>% 
    as.character()
  
  # save as jpeg
 #  png(file = paste0("../Zarate-Potes/heatmaps/", "sorted_", title_list[i], ".png"))
  

    plots[[i]] <- Heatmap(cross_prod[[i]], 
                          col = col_fun,
                          cluster_rows = FALSE, # set true when clustering
                          cluster_columns = FALSE, # set true when clustering
                          row_dend_reorder = FALSE, # set true when clustering
                          row_order = row_col_order,  # remove for clustering
                          column_order = row_col_order, # remove for clustering
                          column_names_gp = gpar(fontsize = 8),
                          row_names_gp = gpar(fontsize = 8),
                          column_title = paste("Gene Overlap in", title_list[i], sep = " ", collapse = NULL),
                          heatmap_legend_param = list(
                            title = "Overlapped Genes [%]", 
                            at = c(0, 50, 100), 
                            labels = c("0", "50", "100"),
                            color_bar = "continuous")
  )
}

plots[[20]]
