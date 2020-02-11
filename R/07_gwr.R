# ipak function: install and load multiple R packages.
# Check to see if packages are installed.
# Install them if they are not, then load them into the R session.
# Forked from: https://gist.github.com/stevenworthington/3178163
ipak <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)){
    install.packages(new.pkg, dependencies = TRUE)
  }
  suppressPackageStartupMessages(sapply(pkg, require, character.only = TRUE))
}

ipak(
  c("tidyverse",
    "tidylog",
    "future",
    "furrr",
    "parallel",
    "doParallel",
    "ncf",
    "sf",
    "spgwr"
  )
)

# plan
plan(multiprocess)

gwr.env<-env %>% group_by(cells) %>% summarise_all(mean, na.rm = TRUE)
gwr.df<-left_join(gwr.df,gwr.env, by = "cells")
gwr.df<-left_join(gwr.df,sr, by = "cells")
gwr.df<-as.data.frame(gwr.df)
gwr.df<-na.exclude(gwr.df)

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
g.model[i] <- gwr(slope.sr ~ gwr.df[,i+5], data=gwr.df, coords = cbind(gwr.df$longitude, gwr.df$latitude), bandwidth = bw[i], cl = c)


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


c<-makeCluster(detectCores()-1, type="FORK")

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



# Autocorrelation - authored by Karlo Guidoni Martins

## SpatialPointsDataFrame to tibble
model_data <-
  g.model %>%
  furrr::future_map(~ st_as_sf(.x))

## extract coordinates
model_coordinates <-
  g.model %>%
  furrr::future_map(~ st_as_sf(.x)) %>%
  furrr::future_map(~ st_coordinates(.x)) %>%
  furrr::future_map(~ as_tibble(.x))

## bind data and coordinates
model_table <-
  furrr::future_map2(
    .x = model_data,
    .y = model_coordinates,
    .f = bind_cols
    ) %>%
  furrr::future_map( ~select(.x, -geometry)) %>%
  furrr::future_map( ~as_tibble(.x))

## run correlogram
model_correlog <-
  model_table %>%
  furrr::future_map(
    ~ ncf::correlog(
          x = .x$X,
          y = .x$Y ,
          z = .x$localR2,  # variável de interesse
          increment = 2
        ),
    .progress = TRUE
    )

## plot correlog
model_correlog %>%
  map(~ plot(.x))
