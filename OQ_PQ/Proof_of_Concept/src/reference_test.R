# Source
source("./convenience.R")

# Libraries
library("tidyverse")

# Import
data_list <- import(path = "../Reference_Check", pattern ="*.txt", header = FALSE)

# extract reference
reference <- data_list$reference

# remove reference and WormbaseIDs
data_list <- data_list[-c(1, 10)]

# Find elements where reference and data set do not match
gene_sets <- list()
for (i in 1:length(data_list)){
  res <- list()
  res <- data_list[[i]] %>% 
    group_by(V2) %>% 
    distinct(V2, .keep_all = TRUE) %>% 
    select(V2) %>% 
    as.data.frame()
  
  gene_sets[[i]] <- res
  
  gene_sets[[i]] <- gene_sets[[i]] %>% 
    add_column(Category = names(data_list)[i])
  
}

big_list <- do.call(rbind, gene_sets)

# outersect -> finds not matching elements
diff <- outersect(big_list, reference$V1)

# export faulty references for further use in Excel
write(diff, "faulty_references.txt")

# search for gene sets in big_list

big_list %>% 
  filter(str_detect(V2, "DD") == TRUE)


reference  %>% 
  dplyr::select(V1) %>% 
  filter(str_detect(V1, "Ochrobactrum") == TRUE)


small_list <- subset(big_list, Category == "Development-Dauer-Aging")
