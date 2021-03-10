## Amphibia
amp <- amp_dp %>% select(latitude,longitude,species)
rm(amp_dp)


## Aves
ave <- birds_dp %>% select(Latitude_y,Longitude_x,Species)
colnames(ave) <- c("latitude", "longitude", "species")
rm(birds_dp)

## Mammals
subsetting <- function(dataset){
  select(dataset, contains("lat"), contains("long"), contains("sp"))
}
mam <- list(bat_dp,mamprim_dp,mamsmall_dp,mamsmall2_dp)
for (i in mam){
  mam <- lapply(mam, subsetting)
  rm(bat_dp,mamprim_dp,mamsmall_dp,mamsmall2_dp)
}

# Select only columns for lat, long and species name
mam[[2]] <- mam[[2]][,1:3]
mam[[3]] <- as.data.frame(mam[[3]][,c(1,2,4)])
mam[[4]] <- mam[[4]][,c(1,2,4)]
mam[[5]] <- mamct_dp[,c(7,6,36)]
rm(mamct_dp)



# Standardazing colnames
for (i in 1:5) {
  colnames(mam[[i]]) <- c("latitude", "longitude", "species")
}

mam <- lapply(mam, function(df) mutate_at(df, .vars = 1:2, as.numeric))

# Merging
mam <- bind_rows(mam)

## iDigBio
idigbio <- idigbio %>%
    rename(latitude = dwc.decimalLatitude,
           longitude = dwc.decimalLongitude,
           class = dwc.classs,
           species = dwc.scientificName) %>%
    select(class, species, latitude, longitude) %>%
    drop_na() %>%
    group_by(species) %>%
    distinct(latitude, longitude, .keep_all = TRUE) %>%
    ungroup()

  # Resolving sci. names
  # Data Sources IDs:
  # 173 = The Reptile Database
  # 3 = ITIS
  # 4 = NCBI
  # 11 = GBIF
  # 174 = Mammal Species of the World
  # 175 = BirdLife International

idb_spnames <- parLapply(c, as.character(idigbio$species), gnr_resolve,
                         data_source_ids=c(173,3,4,11,174,175),
                         resolve_once=FALSE,
                         with_context=FALSE,canonical=FALSE,highestscore=TRUE,
                         best_match_only=TRUE,http="post",splitby=50,cap_first=TRUE,
                         fields = "minimal")

  sp.val <- vector(length = length(idb_spnames))
  for (i in 1:length(idb_spnames)){
    if (length(idb_spnames[i][[1]]>0)){
      sp.val[i] <- idb_spnames[[i]]$matched_name
    }
  }

  # Getting classes of species
  classif <- parLapply(c, sp.val,
          classification, db="gbif", rows=1)

  classes = as.data.frame(matrix(NA, length(classif),1))
  names(classes) = "Class"
  for (i in 1:length(classif)) {
    if(!is.na(names(classif[[i]])) & !is.na(classif[[i]])) {
      class = unname(classif[[i]])[[1]] %>% filter(rank == "class")
       if(nrow(class) != 0) {
         classes[i,] = class %>% select("name")
       }
    }
  }


  idigbio$class <- classes$Class # replace class column with new variable
  #levels(idigbio$class)
  idigbio <- filter(idigbio, class %in% c("Aves", "Amphibia", "Mammalia", "Reptilia")) # Exclude occurrences due to misclassification and invalid names

  idigbio_classes <- split(idigbio, idigbio$class)
  list2env(idigbio_classes, .GlobalEnv) #split df into classes


  aves <- rbind(ave, Aves[2:4])
  amp <- rbind(amp, Amphibia[2:4])
  mam <- rbind(mam, Mammalia[2:4])
  rep <- Reptilia
  rm(ave, Aves, Amphibia, Mammalia, Reptilia)


# GBIF
gbif <-
  gbif %>%
    rename(
      latitude = decimalLatitude,
      longitude = decimalLongitude,
      sp = scientificName
    ) %>%
    select(class, sp, latitude, longitude) %>%
    drop_na() %>%
    group_by(sp) %>%
    distinct(latitude, longitude, .keep_all = TRUE) %>%
    ungroup()
rename(gbif, species = sp)

gbif_classes <- split(gbif, gbif$class)
list2env(gbif_classes, .GlobalEnv)


  aves <- rbind(aves, Aves[2:4])
  amp <- rbind(amp, Amphibia[2:4])
  mam <- rbind(mam, Mammalia[2:4])
  rep <- rbind(rep[2:4], Reptilia[2:4])
  rm(Aves, Amphibia, Mammalia, Reptilia)
