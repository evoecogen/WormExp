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
  filter(str_detect(V1, "atfs1") == TRUE)


trimmed_references  %>% 
  as.data.frame() %>% 
  dplyr::select(V1) %>% 
  filter(str_detect(V1, "adr") == TRUE)


small_list <- subset(big_list, Category == "Development-Dauer-Aging")



# Extract updated references
wormexp_info <- read_csv("../Reference_Check/WormExp_info.csv")

references_new <- wormexp_info %>% 
  as.data.frame() %>% 
  dplyr::select(c(Gene_set_name, Refs))

trimmed_references <- trim(references_new$`Gene Set name`)
trimmed_references <- as.data.frame(cbind(trim(references_new$Gene_set_name), references_new$Refs))

write.table(references_new, "../Reference_check/new_references.txt", sep = "\t", row.names = FALSE)
  
  
# find overlaps
not_in_references <- setdiff(big_list$V1, trimmed_references$V1)
not_in_datasets <- setdiff(trimmed_references$V1, big_list$V1)

# export faulty references for further use in Excel
write(not_in_references, "datasets_not_in_references.txt")
write(not_in_datasets, "datasets_not_in_datasets.txt")

## write references as string dataframe with tab separated
library("tidyr")

references_old <- read.delim("../../WormSource_test/reference.txt", header = FALSE) %>% 
  mutate_all(na_if,"")

write.table(references_old, "../../WormSource_test/reference_new.txt", row.names = FALSE, col.names = FALSE, sep = "\t", na = "NA")


