library(pgirmess)
library(parallel)
load("output/results/df_by_cell.Rdata")
load("output/results/gwr_results.Rdata")

moran_list<-vector(mode="list", length=4)

for (i in 1:4){
moran_R2[[i]]<-pgirmess::correlog(coord=gwr.df[,4:5], z=gwr_R2[[i]], method="Moran", zero.policy=T)
}

