#########################################
#                                       #
#   IMPORT LIBRARIES AND SOURCE FILES   #
#                                       #
######################################### 

# Source
source("./convenience.R")

# Libraries
library("tidyverse")
library("readxl")



#########################################
#                                       #
#         SPECIFY VARIABLES             #
#                                       #
######################################### 

# Add information where WormExp category files and WormExp_info are saved
path <- "../05_QualityManagement/WormSource_v2.0/"



#########################################
#                                       #
#               SKRIPT                  #
#                                       #
######################################### 

# Import all text files in this folder and keep only category files
data_list <- import(path = path, pattern ="*.txt", header = FALSE)

# only keep category files (check manually if these indexes are correct!)
data_list <- data_list[-c(1, 10)]

# for all category files, trim gene set names and overwrite file
category_names <- names(data_list)

for(i in 1:length(category_names)){
  
  temp <- as.data.frame(data_list[i]) 
  temp <- lapply(temp, trimws)
  
  write.table(temp, 
              paste(path, category_names[i], ".txt", sep = "", collapse = NULL), 
              quote = FALSE, 
              row.names = FALSE, 
              col.names = FALSE, 
              sep = "\t", 
              na = "NA")
}

# Import references from WormExp_info, trim references and save in reference.txt
wormexp_info <- read_excel(paste(path, "WormExp_info.xlsx", sep = "/", collapse = NULL), sheet = 2)

references <- wormexp_info %>% 
  as.data.frame() %>% 
  dplyr::select(c(Gene_set_name, Refs, Additional_categories))

trimmed_references <- as.data.frame(cbind(trim(references$Gene_set_name), trim(references$Refs), references$Additional_categories))

write.table(trimmed_references, 
            paste(path, "reference.txt", sep = "/", collapse = NULL), 
            sep = "\t", 
            col.names = FALSE, 
            row.names = FALSE, 
            quote = FALSE)
