The "WormExp" is the webapp, copy to tomcat webapp directory

Before deploy the webapp, please first run "java -classpath test.jar com.dem.test.HiServer" at WormSource.

To add data sets, 
 1) Prepare set as "wormbaseID	setname": be sure the name is unique (not overlapped with current set, easiest way is named it as [setname]_[authorname])
 2) assign subclass to geneset [Chemicalexposure-otherStress, DAF Insulin food, Development-Dauer-Aging, Kim Mounts, Mutants, Pathogen, Targets, Tissue-specific, Other]
 3) Paste the data set into geneset file (e.g., set for Chemicalexposure-otherStress should be copied into Chemicalexposure-otherStress.txt]
 4) put a reference into reference.txt as "setname	pubmed link", if no reference yet, put a 'NA' or weblink to the source data
 5) fill in WormExp_info.xlsx as [subclass	setname	reference	additional_info	numberofgene	source]

For GEO dataset updating (GSE):
 1) check WormExp_info.xlsx and find the largest number of GSE number (e.g.,GSE123456)
 2) navigate to https://www.ncbi.nlm.nih.gov/gds
 3) search	C. elegans and click "Caenorhabditis elegans" in the right side at "Top Organisms"
 4) check and download sets with GSE number greater than number identified in 1)
 5) check GSE data set to see if there is reference link
	a)if there is reference link, check the reference to see if they provide a analyzed set, use the analyzed set if there is one
	b)if no reference link, try to search the title on google or google scholar, sometimes you can find a reference (especially for those old than 1 year)
	c)if both don't work, check if there is a supplementary table for analyzed data set in GSE
	d)if all don't work, download the rawdata and perform analysis.
	e)for c and d, save the GSE number to WormExp_info.xlsx as new sheet and check these number later to see if reference available.
For enmble data updating (E-MEXP):
  same as GSE, but check at https://www.ebi.ac.uk/arrayexpress/browse.html


Further websites:
https://wormexp.zoologie.uni-kiel.de/wormexp/
https://wormbase.org/#012-34-5