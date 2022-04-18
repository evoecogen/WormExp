# Source files
source("./convenience.R")

# Libraries
library("tidyverse")
library("ggplot2")


# Import data
data_list <- import(path = "../Zarate-Potes/cluster_sets/wormexp_output", pattern="C\\d*")

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


## Quantitative Analysis

# reformat all tables in cluster_list and make new table
summarized_cluster = list()

for (i in 1:length(data_list)) {
  dat <- data_list[[i]] %>% 
    group_by(Category) %>% 
    summarize("Counts" = n()) %>% 
    add_column("Cluster" = names(data_list)[i])
  
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
  summarise(Counts = sum(Counts)) %>% 
  separate(Cluster, c("Cluster", "Origin"), sep = "_")


# calculate overlap
overlap <- list()
a <- c(1,3,5,7,9,11,13,15,17,19)

for (i in a) {
  diff <- length(intersect(data_list[[i+1]]$Term, data_list[[i]]$Term))
  overlap[[i]] <- diff
}

overlap[sapply(overlap, is.null)] <- NULL
overlap <- unlist(overlap)

# add overlap to table
clusters <- unique(summed_data$Cluster)
origin <- rep("overlap", 10)

overlap_table <- data.frame(Cluster = clusters, Origin = origin, Counts = overlap)

summed_data <- rbind(summed_data, overlap_table)

# plot
summed_data %>% 
  filter(!Origin == "old") %>% 
  ggplot(aes(fill=Origin, y=Counts, x=Cluster)) + 
  geom_bar(position="stack", stat="identity") +
  geom_text(aes(label = Counts),size=3) +
  labs(title = "Overlap per Cluster", x = "Cluster", y = "Counts") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))


summed_data %>% 
  filter(!Origin == "old") %>% 
  ggplot(aes(fill=Origin, y=Counts, x=Cluster)) + 
  geom_bar(position="fill", stat="identity") +
  labs(title = "Proportions of Categories", x = "Cluster", y = "Proportions [%]") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

summed_data %>% 
  filter(Origin == "old")
