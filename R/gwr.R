library(spgwr)
library(parallel)

gwr.env<-env %>% group_by(cells) %>% summarise_all(mean, na.rm = TRUE)
gwr.df<-left_join(gwr.df,gwr.env, by = "cells")
gwr.df<-left_join(gwr.df,sr, by = "cells")
gwr.df<-as.data.frame(gwr.df)
gwr.df<-na.exclude(gwr.df)
save(gwr.df, file="output/results/df_by_cell.Rdata")

bw <- gwr.sel(slope.sr ~ temperature, data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude))
c <- makeCluster(20, type="FORK")
clusterEvalQ(c, library(spgwr))
xy<-cbind(gwr.df$longitude, gwr.df$latitude)
g.model <- gwr(slope.sr ~ temperature, data=gwr.df, coords = xy, bandwidth = bw, cl = c)

bw<-vector(length=4)
g.model<-vector(length=4)
for (i in 1:4){
    bw[i]<-gwr.sel(slope.sr ~ gwr.df[,i+5], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude))
    g.model[i] <- gwr(slope.sr ~ gwr.df[,i+5], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude), bandwidth = bw[i], cl = c)
}
