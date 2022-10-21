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
# Add here the information where these file(s) can be found.

path <- "../../ResultsTable.txt"

# specify output path
output_path <- "../../"

#########################################
#                                       #
#     CLEANING RESULTS TABLE		    #
#                                       #
######################################### 

# This script cleanes the ResultsTable and saves it back as .csv
results_table <- read_delim(path)

# to-do adjust counts
cleaned_table <- results_table %>% 
    arrange(Term) %>% 
    mutate(OverlappedID = strsplit(as.character(OverlappedID), "[,;]+")) %>%
    unnest(OverlappedID) %>% 
    group_by(Term) %>% 
    distinct(OverlappedID, .keep_all = TRUE) %>% 
    nest(OverlappedID = c(OverlappedID)) %>%
    mutate(Counts = length(unlist(OverlappedID)),
		OverlappedID = paste(unlist(OverlappedID),collapse=";"))

write_csv(cleaned_table, paste(output_path,"ResultsTable_cleaned.csv",sep=""))


