# Sara Williams
# 7/15/2015
# Function to extract GMT bathymetry data
################################################################################

ext_bath <- function(x = out){
					r <- raster("E:/tmp/bath/GEBCO_2014_2D_-137.4119_55.9575_-133.7019_59.403.nc", ncdf = T, stopIfNotEqualSpaced=FALSE)
					#  Create spatial xy for whale points
					proj4 <- CRS("+proj=utm +zone=8 + datum=WGS84 + ellps=WGS84") 
					
					tmp <- x %>%
								dplyr::select(x = whale_easting, y = whale_northing) %>%
								as.matrix(.)
					xy_tmp <- SpatialPoints(as.data.frame(tmp), proj4) 
					xy <- spTransform(xy_tmp, CRS("+proj=longlat + datum=WGS84 + ellps=WGS84"))
					x$bath<- raster::extract(r, xy)
					#  Extract bathymetry data from cells in 250m buffer around XY point
					x$bath_buff<- raster::extract(r, xy, buffer=1000, fun=mean)
							
				x
				}