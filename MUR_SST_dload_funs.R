# Sara Williams
# 7/8/2015
# Functions to download, project, crop and extract MUR SST data
################################################################################

dload_fun <-	function(x = out){
		
					#  To get names of files needed for each unique date whales were observed over the 2008-2014 study period...
						Year <- x$Year		
						JulianDay <- x$JulianDay
						DateTxt <- x$DateTxt
				
					file_name <- paste("ftp://podaac-ftp.jpl.nasa.gov/allData/ghrsst/data/L4/GLOB/JPL/MUR", 
											"/",
											Year, 
											"/",
											JulianDay,
											"/",
											DateTxt,
											"-",
											"JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2",
											sep="")
								
					destname <- paste(paste("F:/tmp/sst",
											"/",
											DateTxt,
											".nc",
											sep=""))			
									
				#  Download binary data - "wb"
					download.file(file_name, 
										destfile = "F:/tmp/sst_tmp.nc.bz2", 
										mode = "wb")
			
				#  Unzip file, sst_tmp becomes sst
					bunzip2("F:/tmp/sst_tmp.nc.bz2", 
									destname, 
									overwrite = T)
									
				#  Create raster, crop to study area extent and write over the previous .nc file.					
				r <- raster(paste("F:/tmp/sst", x$sst_fn[1], sep="/"), ncdf = T, stopIfNotEqualSpaced=FALSE)
				e <- extent(-137.5, -134.0, 56.5, 59.5)
				r <- crop(r, e, filename = (paste("F:/tmp/sst", x$sst_fn[1], sep="/")), overwrite=T)
		}

		
ext_sst <- function(x = out){
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
				