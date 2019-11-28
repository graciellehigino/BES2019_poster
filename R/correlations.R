### Assessing correlations between inventory completeness and environmental variables

data8<-list()
for (i in 1:4){
  data8[[i]]<-cbind(sr_classes[[i]],rareslope[[i]])
  data8[[i]]<-dplyr::full_join(data8[[i]],data6[,c(3,58:61)],by="cells",all=TRUE)
}

### Correlation tests
## All cells
# For each class
cor.class.temperature<-vector(mode="list", length=4)
for (i in 1:4){
    cor.class.temperature[[i]]<-cor.test(gwr.df$temperature[gwr.df$cells %in% occ_classes[[i]]$cells],rareslope[[i]], method="kendall")
}

cor.class.topography<-vector(mode="list", length=4)
for (i in 1:4){
cor.class.topography[[i]]<-cor.test(gwr.df$topography[gwr.df$cells %in% occ_classes[[i]]$cells],rareslope[[i]], method="kendall")
}

cor.class.ndvi<-vector(mode="list", length=4)
for (i in 1:4){
cor.class.ndvi[[i]]<-cor.test(gwr.df$ndvi[gwr.df$cells %in% occ_classes[[i]]$cells],rareslope[[i]], method="kendall")
}

cor.class.pet<-vector(mode="list", length=4)
for (i in 1:4){
cor.class.pet[[i]]<-cor.test(gwr.df$pet[gwr.df$cells %in% occ_classes[[i]]$cells],rareslope[[i]], method="kendall")
}

p.value<-vector(length=4)
estimate<-vector(length=4)
truncated<-vector(length=4)
for (i in 1:4){
 p.value[i]<- cor.class.topog[[i]]$p.value
 estimate[i]<-cor.class.topog[[i]]$estimate
 if (p.value[i]<0.05){truncated[i] <- -9999} else {truncated[i]<-estimate[i]}
}

cor.pet<-as.data.frame(cbind("p.value" = p.value, "estimate" = estimate))

cor.class.estimates<-rbind("temp" = cor.temperature$estimate, "topog" = cor.topography$estimate, "ndvi" = cor.ndvi$estimate, "pet" = cor.pet$estimate)
colnames(cor.class.estimates)<- c("amp", "aves", "mam", "rep")

cor.class.pvalue<-rbind(cor.temperature$pvalue, cor.topography$pvalue, cor.ndvi$pvalue, cor.pet$pvalue)

cor.class.trunc<-rbind(truncated.temp, truncated.topog, truncated.ndvi, truncated.pet)
colnames(cor.class.trunc)<-c("amp", "aves", "mam", "rep")

plot(raster(cor.class.trunc), col = gray((1:4)/6), frame.plot=FALSE, axes=FALSE, box=FALSE)



# For the total richness
a<-cbind(tot,slope.sr)
a<-dplyr::full_join(a,data6[,c(3,58:61)],by="cells",all=TRUE)
slope.temp<-cor.test(a[,4],a[,5],method="pearson")
slope.alt<-cor.test(a[,4],a[,6],method="pearson")
slope.ndvi<-cor.test(a[,4],a[,7],method="pearson")
slope.pet<-cor.test(a[,4],a[,8],method="pearson")

# For the total observations
cor.test(a[,2],a[,5],method="pearson")
cor.test(a[,2],a[,6],method="pearson")
cor.test(a[,2],a[,7],method="pearson")
cor.test(a[,2],a[,8],method="pearson")

## Only well-sampled cells
# Aves
wsu.aves<-subset(data8[[4]],data8[[4]][,3]<=0.05)
cor.wsu.aves<-list(
  wsu.aves.temp<-cor.test(wsu.aves[,3],wsu.aves[,4]),
  wsu.aves.alt<-cor.test(wsu.aves[,3],wsu.aves[,5]),
  wsu.aves.ndvi<-cor.test(wsu.aves[,3],wsu.aves[,6]),
  wsu.aves.pet<-cor.test(wsu.aves[,3],wsu.aves[,7])
)

# Total richness
wsu.tot<-subset(a,a[,4]<=0.05)
cor.wsu.tot<-list(
  wsu.tot.r<-list(
cor.test(wsu.tot[,3],wsu.tot[,5]),
cor.test(wsu.tot[,3],wsu.tot[,6]),
cor.test(wsu.tot[,3],wsu.tot[,7]),
cor.test(wsu.tot[,3],wsu.tot[,8])),

# Total observations
  wsu.tot.obs<-list(
cor.test(wsu.tot[,2],wsu.tot[,5]),
cor.test(wsu.tot[,2],wsu.tot[,6]),
cor.test(wsu.tot[,2],wsu.tot[,7]),
cor.test(wsu.tot[,2],wsu.tot[,8])))
