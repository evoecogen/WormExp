# filtering of binary matrix
taxa.filter<-function(taxtab, percent.filter=percent.filter, relabund.filter=relabund.filter){
  # get assigned taxa only
  taxlist<-colnames(taxtab[,1:ncol(taxtab)])
  # filter using percent.filter
  taxtest <- apply(taxtab[,taxlist],2,function(x){length(x[!is.na(x)&x>0])})
  taxget<-taxtest[taxtest>=percent.filter*(nrow(taxtab))]
  #filter using relabund.filter
  taxtestm<-apply(taxtab[,taxlist],2,mean,na.rm=T)
  taxgetm<-taxtestm[taxtestm>relabund.filter]
  taxlistf<-c(names(taxget)[names(taxget) %in% names(taxgetm)])
  # make new processed data frame
  dataframe <- subset(taxtab, select = c(taxlistf))
  return(dataframe)
}

# returns a list with all files in this folder
import <- function(path = path, pattern = pattern, header = header) {
  # import cluster data
  temp <- list.files(path = path, pattern = pattern, full.names = TRUE)
  data_list <- lapply(temp, function(x) read.delim(x, header = header))
  
  # extract cluster names and name data_list
  cluster_names <- lapply(temp, function(x) sub("\\.[[:alnum:]]+$", "", basename(as.character(x))))
  names(data_list) <- cluster_names
  return(data_list)
}

make_binary <- function(data = data, x = x, y = y){ # what is happening???
  res <- data %>% 
    group_by(x, y) %>% 
    summarise(n = n()) %>%
    spread(y, n, fill = 0) %>% 
    column_to_rownames(var=x)
  return(res)
}

outersect <- function(x, y, ...) {
  big.vec <- c(x, y, ...)
  duplicates <- big.vec[duplicated(big.vec)]
  setdiff(big.vec, unique(duplicates))
}

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

