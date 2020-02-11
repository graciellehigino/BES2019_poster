c <- makeCluster(detectCores()-1)

# Amphibia

amp.spnames<-parLapply(c, as.character(amp$species), gnr_resolve,
                         data_source_ids=c(173,3,4,11,174,175),
                         resolve_once=FALSE,
                         with_context=FALSE,canonical=FALSE,highestscore=TRUE,
                         best_match_only=TRUE,http="post",splitby=50,cap_first=TRUE,
                         fields = "minimal")



  amp.spnames.val <- vector(length = length(amp.spnames))
  for (i in 1:length(amp.spnames)){
    if (length(amp.spnames[i][[1]]>0)){
      amp.spnames.val[i] <- amp.spnames[[i]]$matched_name
    }
  }
  amp <- amp[amp$species %in% amp.spnames.val,]
  rm(amp.spnames, amp.spnames.val)

# Aves
aves.spnames<-parLapply(c, as.character(aves$species), gnr_resolve,
                         data_source_ids=c(173,3,4,11,174,175),
                         resolve_once=FALSE,
                         with_context=FALSE,canonical=FALSE,highestscore=TRUE,
                         best_match_only=TRUE,http="post",splitby=50,cap_first=TRUE,
                         fields = "minimal")

  aves.spnames.val <- vector(length = length(aves.spnames))
  for (i in 1:length(aves.spnames)){
    if (length(aves.spnames[i][[1]]>0)){
      aves.spnames.val[i] <- aves.spnames[[i]]$matched_name
    }
  }
  aves <- aves[aves$species %in% aves.spnames.val,]
  rm(aves.spnames, aves.spnames.val)


# Mammalia
mam.spnames<-parLapply(c, as.character(mam$species), gnr_resolve,
                         data_source_ids=c(173,3,4,11,174,175),
                         resolve_once=FALSE,
                         with_context=FALSE,canonical=FALSE,highestscore=TRUE,
                         best_match_only=TRUE,http="post",splitby=50,cap_first=TRUE,
                         fields = "minimal")

  mam.spnames.val <- vector(length = length(mam.spnames))
  for (i in 1:length(mam.spnames)){
    if (length(mam.spnames[i][[1]]>0)){
      mam.spnames.val[i] <- mam.spnames[[i]]$matched_name
    }
  }
  mam <- mam[mam$species %in% mam.spnames.val,]
  rm(mam.spnames, mam.spnames.val)

# Reptilia
rep.spnames<-parLapply(c, as.character(rep$species), gnr_resolve,
                         data_source_ids=c(173,3,4,11,174,175),
                         resolve_once=FALSE,
                         with_context=FALSE,canonical=FALSE,highestscore=TRUE,
                         best_match_only=TRUE,http="post",splitby=50,cap_first=TRUE,
                         fields = "minimal")

  rep.spnames.val <- vector(length = length(rep.spnames))
  for (i in 1:length(rep.spnames)){
    if (length(rep.spnames[i][[1]]>0)){
      rep.spnames.val[i] <- rep.spnames[[i]]$matched_name
    }
  }
  rep <- rep[rep$species %in% rep.spnames.val,]
  rm(rep.spnames,rep.spnames.val)
