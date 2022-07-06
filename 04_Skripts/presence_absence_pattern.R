# Source files
source("./convenience.R")

# Libraries
library("tidyverse")
library("ggplot2")

# Import data
data_list <- import(path = "../Gene_Overlap/", pattern="*.txt")

# Prepare data as you see fir
temp_cluster <- data_list[["C1_new"]]
chemicals <- subset(temp_cluster, Category == "Chemicals/stress")

# Presence-Absence-Pattern
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