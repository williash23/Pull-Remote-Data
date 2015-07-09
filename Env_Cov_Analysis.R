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
		
		#  Read in whale observation location data
		whale <- read.csv("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/data/Whale_Pts.csv")
			
		#  Source MUR_SST_dload_funs
		source(file.path("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/MUR_SST_dload_funs.R"))
			
		#  Raster processing: download MUR SST data (Project and crop and crop not needed for these data files)
			whale %>% 
				distinct(Event_Date)%>%
				rowwise() %>%
				do(dload_fun(.)) %>%
				do(crop_fun(.)) 
				
		#  Extract values
			out <- whale %>%
						mutate(sst_fn = paste(DateTxt, ".nc", sep="")) %>%
						group_by(sst_fn) %>%
						do(ext_sst(.)) %>%
						as.data.frame(.)
		
	
	
