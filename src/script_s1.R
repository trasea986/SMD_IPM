##Landscape metrics analysis on 2019 insect survey fields in Palouse area ##############

library(raster)              
library(sf)                  
library(dplyr)                
library(rgdal)
library(sp)
library(CropScapeR) #####to directly extract CropScape data, but there are other ways too to get this data ###########
library(ggplot2)
library(gdalUtils)
library(tidyverse)
library(maptools)
library(landscapemetrics)  ## now using this R package to extract buffers around the points

cdl_ID.WA.19 = raster("./data/CDL_2019_clip_20220114204134_1215990682.tif") ## raster file (attached)
plot(cdl_ID.WA.19)

coord.19 <- read.csv(file="./data/2019_coordinates.csv", stringsAsFactors = FALSE) ## sample points in CSV (attached)
str(coord.19)
coordinates(coord.19) <- ~X+Y
projection(coord.19) <- CRS('+proj=longlat +datum=WGS84')
#reproject to the CRS of raster image
points_final <- spTransform(coord.19, crs(cdl_ID.WA.19))
#plotting
plot(cdl_ID.WA.19)
points(points_final, pch = 1, col = "blue", cex = 1) ####gives the map with points overlayed (map pasted below)

#reproject layers and points
#set projection as USA Contiguous Albers Equal Area Conic
projection <- "ESRI:102003"
points_final <- spTransform(points_final, projection)
cdl_ID.WA.19 <- projectRaster(cdl_ID.WA.19, crs = projection, method = "ngb")

#plotting to check reprojection
plot(cdl_ID.WA.19)
points(points_final, pch = 1, col = "blue", cex = 1)

#added progress, reduced size
sampled_area <- sample_lsm(cdl_ID.WA.19, y = points_final, size = 500, shape = "circle", what = "lsm_l_shdi", progress = TRUE)
