# Sara Williams
# 7/8/2015
# Functions to project, crop and extract MODIS chlorophyll-A 4km data
################################################################################

dload_fun <-	function(x = out){
		
				
				#  Create raster, crop to study area extent and write over the previous .nc file.					
				r <- raster("E:/tmp/chlor/a20081212008128.L3m_8D_chl_chlor_a_4km.img")
				e <- extent(-137.5, -134.0, 56.5, 59.5)
				r <- crop(r, e, filename = "E:/tmp/chlor/a20081212008128.L3m_8D_chl_chlor_a_4km.img", overwrite=T)
		}


# proj_fun <- function()
# proj_fun not needed for these rasters	

# crop_fun is embedded in the dload_fun to crop is done immediately and saves space on hard drive
# crop_fun <- function(x = out){
				# r <- raster(paste("F:/tmp/sst", x$sst_fn[1], sep="/"), ncdf = T, stopIfNotEqualSpaced=FALSE)
				# e <- extent(-137.5, -134.0, 56.5, 59.5)
				# r <- crop(r, e, filename = (paste("F:/tmp/sst", x$sst_fn[1], sep="/")), overwrite=T)
				# }

		
ext_chlor <- function(x = out){
					r <- raster(paste("F:/tmp/sst", x$sst_fn[1], sep="/"), ncdf = T, stopIfNotEqualSpaced=FALSE)
					#  Create spatial xy for whale points
					proj4 <- CRS("+proj=utm +zone=8 + datum=WGS84 + ellps=WGS84") 
					
					tmp <- x %>%
								dplyr::select(x = whale_easting, y = whale_northing) %>%
								as.matrix(.)
					xy_tmp <- SpatialPoints(as.data.frame(tmp), proj4) 
					xy <- spTransform(xy_tmp, CRS("+proj=longlat + datum=WGS84 + ellps=WGS84"))
					x$sst <- raster::extract(r, xy)				
		
				x
				}
				
				
# process_wrap <- funtion(x){			
							# dload_fun(x)
							# #p <- proj_fun(x$sst_fn)
							# #cr <- crop_fun(x$sst_fn)
						# }				
				