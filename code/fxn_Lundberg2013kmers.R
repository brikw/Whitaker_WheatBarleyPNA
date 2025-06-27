# create PNAs based on Lundberg et al 2013 methods

# make kmers from a sequence
k_mers <- function(sequence, k) {
  result <- substring(sequence, 1:(nchar(sequence)-k+1), k:nchar(sequence)) 
  return(result)
}

# make kmers of more than 1 length from a sequence
make_all_kmers <- function(sequence, k.list) {
  kmers <- unlist(lapply(k.list, k_mers, sequence = sequence))
  names(kmers) <- paste("kmer",seq(1:length(kmers)), sep = "_")
  #kmers.stringset<- DNAStringSet(x = kmers, use.names = T)
  
  return(kmers)
}

# make kmers of more than 1 length from more than 1 sequence
make_all_kmers_ManyTemplates <- function(sequence.list, k.list){
  
  # make sure your sequence.list has named elements
  
  kmers.list <- list()
  for(i in 1:length(sequence.list)){
    sequence <- as.character(sequence.list[i])
    kmers.list[[i]] <- make_all_kmers(sequence, k.list=k.list)
  }
  names(kmers.list) <- names(sequence.list) # this is why the named elements part is important
  kmers.result <- unique(unlist(kmers.list))
  names(kmers.result) <- paste("kmer",seq(1:length(kmers.result)), sep = "_")
  kmers.result.stringset<- DNAStringSet(x = kmers.result, use.names = T)
  
  return(kmers.result.stringset)
}

# make kmers from consensus seq
make_kmers_consensus <- function(rois.a, k.list){

  consens.roi <- ConsensusSequence(rois.a, noConsensusChar = "N")
  consens.roi.nog <- RemoveGaps(consens.roi)
  kmers <- make_all_kmers_ManyTemplates(sequence.list = consens.roi.nog, k.list)
  
  return(kmers)
  
}

# blast each kmer against fungal reference database
blast.kmers <- function(kmer.stringset){
  
  # unite fungal reference database (https://unite.ut.ee/repository.php)
  # UNITE Community (2019): UNITE general FASTA release for Fungi. Version 18.11.2018. UNITE Community. https://doi.org/10.15156/BIO/786343 
  #makeblastdb(file = "data/fungal_db/sh_general_release_dynamic_02.02.2019.fasta", dbtype = "nucl")
  blastdb <- blast("data/fungal_db/sh_general_release_dynamic_02.02.2019.fasta") #open the database
  
  result.list <- list()
  for(i in 1:length(kmer.stringset)){
    result.list[[i]] <- predict(blastdb, kmer.stringset[i], BLAST_args="-word_size 9")
    print(paste(i, "of", length(kmer.stringset), sep = " "))
  }
  names(result.list)<- names(kmer.stringset)
  result.df <- list_to_df(result.list)
  result.df %>%
    rename('kmer.id' = 'source') %>% # keep only 100% matches
    filter(Perc.Ident == 100) -> result.df
  
  return(result.df)
  
}

# create a list of kmers that had no fungal db hits
pullKmerSeqs <- function(hits, kmer.stringset){
  
  #summarize the number of hits per kmer.id
  hits %>%
    group_by(kmer.id) %>%
    summarize(n = length(kmer.id)) -> summ.hit
  # ggplot(summ.hit, aes(x = n)) + 
  #   geom_histogram() + 
  #   xlab("Number of hits per kmer") + ylab("Frequency")
  
  # identify kmer ids w/o any matches in the fungal database
  criteria <- !names(kmer.stringset) %in% summ.hit$kmer.id
  nohits <- names(kmer.stringset)[criteria]
  
  #match kmer.id with sequence
  criteria <- names(kmer.stringset) %in% nohits
  kmer.nohits <- kmer.stringset[criteria]
  
  return(kmer.nohits)
}

add.kmer.position <- function(nohits, rois.a){
  
  # find the consensus seq again that was used to create the kmers
  consens.roi <- ConsensusSequence(rois.a, noConsensusChar = "N")
  consens.roi.nog <- RemoveGaps(consens.roi)
  
  # apply the function over all the no-hit kmers
  start.list<- list()
  for(i in 1:length(nohits)){
    match <- matchPattern(pattern = nohits[[i]], subject = consens.roi.nog[[1]])
    start.list[[i]] <- start(match)
  }
  
  # create a dataframe that holds the sequences and start position
  df <- data.frame(nohits)
  df.nohits <- data.frame(kmer.id = names(nohits), 
                        seq = df$nohits, 
                        start = unlist(start.list))
  
  return(df.nohits)
  
}


