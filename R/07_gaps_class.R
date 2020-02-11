library(vegan)
library(sqldf)

## List of datasets by class
classes<-split(occ, occ$source)
for (i in 1:length(classes)) {
      classes[[i]]<-select(classes[[i]], cells, longitude, latitude, species)
}

# Species richness by class and by cell
f<-function (x) {
  sqldf("select cells, count (distinct species) as N_sp from x group by cells")
}
sr_classes<-lapply(classes, f)

# Occurrences by class and by cell
g<-function (x) {
  x$abundance<-1
  x$abundance<-as.integer(x$abundance)
  sqldf("select cells, count(species) as N_rec from x group by cells having count(species) > 0")
}
occ_classes<-lapply(classes,g)

# Digital knowledge for each cell by class
#exp.rich<-list()
rareslope<-list()
for (i in 1:4) {
  #exp.rich[[i]]<-rarefy(sr_classes[[i]]$N_sp,occ_classes[[i]]$N_rec)
  rareslope[[i]]<-rareslope(sr_classes[[i]]$N_sp,occ_classes[[i]]$N_rec)
}

rm(f,g,i)

# Digital knowledge for each class in all Atlantic Forest
dk_classes<-list()
class_mat<-list()
for (i in 1:length(classes)){
    dk_classes[[i]]<-merge(sr_classes[[i]], occ_classes[[i]],by="cells",all=TRUE)
    dk_classes[[i]]<-merge(classes[[i]],dk_classes[[i]],by="cells",all=TRUE)
    dk_classes[[i]]$abundance<-1
    dk_classes[[i]]$abundance<-as.integer(dk_classes[[i]]$abundance)
    dk_classes[[i]]<-select(dk_classes[[i]], "cells", "species", "abundance")
    class_mat[[i]]<-spaa::data2mat(dk_classes[[i]])}


# Get the last 10% of the accumulation curve slope
c <- makeCluster(15, type="FORK")
spaccum_classes <- parLapply(c, class_mat, specaccum, method = "exact")

specslope_classes<-vector(mode="list", length=length(spaccum_classes))
for (i in 1:length(spaccum_classes)){
specslope_classes[[i]]<-(spaccum_classes[[i]]$richness[length(spaccum_classes[[i]]$richness)]-spaccum_classes[[i]]$richness[ceiling(length(spaccum_classes[[i]]$richness)*0.9)])/(length(spaccum_classes[[i]]$richness)-ceiling(length(spaccum_classes[[i]]$richness)*0.9))
}
