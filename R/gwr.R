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
    #g.model[i] <- gwr(slope.sr ~ gwr.df[,i+5], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude), bandwidth = bw[i], cl = c)
}

bw_temp<-gwr.sel(slope.sr ~ gwr.df[,6], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude))
bw_topog<-gwr.sel(slope.sr ~ gwr.df[,7], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude))
bw_ndvi<-gwr.sel(slope.sr ~ gwr.df[,8], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude))
bw_pet<-gwr.sel(slope.sr ~ gwr.df[,9], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude))

g.model[1] <- gwr(slope.sr ~ gwr.df[,5], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude), bandwidth = bw[i], cl = c)
#g.model[i] <- gwr(slope.sr ~ gwr.df[,i+5], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude), bandwidth = bw[i], cl = c)
#g.model[i] <- gwr(slope.sr ~ gwr.df[,i+5], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude), bandwidth = bw[i], cl = c)
#g.model[i] <- gwr(slope.sr ~ gwr.df[,i+5], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude), bandwidth = bw[i], cl = c)


# For each class
r.classes<-vector(mode="list", length=4)
for (i in 1:4){
r.classes[[i]]<-as.data.frame(cbind("cells"=occ_classes[[i]]$cells, "slope"=rareslope[[i]]))
r.classes[[i]]<-left_join(gwr.df, r.classes[[i]], by="cells")
r.classes[[i]]<-r.classes[[i]][,c(4:9, 11)]
r.classes[[i]]<-na.exclude(r.classes[[i]])
}

bw_classes<-list(bw_temp, bw_topog, bw_ndvi, bw_pet)
bw_temp<-vector(mode="list", length=4)
bw_topog<-vector(mode="list", length=4)
bw_ndvi<-vector(mode="list", length=4)
bw_pet<-vector(mode="list", length=4)

for (j in 1:4){
    	bw_temp[j]<-gwr.sel(slope ~ temperature, data=r.classes[[j]], coords = cbind(r.classes[[j]]$longitude, r.classes[[j]]$latitude))
}

for (j in 1:4){
    	bw_topog[j]<-gwr.sel(slope ~ topography, data=r.classes[[j]], coords = cbind(r.classes[[j]]$longitude, r.classes[[j]]$latitude))
}

for (j in 1:4){
    	bw_ndvi[j]<-gwr.sel(slope ~ ndvi, data=r.classes[[j]], coords = cbind(r.classes[[j]]$longitude, r.classes[[j]]$latitude))
}

for (j in 1:4){
    	bw_pet[j]<-gwr.sel(slope ~ pet, data=r.classes[[j]], coords = cbind(r.classes[[j]]$longitude, r.classes[[j]]$latitude))
}


c<-makeCluster(37, type="FORK")

gwr_classes_temp<-vector(mode="list", length=4)
gwr_classes_topog<-vector(mode="list", length=4)
gwr_classes_ndvi<-vector(mode="list", length=4)
gwr_classes_pet<-vector(mode="list", length=4)

gwr_classes_R2<-vector(mode="list", length=4)

for (j in 1:4){
gwr_classes_temp[[j]] <- gwr(slope ~ temperature, data=r.classes[[j]], coords = cbind(r.classes[[j]]$longitude, r.classes[[j]]$latitude), bandwidth = bw_temp[[j]], cl = c)
gwr_classes_R2[[j]] <- gwr_classes_temp[[j]]$SDF$localR2
}

for (j in 1:4){
gwr_classes_topog[[j]] <- gwr(slope ~ topography, data=r.classes[[j]], coords = cbind(r.classes[[j]]$longitude, r.classes[[j]]$latitude), bandwidth = bw_topog[[j]], cl = c)
gwr_classes_R2[[j]] <- gwr_classes_topog[[j]]$SDF$localR2
}

for (j in 1:4){
gwr_classes_ndvi[[j]] <- gwr(slope ~ ndvi, data=r.classes[[j]], coords = cbind(r.classes[[j]]$longitude, r.classes[[j]]$latitude), bandwidth = bw_ndvi[[j]], cl = c)
gwr_classes_R2[[j]] <- gwr_classes_ndvi[[j]]$SDF$localR2
}

for (j in 1:4){
gwr_classes_pet[[j]] <- gwr(slope ~ pet, data=r.classes[[j]], coords = cbind(r.classes[[j]]$longitude, r.classes[[j]]$latitude), bandwidth = bw_pet[[j]], cl = c)
gwr_classes_R2[[j]] <- gwr_classes_pet[[j]]$SDF$localR2
}

gwr_classes<-list(gwr_classes_temp, gwr_classes_topog, gwr_classes_ndvi, gwr_classes_pet)

stopCluster(c)

gwr_R2_pet<-cbind(gwr_classes_R2[[1]], gwr_classes_R2[[3]], gwr_classes_R2[[3]], gwr_classes_R2[[4]])
___
Residuals
for (j in 1:4){
gwr_classes_temp[[j]] <- gwr_classes[[1]][[j]]$SDF$gwr.e
}

for (j in 1:4){
gwr_classes_topog[[j]] <- gwr_classes[[2]][[j]]$SDF$gwr.e
}

for (j in 1:4){
gwr_classes_ndvi[[j]] <- gwr_classes[[3]][[j]]$SDF$gwr.e
}

for (j in 1:4){
gwr_classes_pet[[j]] <- gwr_classes[[4]][[j]]$SDF$gwr.e
}

gwr_res_classes<-list(gwr_classes_temp, gwr_classes_topog, gwr_classes_ndvi, gwr_classes_pet)



############
# Autocorrelation
###

rn <- row.names(occ)
coords<-cbind(occ$longitude, occ$latitude)
k1 <- knn2nb(knearneigh(coords))
all.linked <- max(unlist(nbdists(k1, coords)))
col.nb.0.all <- dnearneigh(coords, 0, all.linked, row.names=rn)
summary(col.nb.0.all, coords)


library(ncf)
temp_cor <- correlog(res.df_temp$longitude, res.df_temp$latitude, res.df_temp[,3],
                    increment=2, resamp=500)


> res_df<-do.call("rbind", r.classes) #r.classes from output/results/inputetc
> head(res_df)
   longitude  latitude temperature topography ndvi  pet     slope
5  -41.09222 -3.562220         220        761  226 9009 0.9954907
22 -40.99167 -3.732220         220        783  185 8156 0.9954907
25 -40.91944 -3.825833         214        877  201 9231 0.9816105
27 -40.91139 -3.839188         218        823  201 9051 0.9891275
30 -40.89444 -3.846111         215        862  216 9578 0.9791330
39 -40.86500 -4.048610         212        904  184 9355 0.9980618
> nrow(res_df)
[1] 17494
> res_df<-cbind(res_df, gwr_classes_temp) 
> nrow(res_df)
[1] 17494
> head(res_df)
   longitude  latitude temperature topography ndvi  pet     slope res_gwr_temp
5  -41.09222 -3.562220         220        761  226 9009 0.9954907  0.003544379
22 -40.99167 -3.732220         220        783  185 8156 0.9954907  0.003958893
25 -40.91944 -3.825833         214        877  201 9231 0.9816105 -0.006946976
27 -40.91139 -3.839188         218        823  201 9051 0.9891275 -0.001234028
30 -40.89444 -3.846111         215        862  216 9578 0.9791330 -0.009908165
39 -40.86500 -4.048610         212        904  184 9355 0.9980618  0.009952751
> cor_temp<-correlog(coords=cbind(res_df$longitude, res_df$latitude), z=res_df$res_gwr_temp, method="Moran")



