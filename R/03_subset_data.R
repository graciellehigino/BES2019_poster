# Download Atlantic Rainforest shapefile
unzip(curl::curl_download("https://c402277.ssl.cf1.rackcdn.com/publications/15/files/original/official_teow.zip?1349272619", destfile = "data/raw/ecoregion.zip"), exdir = "data/raw")

ma<-readOGR("data/raw/official/wwf_terr_ecos.shp")
ma<-ma[ma$G200_REGIO %in% c("Atlantic Forests", "Atlantic dry Forests"),]

# Subset occurrences that are inside AR shapefile

## check for NAs and drop them
amp <- na.exclude(amp)
aves <- na.exclude(aves)
mam <- na.exclude(mam)
rep <- na.exclude(rep)

## Set coordinates

groups <- list(amp, aves, mam, rep)
ovr <- list(length(groups))
rm(amp, aves, mam, rep)
names(groups) <- c("amp", "aves", "mam", "rep")
for (i in 1:4) {
  coordinates(groups[[i]]) <- ~longitude+latitude
  crs(groups[[i]]) <- crs(ma)
  ovr[[i]] <- over(groups[[i]],ma)
  groups[[i]] <- cbind(groups[[i]]@coords, groups[[i]]@data, ovr[[i]])
  groups[[i]] <- groups[[i]][!is.na(groups[[i]]$G200_REGIO),]
}
list2env(groups, .GlobalEnv)
rm(groups)
