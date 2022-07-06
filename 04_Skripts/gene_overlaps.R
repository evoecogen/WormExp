# Source
source("./convenience.R")

# Libraries
library("tidyverse")
library("ggplot2")
library("UpSetR")
library("ComplexHeatmap")

# import cluster data
temp <- list.files(path = "./Gene_Overlap/", pattern="*.txt", full.names = TRUE)
data_list <- lapply(temp, function(x) read.delim(x, header = FALSE))

# extract cluster names and name data_list
file_names <- lapply(temp, function(x) sub("\\.[[:alnum:]]+$", "", basename(as.character(x))))
names(data_list) <- file_names

for (i in 1:length(data_list)) {
  data_list[[i]] <- data_list[[i]] %>% 
    rename("ID" = V1, "Regulation" = V2) %>% 
    add_column("Dataset" = file_names[[i]])
}

big_data <- do.call(rbind, data_list)


## Qualitative Analysis
# find which WormbaseIDs Overlap in which data sets -> create one big table with all datasets

big_data %>%
  mutate_if(is.factor, as.character) %>%
  group_by(Dataset) %>%
  mutate(total = n_distinct(ID)) %>%
  ggplot(aes(Dataset, reorder(ID, total))) +
  geom_tile() +
  # scale_fill_gradient(low = "white", high = "red", limits = c(30,100)) +
  theme(axis.text.y = element_text(vjust = 0.01, hjust=1)) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.1, hjust=1)) +
  labs(title = "Presence-Absence-Pattern", x="Dataset", y="WormbaseID")

big_data %>%
  filter(ID %in% (big_data %>%
                         group_split(Dataset)  %>%
                         map(~pull(., ID)) %>%
                         reduce(intersect)))


# UpSet plot
# Up
data_up <- subset(big_data, big_data$Regulation == "Up")

contigs <- unique(data_up$ID)
objects <- list()
dataset_names <- unlist(file_names)

for (i in 1:length(file_names)) {
  objects[[i]] <- data_up$ID[data_up$Dataset == file_names[[i]]]
}

names(objects) <- file_names


combination_matrix <- 1 * sapply(objects, function(x) contigs %in% x)
combination_matrix <- make_comb_mat(combination_matrix)
comb_up <- combination_matrix

UpSet(combination_matrix, set_order = dataset_names)

# extract IDs
overlap_up <- contigs[extract_comb(comb_up, "1111")]

# Down
data_down <- subset(big_data, big_data$Regulation == "Down")

contigs <- unique(data_down$ID)
objects <- list()
dataset_names <- unlist(file_names)

for (i in 1:length(file_names)) {
  objects[[i]] <- data_down$ID[data_down$Dataset == file_names[[i]]]
}

names(objects) <- file_names


combination_matrix <- 1 * sapply(objects, function(x) contigs %in% x)
combination_matrix <- make_comb_mat(combination_matrix)
comb_down <- combination_matrix

UpSet(combination_matrix, set_order = dataset_names)

# extract IDs
overlap_down <- contigs[extract_comb(comb_down, "1111")]
print(overlap_up)
