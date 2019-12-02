library(spgwr)
library(parallel)

gwr.env<-env %>% group_by(cells) %>% summarise_all(mean, na.rm = TRUE)
gwr.df<-left_join(gwr.df,gwr.env, by = "cells")
gwr.df<-left_join(gwr.df,sr, by = "cells")
gwr.df<-as.data.frame(gwr.df)
gwr.df<-na.exclude(gwr.df)
save(gwr.df, file="output/results/df_by_cell.Rdata")

# For total species richness
bw<-vector(length=4)
g.model<-vector(length=4)
for (i in 1:16){
    bw[i]<-gwr.sel(slope.sr ~ gwr.df[,i+5], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude))
    g.model[i] <- gwr(slope.sr ~ gwr.df[,i+5], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude), bandwidth = bw[i], cl = c)
}


# For each class
r.classes<-vector(mode="list", length=4)
for (i in 1:4){
r.classes[[i]]<-as.data.frame(cbind("cells"=occ_classes[[i]]$cells, "slope"=rareslope[[i]]))
r.classes[[i]]<-left_join(gwr.df, r.classes[[i]], by="cells")
r.classes[[i]]<-r.classes[[i]][,c(4:9, 11)]
r.classes[[i]]<-na.exclude(r.classes[[i]])
}

c<-makeCluster(37, type="FORK")

bw.classes<-vector(length = 16)

for (i in 1:16){
for (j in 1:4){
for (k in 3:6){
    	bw.classes[i]<-gwr.sel(r.classes[[j]]$slope ~ r.classes[[j]][[k]], data=r.classes[[j]], coords = cbind(r.classes[[j]]$longitude, r.classes[[j]]$latitude))
}}}

g_model_classes<-vector(mode="list", length=16)
res_gwr<-vector(mode="list", length=16)
for (i in 1:length(g_model_classes)){
for (j in 1:4){
for (k in 3:6){
res_gwr[[i]] <- gwr(r.classes[[j]]$slope ~ r.classes[[j]][[k]], data=r.classes[[j]], coords = cbind(r.classes[[j]]$longitude, r.classes[[i]]$latitude), bandwidth = bw.classes[i], cl = c)
g_model_classes[[i]] <- res_gwr[[i]]$SDF$localR2
}
}
}

