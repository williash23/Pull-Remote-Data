# Sara Williams
# 7/8/2015
# Functions to crop and extract MODIS chlorophyll-A 4km data. 
################################################################################

#  1 month temporal resolution

#  Download of raw monthly Chlor MODIS data 
#   done in ArcMap using Marine Geospatial Ecology Tools toolbox.
#   File were re-named manually. 
#   New naming convention is YYYYJulian Day to start date. E.g. 2008121.img 
#   This file would be the 8day chlor-a for 2008121 to 2008128.


crop_fun <-function(x = out){
				#  Create raster, crop to study area extent and write over the previous .nc file.					
				r <- raster(paste("E:/tmp/chlor_a", x$chlor_fn[1], sep="/"), ncdf=F, stopifNotEqualSpaced=FALSE)
				e <- extent(-137.5, -134.0, 56.5, 59.5)
				r <- crop(r, e, filename = (paste("E:/tmp/chlor_crop", x$chlor_fn[1], sep="/")), overwrite=T)
		}
		
ext_chlor <- function(x = out){
					r <- raster(paste("E:/tmp/chlor_crop", x$chlor_fn[1], sep="/"), ncdf=F, stopifNotEqualSpaced=FALSE)
					#  Create spatial xy for whale points
					proj4 <- CRS("+proj=utm +zone=8 + datum=WGS84 + ellps=WGS84") 
					
					tmp <- x %>%
								dplyr::select(x = whale_easting, y = whale_northing) %>%
								as.matrix(.)
					xy_tmp <- SpatialPoints(as.data.frame(tmp), proj4) 
					xy <- spTransform(xy_tmp, CRS("+proj=longlat + datum=WGS84 + ellps=WGS84"))
					x$chlor_a<- raster::extract(r, xy)				
		
				x
				}

################################################################################
				
#  Annual temporal resolution

#  Download of raw monthly Chlor MODIS data 
#   done in ArcMap using Marine Geospatial Ecology Tools toolbox.
#   File were re-named manually. 
#   New naming convention is YYYY

crop_fun <-function(x = out){
				#  Create raster, crop to study area extent and write over the previous .nc file.					
				r <- raster(paste("E:/tmp/chlor_a_ann", x$chlor_ann_fn[1], sep="/"), ncdf=F, stopifNotEqualSpaced=FALSE)
				e <- extent(-137.5, -134.0, 56.5, 59.5)
				r <- crop(r, e, filename = (paste("E:/tmp/chlor_ann_crop", x$chlor_ann_fn[1], sep="/")), overwrite=T)
		}
		
ext_chlor <- function(x = out){
					r <- raster(paste("E:/tmp/chlor_ann_crop", x$chlor_ann_fn[1], sep="/"), ncdf=F, stopifNotEqualSpaced=FALSE)
					#  Create spatial xy for whale points
					proj4 <- CRS("+proj=utm +zone=8 + datum=WGS84 + ellps=WGS84") 
					
					tmp <- x %>%
								dplyr::select(x = whale_easting, y = whale_northing) %>%
								as.matrix(.)
					xy_tmp <- SpatialPoints(as.data.frame(tmp), proj4) 
					xy <- spTransform(xy_tmp, CRS("+proj=longlat + datum=WGS84 + ellps=WGS84"))
					x$chlor_a_ann<- raster::extract(r, xy)				
		
				x
				}
				
################################################################################
#  8 day temporal resolution

#  Download of raw 8d Chlor MODIS data (e.g., (L3m_8D_chl_chlor_a_4km.img)) 
#   done in ArcMap using Marine Geospatial Ecology Tools toolbox.
#   File names were then re-written using Bulk Rename Utility.
#   New naming convention is YYYYJulian Day fo start date. E.g. 2008121.img 
#   This file would be the 8day chlor-a for 2008121 to 2008128.

# crop_fun <-function(x = out){
				# #  Create raster, crop to study area extent and write over the previous .nc file.					
				# r <- raster(paste("E:/tmp/chlor_8day", x$chlor_8day_fn[1], sep="/"), ncdf=F, stopifNotEqualSpaced=FALSE)
				# e <- extent(-137.5, -134.0, 56.5, 59.5)
				# r <- crop(r, e, filename = (paste("E:/tmp/chlor_8day", x$chlor_8day_fn[1], sep="/")), overwrite=T)
		# }

		
# ext_chlor <- function(x = out){
					# r <- raster(paste("E:/tmp/chlor_8day", x$chlor_8day_fn[1], sep="/"), ncdf=F, stopifNotEqualSpaced=FALSE)
					# #  Create spatial xy for whale points
					# proj4 <- CRS("+proj=utm +zone=8 + datum=WGS84 + ellps=WGS84") 
					
					# tmp <- x %>%
								# dplyr::select(x = whale_easting, y = whale_northing) %>%
								# as.matrix(.)
					# xy_tmp <- SpatialPoints(as.data.frame(tmp), proj4) 
					# xy <- spTransform(xy_tmp, CRS("+proj=longlat + datum=WGS84 + ellps=WGS84"))
					# x$chlor_8day <- raster::extract(r, xy)				
		
				# x
				# }
				
