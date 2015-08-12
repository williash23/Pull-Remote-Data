# Sara Williams
# 7/8/2015
# Analysis script to obtain MUR SST and chlorophyll-a data for whale observations
################################################################################
		#  Load packages
		require(ncdf4)
		require(R.utils)
		require(sp)
		library(dplyr)
		require(raster)
		library(rgdal)
		library(rgeos)
		
################################################################################		
		#  MUR SST (download, crop and extract)
		#  Read in whale observation location data
		whale <- read.csv("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/data/Whale_Pts.csv")
		out <- whale %>%
				mutate(sst_fn = paste(DateTxt, ".nc", sep=""))	
				
		#  Source MUR_SST_dload_funs
		source(file.path("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/MUR_SST_dload_funs.R"))
			
		#  Raster processing: download MUR SST data and crop to extent of study area (Project not needed for these data files)
			out %>% 
				distinct(Event_Date)%>%
				rowwise() %>%
				do(dload_fun(.)) 
				
		#  Extract values
			out %>%
				group_by(sst_fn) %>%
				do(ext_sst(.)) %>%
				as.data.frame(.)

################################################################################	
		#  GMT bathymetry (extract values only)
		#  Read in whale observation location data
		whale <- read.csv("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/data/Whale_Pts_SST.csv")
		out <- whale
	
		#  Source GMT_bathymetry_extact_fun
		source(file.path("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/GMT_bathymetry_ext_fun.R"))
		
		#  Extract values
			out %>%
				do(ext_bath(.)) %>%
				as.data.frame(.)				

################################################################################		
		#  MODIS chlorophyll-a: 4km, monthly composite (crop and extract)
		#  Read in whale observation location data
		whale <- read.csv("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/data/Whale_Pts.csv")
		out <- whale %>%
				mutate(chlor_fn = paste(DateTxt, ".img", sep=""))	
				
		#  Source MODIS_chlor_ext_funs
		source(file.path("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/MODIS_chlor_ext_funs.R"))
							
				