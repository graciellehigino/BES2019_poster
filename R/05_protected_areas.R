pa1 <- readOGR("data/raw/pa-south_america/WDPA_WDOECM_Apr2021_Public_SA_shp/WDPA_WDOECM_Apr2021_Public_SA_shp_0/WDPA_WDOECM_Apr2021_Public_SA_shp-polygons.shp")
pa1 <- pa1[ma,]
pa1 <- pa1[pa1@data$REP_M_AREA==0,]

pa2 <- readOGR("data/raw/pa-south_america/WDPA_WDOECM_Apr2021_Public_SA_shp/WDPA_WDOECM_Apr2021_Public_SA_shp_1/WDPA_WDOECM_Apr2021_Public_SA_shp-polygons.shp")
pa2 <- pa2[ma,]
pa2 <- pa2[pa2@data$REP_M_AREA==0,]

pa3 <- readOGR("data/raw/pa-south_america/WDPA_WDOECM_Apr2021_Public_SA_shp/WDPA_WDOECM_Apr2021_Public_SA_shp_2/WDPA_WDOECM_Apr2021_Public_SA_shp-polygons.shp")
pa3 <- pa3[ma,]
pa3 <- pa3[pa3@data$REP_M_AREA==0,]

pa <- raster::bind(pa1, pa2, pa3)
rm(pa1, pa2, pa3)

r <- raster(ext=extent(ma), resolution=0.009)
pa_raster <- rasterize(pa, r)

# Distance from PA------
