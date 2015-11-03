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
		whale <- read.csv("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/data/Whale_Pts_SST_bath_buff.csv")
		out <- whale %>%
				mutate(chlor_fn = paste(Year, "_", month, ".img", sep=""))	
						
		#  Source MODIS_chlor_ext_funs
		#   Need functions either for monthly or annual temporal resolution!!!!!
		source(file.path("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/MODIS_chlor_ext_funs.R"))
					
		#  Raster processing: crop to extent of study area (Projection not needed for these data files)
			out %>% 
					distinct(chlor_fn)%>%
					rowwise() %>%
					do(crop_fun(.)) 
				
		#  Extract values
		out %>%
				group_by(chlor_fn) %>%
				do(ext_chlor(.)) %>%
				as.data.frame(.)
				
		################################################################################	
		#  MODIS chlorophyll-a: 4km, annual composite (crop and extract)

		#  Read in whale observation location data
		whale <- read.csv("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/data/Whale_Pts_SST_bath_buff_chlor_month.csv")
		out <- whale %>%
				mutate(chlor_ann_fn = paste(Year, ".img", sep=""))	
						
		#  Source MODIS_chlor_ext_funs
		source(file.path("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/MODIS_chlor_ext_funs.R"))
					
		#  Raster processing: crop to extent of study area (Projection not needed for these data files)
			out %>% 
					distinct(chlor_ann_fn)%>%
					rowwise() %>%
					do(crop_fun(.)) 
				
		#  Extract values
			chlor <- out %>%
				group_by(chlor_ann_fn) %>%
				do(ext_chlor(.)) %>%
				as.data.frame(.)
		
		################################################################################
		# #  The code below was for processing chlor_a_8day temporal resolution data. This is no longer
		# #   needed because went with chor_a_ann temporal resulation data (annual aggregate)
		
		# # #  To select chlor data file that is closest to whale sighting event date...
		# # #   First get just names of files (which are the julian days) from the files themselves
		# # dat <- read.csv("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/data/chlor_8d_dat.csv")
		# # whale <- read.csv("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/data/Whale_Pts_SST_bath_buff.csv")
		# # chlor_8day_fn <- unique(dat[,1])
		# # Julian_DateTxt <- unique(whale$Julian_DateTxt)

		# # #  Find closest matching start date of chlor data file to whale sighting event date and
		# # #   determine the row index for each chlor file that is needed.
		# # findit <-  function(x,vec){
			# # y <- abs(x - vec)
			# # which.min(y)
			# # }
		# # needed_chlor_rows <- sapply(Julian_DateTxt, findit, chlor_8day_fn)

		# # #  Select only the chlor file names identified by function above.
		# # chlor_8day_fn <- as.data.frame(chlor_8day_fn)
		# # tmp <- chlor_8day_fn[needed_chlor_rows,]
		# # chlor_8day <- as.data.frame(cbind(tmp, Julian_DateTxt))
						
		# # #  Read in whale observation location data
		# # whale <- read.csv("C:/Users/sara.williams/Documents/GitHub/Pull-Remote-Data/data/Whale_Pts_SST_bath_buff.csv")
		# # out <-left_join(chlor_8day, whale, by = "Julian_DateTxt")
		# # names(out)[1]<-"chlor_8day_fn"
		# # out <- mutate(out, chlor_8day_fn = paste(chlor_8day_fn, ".img", sep=""))
		################################################################################
		
		