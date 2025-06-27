summ_hits_annotated <- function(blasthits){
  
  # add type
  blasthits %>%
    mutate(Taxonomy_Type = ifelse(grepl("Eukaryota; Fungi", blasthits$Taxonomy), "Fungi",
                                  ifelse(grepl("Eukaryota; Viridiplantae", blasthits$Taxonomy), "Plant", 
                                  ifelse(grepl("Bacteria;", blasthits$Taxonomy), "Bacteria",
                                  "Other")))) -> blasthits.cat
  
  # pick the top hit for each read
  blasthits.cat %>%
    group_by(QueryID) %>%
    summarize(min.e = min(E)) -> read.mine
  read.mine <- data.frame(read.mine)
  
  # subset based on max.e for each read and summarize by QueryID (ASV)
  blasthits.cat %>%
    left_join(read.mine) %>%
    filter(E == min.e)  %>%  # changed to filter by minE
    group_by(QueryID) %>%
    summarize(n = length(SubjectID),   #this is helpful if multiple things have the same highest max E score
              mean.Perc.Ident = mean(Perc.Ident),  #similarly
              sd.Perc.Ident = sd(Perc.Ident),      #similarly
              #uniq.Subject = paste(unique(SubjectID), collapse = "----"),
              uniq.Subject.Type = paste(unique(Taxonomy_Type), collapse = "----")) -> topblasthit.asv
  
  return(topblasthit.asv)
  
}