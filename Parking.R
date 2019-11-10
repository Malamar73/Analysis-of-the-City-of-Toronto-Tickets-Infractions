library("readtext")
library("sqldf")
library(lubridate)
library(forcats)
library(raster)
library(rgdal)     # R wrapper around GDAL/OGR
library(ggplot2)   # for general plotting
library(ggmap)    # for fortifying shapefiles
library(ggrepel)
library(RJSONIO)
library(RCurl)
library(geosphere)
library(zoo)

register_google(key = "")
temp <- tempfile()

download.file("http://opendata.toronto.ca/revenue/parking/ticket/parking_tickets_2008.zip",temp)
P2008<-(read.csv(unzip(temp), fileEncoding = "UTF-16", quote = "",    stringsAsFactors = FALSE))

download.file("http://opendata.toronto.ca/revenue/parking/ticket/parking_tickets_2009.zip",temp)
P2009<-(read.csv(unzip(temp),  stringsAsFactors = FALSE, quote = ""))

download.file("http://opendata.toronto.ca/revenue/parking/ticket/parking_tickets_2010.zip",temp)
P2010<-(read.csv(unzip(temp), fileEncoding = "UTF-16", quote = "",    stringsAsFactors = FALSE))

download.file("http://opendata.toronto.ca/revenue/parking/ticket/parking_tickets_2011.zip",temp)
P2011<-(read.csv(unzip(temp),  stringsAsFactors = FALSE, quote = ""))

download.file("http://opendata.toronto.ca/revenue/parking/ticket/parking_tickets_2012.zip",temp)
P2012<-(read.csv(unzip(temp),  stringsAsFactors = FALSE, quote = ""))

download.file("http://opendata.toronto.ca/revenue/parking/ticket/parking_tickets_2013.zip",temp)
P2013<-(read.csv(unzip(temp),  stringsAsFactors = FALSE, quote = ""))

download.file("http://opendata.toronto.ca/revenue/parking/ticket/parking_tickets_2014.zip",temp)
P2014<-as.data.frame (readtext(unzip(temp)))

download.file("http://opendata.toronto.ca/revenue/parking/ticket/parking_tickets_2015.zip",temp)
P2015<-as.data.frame (readtext(unzip(temp)))

download.file("http://opendata.toronto.ca/revenue/parking/ticket/parking_tickets_2016.zip",temp)
P2016<-as.data.frame (readtext(unzip(temp)))

download.file("http://opendata.toronto.ca/revenue/parking/ticket/parking_tickets_2017.zip",temp)
P2017<-as.data.frame (readtext(unzip(temp)))

download.file("http://opendata.toronto.ca/revenue/parking/ticket/parking_tickets_2018.zip",temp)
P2018<-as.data.frame (readtext(unzip(temp)))

#---------------------------------3.1.1---------------------------------------------------------#

P2008_fre<-sqldf('SELECT  infraction_code, COUNT(*) as frequency FROM P2008 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2009_fre<-sqldf('SELECT  infraction_code, COUNT(*) as frequency FROM P2009 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2010_fre<-sqldf('SELECT  infraction_code, COUNT(*) as frequency FROM P2010 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2011_fre<-sqldf('SELECT  infraction_code, COUNT(*) as frequency FROM P2011 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2012_fre<-sqldf('SELECT  infraction_code, COUNT(*) as frequency FROM P2012 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2013_fre<-sqldf('SELECT  infraction_code, COUNT(*) as frequency FROM P2013 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2014_fre<-sqldf('SELECT  infraction_code, COUNT(*) as frequency FROM P2014 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2015_fre<-sqldf('SELECT  infraction_code, COUNT(*) as frequency FROM P2015 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2016_fre<-sqldf('SELECT  infraction_code, COUNT(*) as frequency FROM P2016 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2017_fre<-sqldf('SELECT  infraction_code, COUNT(*) as frequency FROM P2017 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2018_fre<-sqldf('SELECT  infraction_code, COUNT(*) as frequency FROM P2018 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
All_Year_frq<-rbind(P2008_fre, P2009_fre, P2010_fre ,  P2011_fre,  P2012_fre,  P2013_fre,  
         P2014_fre,  P2015_fre,  P2016_fre,  P2017_fre,  P2018_fre)

top_20_frequency<-sqldf('SELECT * FROM All_Year_frq GROUP BY infraction_code ORDER BY frequency DESC LIMIT 20')


#-----------------------------------------------3.1.2-------------------------------------------#
P2008_rev<-sqldf('SELECT  infraction_code, SUM(set_fine_amount) as revenue FROM P2008 GROUP BY infraction_code ORDER BY revenue DESC')
P2009_rev<-sqldf('SELECT  infraction_code, SUM(set_fine_amount) as revenue FROM P2009 GROUP BY infraction_code ORDER BY revenue DESC')
P2010_rev<-sqldf('SELECT  infraction_code, SUM(set_fine_amount) as revenue FROM P2010 GROUP BY infraction_code ORDER BY revenue DESC')
P2011_rev<-sqldf('SELECT  infraction_code, SUM(set_fine_amount) as revenue FROM P2011 GROUP BY infraction_code ORDER BY revenue DESC')
P2012_rev<-sqldf('SELECT  infraction_code, SUM(set_fine_amount) as revenue FROM P2012 GROUP BY infraction_code ORDER BY revenue DESC')
P2013_rev<-sqldf('SELECT  infraction_code, SUM(set_fine_amount) as revenue FROM P2013 GROUP BY infraction_code ORDER BY revenue DESC')
P2014_rev<-sqldf('SELECT  infraction_code, SUM(set_fine_amount) as revenue FROM P2014 GROUP BY infraction_code ORDER BY revenue DESC')
P2015_rev<-sqldf('SELECT  infraction_code, SUM(set_fine_amount) as revenue FROM P2015 GROUP BY infraction_code ORDER BY revenue DESC')
P2016_rev<-sqldf('SELECT  infraction_code, SUM(set_fine_amount) as revenue FROM P2016 GROUP BY infraction_code ORDER BY revenue DESC')
P2017_rev<-sqldf('SELECT  infraction_code, SUM(set_fine_amount) as revenue FROM P2017 GROUP BY infraction_code ORDER BY revenue DESC')
P2018_rev<-sqldf('SELECT  infraction_code, SUM(set_fine_amount) as revenue FROM P2018 GROUP BY infraction_code ORDER BY revenue DESC')

All_Year_rev<-rbind(P2008_rev, P2009_rev, P2010_rev ,  P2011_rev,  P2012_rev,  P2013_rev,  
                    P2014_rev,  P2015_rev,  P2016_rev,  P2017_rev,  P2018_rev)

top_20_revenue<-sqldf('SELECT  infraction_code, SUM(revenue) as revenue FROM All_Year_rev GROUP BY infraction_code ORDER BY revenue DESC LIMIT 20 ')





#-----------------------------------------3.1.3-------------------------------------------------#

total_revenue<-sqldf('SELECT SUM(revenue) as total_revenue FROM All_Year_rev ')

#------------------------------------------3.1.4------------------------------------------------#



P2008_fre_loc<-sqldf('SELECT  location2, SUM(set_fine_amount) as revenue, COUNT(*) as frequency FROM P2008 GROUP BY location2 ORDER BY frequency DESC')
P2009_fre_loc<-sqldf('SELECT  location2, SUM(set_fine_amount) as revenue, COUNT(*) as frequency FROM P2009 GROUP BY location2 ORDER BY frequency DESC')
P2010_fre_loc<-sqldf('SELECT  location2, SUM(set_fine_amount) as revenue, COUNT(*) as frequency FROM P2010 GROUP BY location2 ORDER BY frequency DESC')
P2011_fre_loc<-sqldf('SELECT  location2, SUM(set_fine_amount) as revenue, COUNT(*) as frequency FROM P2011 GROUP BY location2 ORDER BY frequency DESC')
P2012_fre_loc<-sqldf('SELECT  location2, SUM(set_fine_amount) as revenue, COUNT(*) as frequency FROM P2012 GROUP BY location2 ORDER BY frequency DESC')
P2013_fre_loc<-sqldf('SELECT  location2, SUM(set_fine_amount) as revenue, COUNT(*) as frequency FROM P2013 GROUP BY location2 ORDER BY frequency DESC')
P2014_fre_loc<-sqldf('SELECT  location2, SUM(set_fine_amount) as revenue, COUNT(*) as frequency FROM P2014 GROUP BY location2 ORDER BY frequency DESC')
P2015_fre_loc<-sqldf('SELECT  location2, SUM(set_fine_amount) as revenue, COUNT(*) as frequency FROM P2015 GROUP BY location2 ORDER BY frequency DESC')
P2016_fre_loc<-sqldf('SELECT  location2, SUM(set_fine_amount) as revenue, COUNT(*) as frequency FROM P2016 GROUP BY location2 ORDER BY frequency DESC')
P2017_fre_loc<-sqldf('SELECT  location2, SUM(set_fine_amount) as revenue, COUNT(*) as frequency FROM P2017 GROUP BY location2 ORDER BY frequency DESC')
P2018_fre_loc<-sqldf('SELECT  location2, SUM(set_fine_amount) as revenue, COUNT(*) as frequency FROM P2018 GROUP BY location2 ORDER BY frequency DESC')

All_Year_frq_loc<-rbind(P2008_fre_loc, P2009_fre_loc, P2010_fre_loc ,  P2011_fre_loc,
                        P2012_fre_loc,  P2013_fre_loc, P2014_fre_loc,  P2015_fre_loc,
                        P2016_fre_loc,  P2017_fre_loc,  P2018_fre_loc)

top_20_frequency_loc<-sqldf('SELECT * FROM All_Year_frq_loc GROUP BY location2 ORDER BY frequency DESC LIMIT 20')

top_20_frequency_loc$address <- paste(top_20_frequency_loc$location2, "Toronto,ON")
top_20_frequency_log_lat <- geocode(top_20_frequency_loc$address)
top_20_frequency_log_lat<-cbind(top_20_frequency_log_lat, top_20_frequency_loc)


top_20_fines<-sqldf('SELECT * FROM All_Year_frq_loc GROUP BY location2 ORDER BY revenue DESC LIMIT 20')

top_20_fines$address <- paste(top_20_fines$location2, "Toronto,ON")
top_20_fines$revenue <- paste("$", top_20_fines$revenue)
top_20_fines_log_lat <- geocode(top_20_fines$address)

top_20_fines_log_lat <-cbind(top_20_fines_log_lat, top_20_fines)
#------------------------------------------3.1.4a------------------------------------------------#
# loading  JSON into in R
data <- fromJSON("https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/b66466c3-69c8-4825-9c8b-04b270069193/resource/059cde7d-21bc-4f24-a533-6c2c3fc33ef1/download/green-p-parking-2019.json")

# grab the data from JSON file lon lat for each Park
data1<-data[["carparks"]]
k<-sapply(data1, function(x) x[[5]])
k1<-sapply(data1, function(x) x[[4]])

lon<-as.numeric(levels(q$k))[q$k]
lat<-as.numeric(levels(q$k1))[q$k1]

# create Data Frame for  lon lat for each Park
green_P<-cbind.data.frame(lon,lat)

# calculate geospatial distance between two points (lat,long) 
y<-c()
i=0
j=0
for (i in  1:nrow(top_20_frequency_log_lat)){
  for (j in 1:nrow(green_P)){ 
    
    y <- c(y, distm (c(top_20_frequency_log_lat$lon[i], top_20_frequency_log_lat$lat[i]), c(green_P$lon[j], green_P$lat[j]), fun = distHaversine))
  }     
}
#finding the closest parking lot (Green P) to each of the top 20 infraction locations  
green_parking_distance<-rollapply(y, 252, function(x) c(min = min(x),  Parking_id=which.min(x)))[seq(from = 1, to = length(y), by = 252),]


#------------------------------------------3.1.5a------------------------------------------------#




P2008_fre_day<-sqldf('SELECT  date_of_infraction, COUNT(*) as frequency FROM P2008 GROUP BY date_of_infraction ORDER BY frequency DESC')
P2009_fre_day<-sqldf('SELECT  date_of_infraction, COUNT(*) as frequency FROM P2009 GROUP BY date_of_infraction ORDER BY frequency DESC')
P2010_fre_day<-sqldf('SELECT  date_of_infraction, COUNT(*) as frequency FROM P2010 GROUP BY date_of_infraction ORDER BY frequency DESC')
P2011_fre_day<-sqldf('SELECT  date_of_infraction, COUNT(*) as frequency FROM P2011 GROUP BY date_of_infraction ORDER BY frequency DESC')
P2012_fre_day<-sqldf('SELECT  date_of_infraction, COUNT(*) as frequency FROM P2012 GROUP BY date_of_infraction ORDER BY frequency DESC')
P2013_fre_day<-sqldf('SELECT  date_of_infraction, COUNT(*) as frequency FROM P2013 GROUP BY date_of_infraction ORDER BY frequency DESC')
P2014_fre_day<-sqldf('SELECT  date_of_infraction, COUNT(*) as frequency FROM P2014 GROUP BY date_of_infraction ORDER BY frequency DESC')
P2015_fre_day<-sqldf('SELECT  date_of_infraction, COUNT(*) as frequency FROM P2015 GROUP BY date_of_infraction ORDER BY frequency DESC')
P2016_fre_day<-sqldf('SELECT  date_of_infraction, COUNT(*) as frequency FROM P2016 GROUP BY date_of_infraction ORDER BY frequency DESC')
P2017_fre_day<-sqldf('SELECT  date_of_infraction, COUNT(*) as frequency FROM P2017 GROUP BY date_of_infraction ORDER BY frequency DESC')
P2018_fre_day<-sqldf('SELECT  date_of_infraction, COUNT(*) as frequency FROM P2018 GROUP BY date_of_infraction ORDER BY frequency DESC')

All_Year_frq_day<-rbind(P2008_fre_day,  P2009_fre_day, P2010_fre_day, P2011_fre_day,
                        P2012_fre_day,  P2013_fre_day, P2014_fre_day,  P2015_fre_day,
                        P2016_fre_day,  P2017_fre_day, P2018_fre_day)


All_Year_frq_day$day_of_week<-weekdays(as.Date(All_Year_frq_day$date_of_infraction,'%Y%m%d'))

infractions_day_of_week<-sqldf('SELECT day_of_week, sum(frequency) as frequency  FROM All_Year_frq_day GROUP BY day_of_week ORDER BY frequency DESC ')


#------------------------------------------3.1.5b------------------------------------------------#

All_Year_frq_day$month_of_year<-month.abb[month(as.Date(All_Year_frq_day$date_of_infraction,'%Y%m%d'))]


infractions_month<-sqldf('SELECT month_of_year, sum(frequency) as frequency  FROM All_Year_frq_day GROUP BY month_of_year ORDER BY frequency DESC ')



#------------------------------------------3.1.5c------------------------------------------------#


All_Year_frq_day$Season <- 
  ifelse(    (All_Year_frq_day$m == 3 & All_Year_frq_day$d >= 21 ) | (All_Year_frq_day$m == 4) | (All_Year_frq_day$m == 5) | (All_Year_frq_day$m == 6 & All_Year_frq_day$d < 21),"spring" , 
         
  ifelse(   (All_Year_frq_day$m == 6 & All_Year_frq_day$d >= 21) | (All_Year_frq_day$m == 7) | (All_Year_frq_day$m == 8)| (All_Year_frq_day$m == 9 & All_Year_frq_day$d < 21),"summer",
  
  ifelse(   (All_Year_frq_day$m == 9 & All_Year_frq_day$d >= 21) | (All_Year_frq_day$m == 10) | (All_Year_frq_day$m == 11) | (All_Year_frq_day$m == 12 & All_Year_frq_day$d < 21),"fall","winter") ))
         

infractions_Season<-sqldf('SELECT Season, sum(frequency) as frequency  FROM All_Year_frq_day GROUP BY Season ORDER BY frequency DESC ')


#------------------------------------------3.3.1ai------------------------------------------------#

ggplot(infractions_month, aes(y=frequency,x =month_of_year))+
  geom_bar(stat = "identity", position = position_dodge(),fill="red")+
  geom_text(aes(label=frequency), vjust=-1, position = position_dodge(0.9))



#------------------------------------------3.3.1aii------------------------------------------------#



All_Year_frq_day$year<-year(as.Date(All_Year_frq_day$date_of_infraction,'%Y%m%d'))

infractions_year<-sqldf('SELECT year, sum(frequency) as frequency  FROM All_Year_frq_day GROUP BY year ORDER BY frequency DESC ')

ggplot(infractions_year, aes(y=frequency,x =year))+
  geom_bar(stat = "identity", position = position_dodge(),fill="blue")+
  geom_text(aes(label=frequency), vjust=-1, position = position_dodge(0.9))



#------------------------------------------3.3.1b---------------------------------------------------------------#

ggplot(top_20_revenue, aes(y=revenue,x = reorder(infraction_code, -revenue)))+  
  geom_bar(stat = "identity", position = position_dodge() ,fill="green")+ 
  geom_text(aes(label=revenue), vjust=-1,size = 3.2, check_overlap = TRUE, position = position_dodge(0.9))+xlab("infraction_code")


#------------------------------------------3.3.2---------------------------------------------------------------#


# First read in the shapefile, using the path to the shapefile and the shapefile name minus the
# extension as arguments
Toronto_ward <- readOGR("citygcs.ward_2018_wgs84.shp")

# Next the shapefile has to be converted to a dataframe for use in ggplot2
Toronto_ward_df <- fortify(Toronto_ward)

# Now the shapefile can be plotted as either a geom_path or a geom_polygon.
# Paths handle clipping better. Polygons can be filled.
# You need the aesthetics long, lat, and group.

#------------------------------------------3.3.2a---------------------------------------------------------------#

map <- ggplot() +
  geom_path(data = Toronto_ward_df, aes(x = long, y = lat, group = group),
            color = 'black',  size = .5, )+labs(title =  "City Of Toronto")


Location <- map +geom_point(data = top_20_frequency_log_lat,
                                 aes(lon   , lat,   ), colour = "blue", size = 3.5)
#------------------------------------------3.3.2b---------------------------------------------------------------#

map_projected <- map +geom_point(data = top_20_frequency_log_lat,
                                 aes(lon   , lat,  colour = factor(frequency), size = frequency ))

Count_by_ward<-map_projected+ geom_label_repel(data = top_20_frequency_log_lat, aes(lon   , lat,label=frequency),
                   box.padding   = 0.35, 
                   point.padding = 0.5,
                   segment.color = 'grey50') +theme_classic()

#------------------------------------------3.3.2c---------------------------------------------------------------#

map_projected2 <- map +geom_point(data = top_20_fines_log_lat,
                                 aes(lon   , lat,  colour = factor(revenue), size = revenue ))
  
Fines_by_ward<-map_projected2+ geom_label_repel(data = top_20_fines_log_lat, aes(lon   , lat,label=revenue),
                                                box.padding   = 0.35, 
                                                point.padding = 0.9,
                                                segment.color = 'grey50') +theme_classic()

  





#--------------------------------------------------------------------------------------------------------------------------

