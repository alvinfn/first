library(rgdal);
library(bigdata);
library(biganalytics);
library(raster);
library(sp)

data <- brick('2001_Jawa.tif');
data <- as.matrix(data);