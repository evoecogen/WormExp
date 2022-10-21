# WormExp

## News:
### 21.10.2022: 
In July 2022, WormExp has been updated to v2, including new gene sets which are now sorted into multiple categories to offer more options when analyzing data sets. However, a current issue inflates the output table, duplicating gene entries. A script has been provided in 04_Skripts/cleaning_ouput.R to remove duplicate gene entries from the results table. This is an intermediate solution until the issue is resolved. 


## Description:
WormExp is a transcriptomics database for Caenorhabditis elegans (C. elegans). Here, dgene sets that have been published all over the world are collected and categorized. Updating the database is instrumental, as conducting gene enrichment analysis is an integral part for studies on C. elegans. It is therefore vital, that such a database is correctly set up and regularly updated. This GitHub repository provides documentation on the update procedure and allows updates from the community to continuously improve the database. 

The repository has the following structure: 
- 00_Archive:   Contains files no longer needed, but will also not be deleted 
- 01_Background:    Contains background information and literature about the project, like the underlying JAVA project.
- 02_ServerFiles:   Copy of the current files active on the server as well as former versions.
- 03_Documentation:	    All documentation and information about his project and its structure.
- 04_Scripts:   Contains all scripts that have been used for updating the database, but also helpful scripts for visualization purposes.
- 05_QualityManagement:	    Contains folders with test sets and test WormExp databases to test for errors
- 06_Datafinder:    Contains folders and files with found GEO accession numbers
- 07_Wormbase:  Contains a collection of WormBase ID changes 

For detailed information about the update procedure, see "./03_Documentation/SOP-01-A1_Updating_WormExp.docx". 
