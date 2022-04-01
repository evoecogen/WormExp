# Source files
source("./convenience.R")

# Libraries
library("tidyverse")
library("ggplot2")
library("UpSetR")
library("ComplexHeatmap")

# Import data
data_list <- import(path = "./Zarate-Potes/cluster_sets/wormexp_output", pattern="C\\d*")

# remove all columns besides Category, Term and Overlapped ID 
# keep only unique OverlappedIDs for every Term -> otherwise calculating percentages is difficult
# Unnested table is the basis for all further plots

for (i in 1:length(data_list)) {
  data_list[[i]] <- data_list[[i]] %>% 
    select(Category, Term, OverlappedID) %>% 
    mutate(OverlappedID = strsplit(as.character(OverlappedID), "[,;]+")) %>%
    unnest(OverlappedID) %>% 
    group_by(Category,Term) %>% 
    distinct(OverlappedID, .keep_all = TRUE)
}

View(data_list[[1]])


## Quantitative Analysis

# reformat all tables in cluster_list and make new table
summarized_cluster = list()

for (i in 1:length(data_list)) {
  dat <- data_list[[i]] %>% 
    group_by(Category) %>% 
    summarize("Counts" = n()) %>% 
    add_column("Cluster" = cluster_names[[i]])
  
  summarized_cluster[[i]] <- dat
}
  
big_data <- do.call(rbind, summarized_cluster)

# plot
absolute_counts <- ggplot(big_data, aes(fill=Category, y=Counts, x=Cluster)) + 
  geom_bar(position="stack", stat="identity") +
  labs(title = "Absolute Hits per Category", x = "Cluster", y = "Counts") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
absolute_counts

percentage_counts <- ggplot(big_data, aes(fill=Category, y=Counts, x=Cluster)) + 
  geom_bar(position="fill", stat="identity") +
  labs(title = "Proportions of Categories", x = "Cluster", y = "Proportions [%]") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
percentage_counts


# make stack barplot of overlapping gene sets
summed_data <- big_data %>% 
  group_by(Cluster) %>% 
  summarise(Counts = sum(Counts))

summed_data <- summed_data %>% 
  separate(Cluster, c("Cluster", "Origin"), sep = "_")

# calculate overlap
overlap <- list()
a <- c(1,3,5,7,9,11,13,15,17,19)

for (i in a) {
  diff <- length(intersect(cluster_list[[i+1]]$Term, cluster_list[[i]]$Term))
  overlap[i] <- diff
}

overlap[sapply(overlap, is.null)] <- NULL
overlap <- unlist(overlap)

# add overlap to table
clusters <- unique(summed_data$Cluster)
origin <- rep("overlap", 10)

overlap_table <- data.frame(Cluster = clusters, Origin = origin, Counts = overlap)

summed_data <- rbind(summed_data, overlap_table)


# plot
counts_comparison <- ggplot(summed_data, aes(fill=Origin, y=Counts, x=Cluster)) + 
  geom_bar(position="stack", stat="identity") +
  geom_text(aes(label = Counts),size=3) +
  labs(title = "Overlap per Cluster", x = "Cluster", y = "Counts") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
counts_comparison

percentage_counts <- ggplot(summed_data, aes(fill=Origin, y=Counts, x=Cluster)) + 
  geom_bar(position="fill", stat="identity") +
  labs(title = "Proportions of Categories", x = "Cluster", y = "Proportions [%]") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
percentage_counts


## Qualitative Analysis

temp_cluster <- data_list[["C1_new"]]

### Presence-Absence-Pattern
# just for category chemicals

chemicals <- subset(temp_cluster, Category == "Chemicals/stress")

chemicals %>%
  mutate_if(is.factor, as.character) %>%
  group_by(Term) %>%
  mutate(total = n_distinct(OverlappedID)) %>%
  ggplot(aes(Term, reorder(OverlappedID, total))) +
  geom_tile() +
  # scale_fill_gradient(low = "white", high = "red", limits = c(30,100)) +
  theme(axis.text.y = element_text(vjust = 0.1, hjust=1)) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.1, hjust=1)) +
  labs(title = "Presence-Absence-Pattern", x="Term", y="Genes")


### Heatmaps for chemicals

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




### UpSet plot for C1 chemicals

# Create binary matrix
temp_cluster <- data_list[["C1_new"]]
temp_cluster <- subset(temp_cluster, Category == "Chemicals/stress")

temp_binary <- temp_cluster %>% 
  group_by(Term, OverlappedID) %>% 
  summarise(n = n()) %>%
  spread(OverlappedID, n, fill = 0) %>% 
  column_to_rownames(var="Term")

# filter genes
temp_binary_genes <- as.matrix(taxa.filter(temp_binary, percent.filter = 0.20, relabund.filter = 0.001))

# filter terms
temp_binary_terms <- as.matrix(taxa.filter(t(temp_binary), percent.filter = 0.20, relabund.filter = 0.001))


# UpSet plot for genes
genes_of_interest <- colnames(temp_binary_genes)

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


# UpSet plot for genes
terms_of_interest <- colnames(temp_binary_terms)

temp_contigs <- unique(temp_cluster$OverlappedID)
term_objects <- list()

for (i in 1:length(terms_of_interest)) {
  term_objects[[i]] <- temp_cluster$OverlappedID[temp_cluster$Term == terms_of_interest[i]]
}

names(term_objects) <- terms_of_interest


combination_matrix <- 1 * sapply(term_objects, function(x) temp_contigs %in% x)
combination_matrix <- make_comb_mat(combination_matrix)
combination_matrix

UpSet(combination_matrix, set_order = terms_of_interest)


## Heatmap Overlap of Top 30 signifikant Hits per Cluster

# Import data 
data_list <- import(path = "./Zarate-Potes/cluster_sets/wormexp_output", pattern="C\\d*")

# remove all columns besides Category, Term and Overlapped ID
# keep only top 30
for (i in 1:length(data_list)) {
  data_list[[i]] <- data_list[[i]] %>% 
    # add_column(ID = seq(1, nrow(data_list[[i]]), 1)) %>% 
    # select(ID, Term, OverlappedID) %>% 
    slice(1:30) #discussable
}


# Extract first cluster
# Make binary again

cluster_binary <- data_list[[1]] %>% 
  mutate(OverlappedID = strsplit(as.character(OverlappedID), "[,;]+")) %>%
  unnest(OverlappedID) %>% 
  group_by(Term, OverlappedID) %>% 
  distinct(OverlappedID, .keep_all = TRUE) %>% 
  summarise(n = n()) %>%
  spread(OverlappedID, n, fill = 0) %>% 
  column_to_rownames(var="Term")

# make matrix out of binary table and switch terms as column (for crossprod)
cluster_matrix <- t(cluster_binary)

# calculate crossproduct -> how much overlap exists between terms and calculate percentages
res <- crossprod(cluster_matrix)                         
res <- floor(t(res*100/diag(res)))

# plot
col_fun = colorRamp2(c(0, 50, 100), c("white", "orange", "red"))
lgd <- Legend(col_fun = col_fun, title = "Overlapped Genes [%]")

Heatmap(res, 
        col = col_fun,
        cluster_rows = FALSE,
        cluster_columns = FALSE,
        column_names_gp = gpar(fontsize = 8),
        row_names_gp = gpar(fontsize = 8),
        column_title = "Gene Overlap in C1 (old)",
        heatmap_legend_param = list(
          title = "Overlapped Genes [%]", 
          at = c(0, 50, 100), 
          labels = c("0", "50", "100"),
          color_bar = "continuous")
        )

# make Upset plot as comparison
data_list <- import(path = "./Zarate-Potes/cluster_sets/wormexp_output", pattern="C\\d*")

# remove all columns besides Term and Overlapped ID
# keep only top 30
for (i in 1:length(data_list)) {
  data_list[[i]] <- data_list[[i]] %>% 
    slice(1:30) %>% 
    select(Term, OverlappedID) %>% 
    mutate(OverlappedID = strsplit(as.character(OverlappedID), "[,;]+")) %>%
    unnest(OverlappedID) %>% 
    group_by(Term) %>% 
    distinct(OverlappedID, .keep_all = TRUE)
}

# use binary matrix again
cluster_binary <- data_list[["C1_new"]] %>% 
  mutate(OverlappedID = strsplit(as.character(OverlappedID), "[,;]+")) %>%
  unnest(OverlappedID) %>% 
  group_by(Term, OverlappedID) %>% 
  distinct(OverlappedID, .keep_all = TRUE) %>% 
  summarise(n = n()) %>%
  spread(OverlappedID, n, fill = 0) %>% 
  column_to_rownames(var="Term")

# filter genes -> Attention: row will be filtered!
cluster_matrix <- as.matrix(taxa.filter(t(cluster_binary), percent.filter = 0.20, relabund.filter = 0.001))

# rows of filtered table are the terms of interest
terms_of_interest <- colnames(cluster_matrix)

contigs <- unique(data_list[["C1_new"]]$OverlappedID)
term_objects <- list()

for (i in 1:length(terms_of_interest)) {
  term_objects[[i]] <- data_list[["C1_new"]]$OverlappedID[data_list[["C1_new"]]$Term == terms_of_interest[i]]
}

names(term_objects) <- terms_of_interest


combination_matrix <- 1 * sapply(term_objects, function(x) contigs %in% x)
combination_matrix <- make_comb_mat(combination_matrix)
combination_matrix

UpSet(combination_matrix, set_order = terms_of_interest)










