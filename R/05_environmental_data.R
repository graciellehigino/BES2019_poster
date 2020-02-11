# Download data
## NDVI -
download.file("https://neo.sci.gsfc.nasa.gov/servlet/RenderData?si=1780053&cs=gs&format=TIFF&width=3600&height=1800", mode="wb", destfile = "data/raw/ndvi.tiff")
ndvi <- raster("data/raw/ndvi.tiff")
  # Set equal resolutions and extentions
  ndvi <- disaggregate(ndvi, fact=12)
  # Crop
  ndvi <- crop(ndvi, extent(ma))

## PET -  Trabucco, Antonio; Zomer, Robert (2019): Global Aridity Index and Potential Evapotranspiration (ET0) Climate Database v2. figshare. Fileset. https://doi.org/10.6084/m9.figshare.7504448.v3

download.file("https://ndownloader.figshare.com/files/14118800", mode ="wb",destfile = "data/raw/pet.zip")
unzip("data/raw/pet.zip", exdir = "data/raw")
pet <- raster("data/raw/ai_et0/ai_et0.tif")
pet <- crop(pet, extent(ma))

## Temperature - WorldClim (bioclim 01)
temper1 <- getData(name = 'worldclim', var='bio', download = TRUE, path = "data/raw",
                   lat = -25, lon = -60, res=0.5)[[1]]
temper2 <- getData(name = 'worldclim', var='bio', download = TRUE, path = "data/raw",
                   lat = -60, lon = -60, res=0.5)[[1]]
temper <- mosaic(temper1, temper2, fun=mean)
rm(temper1, temper2)
temper <- crop(temper, extent(ma))

## Topography - WorldClim
topog <-  getData(name = 'alt', country="Brazil", download = TRUE, path = "data/raw",mask=FALSE)
topog <- crop(topog, extent(ma))



# Get values for each cell and build df of environmental variable

ind <- rbind(amp[1:2], aves[1:2], mam[1:2], rep[1:2])
cells<-cellFromXY(pet, ind) # Get occurrence cells from raster

## Get variables from raster
temp.p<-raster::extract(temper,ind, "simple")
topog.p<-raster::extract(topog,ind, "simple")
ndvi.p<-raster::extract(ndvi, ind, "simple")
pet.p<-raster::extract(pet, ind,"simple")

## Build dfs
### environmental variables
env <- cbind(cells, ind, temp.p, topog.p, ndvi.p, pet.p)
colnames(env) <- c("cells", "longitude", "latitude", "temperature", "topography", "ndvi", "pet")
