library(spgwr)
library(parallel)

gwr.env<-env %>% group_by(cells) %>% summarise_all(list(mean))
gwr.df<-left_join(gwr.df,gwr.env, by = "cells")
gwr.df<-left_join(gwr.df,sr, by = "cells")
gwr.df<-as.data.frame(gwr.df)
save(gwr.df, file="output/results/df_by_cell.Rdata")

g <- gwr.sel(gwr.df$slope.sr ~ gwr.df$topography, gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude), gweight = gwr.Gauss(), method = "cv", adapt = TRUE)
c <- makeCluster(20, type="FORK")
g.model <- gwr(gwr.df$slope.sr ~ gwr.df$topography, gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude), longlat = TRUE, bandwidth = g, gweight = gwr.Gauss(), method = "cv", cl = c)
