# Source files
source("./convenience.R")

# Libraries
library("tidyverse")
library("ggplot2")
library("UpSetR")
library("ComplexHeatmap")

# Import data
data_list <- import(path = "./Zarate-Potes/cluster_sets/wormexp_output", pattern="C\\d*")

temp_cluster <- data_list[["C1_new"]] %>% 
  group_by(Term, OverlappedID) %>% 
  mutate(OverlappedID = strsplit(as.character(OverlappedID), "[,;]+")) %>%
  unnest(OverlappedID)

# Create binary matrix
temp_binary <- temp_cluster %>% 
  group_by(Term, OverlappedID) %>% 
  mutate(OverlappedID = strsplit(as.character(OverlappedID), "[,;]+")) %>%
  unnest(OverlappedID) %>%
  summarise(n = n()) %>%
  spread(OverlappedID, n, fill = 0) %>% 
  column_to_rownames(var="Term")

# filter genes
temp_binary_genes <- as.matrix(taxa.filter(temp_binary, percent.filter = 0.20, relabund.filter = 0.001))

# filter terms
temp_binary_terms <- as.matrix(taxa.filter(t(temp_binary), percent.filter = 0.20, relabund.filter = 0.001))


# UpSet plot for genes
genes_of_interest <- colnames(temp_binary)

gene_contigs <- unique(temp_cluster$Term)
gene_objects <- list()

for (i in 1:length(genes_of_interest)) {
  gene_objects[[i]] <- temp_cluster$Term[temp_cluster$OverlappedID == genes_of_interest[i]]
}

names(gene_objects) <- genes_of_interest


combination_matrix <- 1 * sapply(gene_objects, function(x) gene_contigs %in% x)
combination_matrix <- make_comb_mat(combination_matrix)
combination_matrix

UpSet(combination_matrix, set_order = genes_of_interest)