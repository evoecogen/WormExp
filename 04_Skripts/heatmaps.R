#########################################
#                                       #
#   IMPORT LIBRARIES AND SOURCE FILES   #
#                                       #
######################################### 

# Source files
source("./convenience.R")

# Libraries
library("tidyverse")
library("reshape2")
library("RColorBrewer")
library("ComplexHeatmap")



#########################################
#                                       #
#         SPECIFY VARIABLES             #
#                                       #
######################################### 

# For this script to work you need to save your WormExp database output as text file in some folder.
# Add here the information where these file(s) can be found.
path <- "../05_QualityManagement/OQ_PQ/Zarate-Potes/data/wormexp_output/"

# specify output path
output_path <- "../05_QualityManagement/OQ_PQ/Zarate-Potes/figs/by_category/"

# change the number of hits you want to have analysed.
# default is top 30
top <- 30

# specify here a category
category <- "Mutants"


#########################################
#                                       #
#     COMPARISON OF TOP N RESULTS       #
#                                       #
######################################### 

# This script takes the columns category, term and OverlappedID and presents a heatmap
# that shows the percentage of genes overlapping within all top n hits (independent of category!)
# If you want to create heatmaps that compare specific categories, please scroll further down
# NB: this heatmaps is NOT SYMMETRICAL and has to be read column-wise

# Import data
data_list <- import(path = path, pattern="*.txt", header = TRUE)

# remove all columns besides Category, Term and Overlapped ID
# keep only top 30
cluster_binary <- list()
for (i in 1:length(data_list)) {
  cluster_binary[[i]] <- data_list[[i]] %>% 
    arrange(FDR, decreasing = FALSE) %>% 
    distinct(Term, .keep_all = TRUE) %>%   # sort out duplicates due to data sets in multiple categories
    slice(1:top) %>% 
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
cross_prod <- lapply(cross_prod, function(x) floor((x*100/diag(x))))

# name cross_prod objects
names(cross_prod) <- names(data_list)

# plot
title_list <- names(cross_prod)

# create list with row_order objects
row_order_list <- list()
for(i in 1:length(cross_prod)){
  
  ht1 <- Heatmap(cross_prod[[i]],
                 cluster_rows = FALSE,
                 cluster_columns = TRUE)
  ht1 <- draw(ht1)
  
  row_order_list[[i]] <- column_order(ht1)

}

dev.off()

for(i in 1:length(cross_prod)){
  
  # save file 
  png(paste(output_path, title_list[i], ".png", sep = "", collapse = NULL), width = 1200, height = 1200)
  
  # plot file
  ht <- Heatmap(cross_prod[[i]],
          column_title = paste("Gene Overlap of", title_list[i], sep = " ", collapse = NULL),
          column_title_gp = gpar(fontsize = 15),
          col = colorRampPalette(brewer.pal(8, "Reds"))(10),
          cluster_rows = FALSE,
          cluster_columns = TRUE,
          row_order = row_order_list[[i]],
          column_names_gp = gpar(fontsize = 10),
          row_names_gp = gpar(fontsize = 10),
          heatmap_width = unit(18, "cm"),
          heatmap_height = unit(18, "cm"),
          heatmap_legend_param = list(
            title = "Gene Overlap in [%]", at = c(0,20,40,60,80,100), 
            labels = c("0","20","40","60","80","100"))
          
  )

  draw(ht, heatmap_legend_side = "left")
  
  # remove settings
  dev.off()

}

#########################################
#                                       #
#   COMPARISON OF SPECIFIC CATEGORIES   #
#                                       #
######################################### 

# Import data
data_list <- import(path = path, pattern="*.txt", header = TRUE)

# filter by a category and remove all columns besides Category, Term and Overlapped ID
# keep only top 30
cluster_binary <- list()
for (i in 1:length(data_list)) {
  cluster_binary[[i]] <- data_list[[i]] %>% 
    filter(Category == category) %>%    # specify here which category to focus on
    arrange(FDR, decreasing = FALSE) %>% 
    distinct(Term, .keep_all = TRUE) %>%   # sort out duplicates due to data sets in multiple categories
    slice(1:top) %>% 
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
cross_prod <- lapply(cross_prod, function(x) floor((x*100/diag(x))))

# name cross_prod objects
names(cross_prod) <- names(data_list)

# plot
title_list <- names(cross_prod)

# create list with row_order objects
row_order_list <- list()
for(i in 1:length(cross_prod)){
  
  ht1 <- Heatmap(cross_prod[[i]],
                 cluster_rows = FALSE,
                 cluster_columns = TRUE)
  ht1 <- draw(ht1)
  
  row_order_list[[i]] <- column_order(ht1)
  
}

dev.off()

# subset category for correct naming of graphs
category_sub <- sub("\\/.*", "", category)

for(i in 1:length(cross_prod)){
  
  # save file 
  png(paste(output_path, category_sub, "_", title_list[i], ".png", sep = "", collapse = NULL), width = 1200, height = 1200)
  
  # plot file
  ht <- Heatmap(cross_prod[[i]],
                column_title = paste("Gene Overlap in category", category, title_list[i], sep = " ", collapse = NULL),
                column_title_gp = gpar(fontsize = 15),
                col = colorRampPalette(brewer.pal(8, "Reds"))(10),
                cluster_rows = FALSE,
                cluster_columns = TRUE,
                row_order = row_order_list[[i]],
                column_names_gp = gpar(fontsize = 10),
                row_names_gp = gpar(fontsize = 10),
                heatmap_width = unit(18, "cm"),
                heatmap_height = unit(18, "cm"),
                heatmap_legend_param = list(
                  title = "Gene Overlap in [%]", at = c(0,20,40,60,80,100), 
                  labels = c("0","20","40","60","80","100"))
                
  )
  
  draw(ht, heatmap_legend_side = "left")
  
  # remove settings
  dev.off()
  
}




