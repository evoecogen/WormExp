# Source
source("./convenience.R")

# Libraries
library("tidyverse")

# Import
data_list <- import(path = "../Reference_Check", pattern ="*.txt", header = FALSE)

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
big_list <- as.data.frame(cbind(trim(big_list$V2), big_list$Category))


# search for gene sets in big_list
big_list %>% 
  filter(str_detect(V1, "daf-2") == TRUE)


trimmed_references  %>% 
  as.data.frame() %>% 
  dplyr::select(V1) %>% 
  filter(str_detect(V1, "adr") == TRUE)


small_list <- subset(big_list, Category == "Development-Dauer-Aging")



# for all category files, trim gene set names and overwrite file
category_names <- names(data_list)

for(i in 1:length(category_names)){
  print(category_names[i])
  temp <- as.data.frame(data_list[i]) 
  temp <- lapply(temp, trimws)
  
  write.table(temp, paste("../Reference_Check/", category_names[i], ".txt", sep = "", collapse = NULL), quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t", na = "NA")
  
}


# also for references
wormexp_info <- read_csv("../Reference_Check/WormExp_info.csv")

references_new <- wormexp_info %>% 
  as.data.frame() %>% 
  dplyr::select(c(Gene_set_name, Refs, Additional_categories))

trimmed_references <- as.data.frame(cbind(trim(references_new$Gene_set_name), trim(references_new$Refs), references_new$Additional_categories))

write.table(trimmed_references, "../Reference_check/reference.txt", sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)







