#########################################
#                                       #
#   IMPORT LIBRARIES AND SOURCE FILES   #
#                                       #
######################################### 

# Source files
source("./convenience.R")

# Libraries
library("tidyverse")
library("ggplot2")



#########################################
#                                       #
#         SPECIFY VARIABLES             #
#                                       #
######################################### 

# To compare overlapping genes, create text files that contain gene names or Wormbase IDs and a potential second column with specifications
# Add here the information where these file(s) can be found.
path <- "../05_QualityManagement/OQ_PQ/Gene_Overlap/"

#########################################
#                                       #
#               SKRIPT                  #
#                                       #
######################################### 

# Import data
data_list <- import(path = path, pattern="*.txt", header = FALSE)

# This script works best when used after an additional filter, e.g. for a specific category
temp_cluster <- subset(data_list, Category == "Chemicals/stress")

# Presence-Absence-Pattern
chemicals %>%
  mutate_if(is.factor, as.character) %>%
  group_by(Term) %>%
  mutate(total = n_distinct(OverlappedID)) %>%
  ggplot(aes(Term, reorder(OverlappedID, total))) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red", limits = c(30,100)) +
  theme(axis.text.y = element_text(vjust = 0.1, hjust=1)) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.1, hjust=1)) +
  labs(title = "Presence-Absence-Pattern", x="Term", y="Genes")