library(terra)
library(geodata)

clim <- worldclim_global(var = "bio", res = 10, path = "data")
bio1 <- clim[[1]]

sa_ext <- ext(-90, -30, -60, 15)
bio1_crop <- crop(bio1, sa_ext)

plot(bio1_crop, main = "BIO1 - South America")