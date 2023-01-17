#########################################
#                                       #
#   IMPORT LIBRARIES AND SOURCE FILES   #
#                                       #
#########################################

# Source files
source("./convenience.R")



# Libraries
library("tidyverse")


#########################################
#                                       #
#         SPECIFY VARIABLES             #
#                                       #
#########################################

# For this script to work you need to save your WormExp database output as text file in some folder. 
# Add here the information where these file can be found.
path <- "D:/Bioinformatics/Projects/WormExp/GitHub/05_QualityManagement/WormSource_v1.5/"

# specify output path
output_path <- "D:/Bioinformatics/Projects/WormExp/GitHub/05_QualityManagement/WormSource_v1.5/cleaned/"

#########################################
#                                       #
#     CLEAN TXT FILES FROM DUPLICATES   #
#                                       #
#########################################

# This script cleanes the ResultsTable and saves it back as .txt
wormexp_info <- read_delim(paste(path,"WormExp_info_data.txt", sep = "")) %>% 
  select(Additional_categories, Gene_set_name) %>% 
  drop_na() %>% 
  separate(Additional_categories, c("category_2", "category_3"), sep = ";") %>% 
  mutate(category_2 = case_when(category_2 == "pathogens" ~ 'Pathogen',
                                category_2 == "mutants" ~ 'Mutants',
                                category_2 == "epigenetics" ~ "Epigenetics",
                                category_2 == "daf" ~ "DAF Insulin food",
                                category_2 == "development" ~ "Development-Dauer-Aging",
                                category_2 == "chemicals" ~ "Chemicalexposure-otherStress",
                                category_2 == "tissues" ~ "Tissue-specific",
                                category_2 == "targets" ~ "Targets"),
         category_3 = case_when(category_3 == "pathogens" ~ 'Pathogen',
                                category_3 == "mutants" ~ 'Mutants',
                                category_3 == "epigenetics" ~ "Epigenetics",
                                category_3 == "daf" ~ "DAF Insulin food",
                                category_3 == "development" ~ "Development-Dauer-Aging",
                                category_3 == "chemicals" ~ "Chemicalexposure-otherStress",
                                category_3 == "tissues" ~ "Tissue-specific",
                                category_3 == "targets" ~ "Targets"))
  

# create a list with gene sets for all categories with gene sets to delete
categories <- c("Tissue-specific", "Targets", "Chemicalexposure-otherStress", 
                "Development-Dauer-Aging", "DAF Insulin food", "Epigenetics", 
                "Mutants", "Pathogen")
categories_data <- list()


for (i in 1:length(categories)){
  categories_data[[i]] <- wormexp_info %>% 
    filter(category_2 == categories[i] | category_3 == categories[i]) %>% 
    select(Gene_set_name)
  
  names(categories_data)[[i]] <- categories[i]
}

# open file fitting to list name and remove all accounts from the respective gene set
for (i in 1:length(categories_data)){
  category_file <- read.delim(paste(path, names(categories_data)[[i]], ".txt", sep = ""), header = FALSE) 
  category_file <- category_file[!category_file$V2 %in% unlist(categories_data[[i]]), ]
  
  write.table(category_file, 
              paste(output_path, names(categories_data)[[i]], ".txt", sep = "", collapse = NULL), 
              sep = "\t", 
              col.names = FALSE, 
              row.names = FALSE, 
              quote = FALSE)
}






