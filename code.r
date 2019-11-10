
# Loading the requested library to R

library("readtext")
library("sqldf")
library(lubridate)
library(forcats)
library(raster)
library(rgdal)     
library(ggplot2)   
library(ggmap)    
library(ggrepel)
library(RJSONIO)
library(RCurl)
library(geosphere)
library(zoo)

# google API key to use to geocode the address to lat and lon 

register_google(key = "")

# Loading all datasets for Parking Tickets https files  to R

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

#finding the top 20 ticket infractions (frequency)

P2008_fre<-sqldf('SELECT  infraction_code, infraction_description , COUNT(*) as frequency FROM P2008 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2009_fre<-sqldf('SELECT  infraction_code, infraction_description , COUNT(*) as frequency FROM P2009 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2010_fre<-sqldf('SELECT  infraction_code, infraction_description , COUNT(*) as frequency FROM P2010 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2011_fre<-sqldf('SELECT  infraction_code, infraction_description , COUNT(*) as frequency FROM P2011 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2012_fre<-sqldf('SELECT  infraction_code, infraction_description , COUNT(*) as frequency FROM P2012 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2013_fre<-sqldf('SELECT  infraction_code, infraction_description , COUNT(*) as frequency FROM P2013 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2014_fre<-sqldf('SELECT  infraction_code, infraction_description , COUNT(*) as frequency FROM P2014 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2015_fre<-sqldf('SELECT  infraction_code, infraction_description , COUNT(*) as frequency FROM P2015 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2016_fre<-sqldf('SELECT  infraction_code, infraction_description , COUNT(*) as frequency FROM P2016 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2017_fre<-sqldf('SELECT  infraction_code, infraction_description , COUNT(*) as frequency FROM P2017 GROUP BY infraction_code ORDER BY COUNT(*) DESC')
P2018_fre<-sqldf('SELECT  infraction_code, infraction_description , COUNT(*) as frequency FROM P2018 GROUP BY infraction_code ORDER BY COUNT(*) DESC')

All_Year_frq<-rbind(P2008_fre, P2009_fre, P2010_fre ,  P2011_fre,  P2012_fre,  P2013_fre,  
         P2014_fre,  P2015_fre,  P2016_fre,  P2017_fre,  P2018_fre)

top_20_frequency<-sqldf('SELECT * FROM All_Year_frq GROUP BY infraction_code ORDER BY frequency DESC LIMIT 20')


#-----------------------------------------------3.1.2-------------------------------------------#

#finding the top 20 ticket infractions (revenue))

P2008_rev<-sqldf('SELECT  infraction_code, infraction_description ,SUM(set_fine_amount) as revenue FROM P2008 GROUP BY infraction_code ORDER BY revenue DESC')
P2009_rev<-sqldf('SELECT  infraction_code, infraction_description ,SUM(set_fine_amount) as revenue FROM P2009 GROUP BY infraction_code ORDER BY revenue DESC')
P2010_rev<-sqldf('SELECT  infraction_code, infraction_description ,SUM(set_fine_amount) as revenue FROM P2010 GROUP BY infraction_code ORDER BY revenue DESC')
P2011_rev<-sqldf('SELECT  infraction_code, infraction_description ,SUM(set_fine_amount) as revenue FROM P2011 GROUP BY infraction_code ORDER BY revenue DESC')
P2012_rev<-sqldf('SELECT  infraction_code, infraction_description ,SUM(set_fine_amount) as revenue FROM P2012 GROUP BY infraction_code ORDER BY revenue DESC')
P2013_rev<-sqldf('SELECT  infraction_code, infraction_description ,SUM(set_fine_amount) as revenue FROM P2013 GROUP BY infraction_code ORDER BY revenue DESC')
P2014_rev<-sqldf('SELECT  infraction_code, infraction_description ,SUM(set_fine_amount) as revenue FROM P2014 GROUP BY infraction_code ORDER BY revenue DESC')
P2015_rev<-sqldf('SELECT  infraction_code, infraction_description ,SUM(set_fine_amount) as revenue FROM P2015 GROUP BY infraction_code ORDER BY revenue DESC')
P2016_rev<-sqldf('SELECT  infraction_code, infraction_description ,SUM(set_fine_amount) as revenue FROM P2016 GROUP BY infraction_code ORDER BY revenue DESC')
P2017_rev<-sqldf('SELECT  infraction_code, infraction_description ,SUM(set_fine_amount) as revenue FROM P2017 GROUP BY infraction_code ORDER BY revenue DESC')
P2018_rev<-sqldf('SELECT  infraction_code, infraction_description ,SUM(set_fine_amount) as revenue FROM P2018 GROUP BY infraction_code ORDER BY revenue DESC')

All_Year_rev<-rbind(P2008_rev, P2009_rev, P2010_rev ,  P2011_rev,  P2012_rev,  P2013_rev,  
                    P2014_rev,  P2015_rev,  P2016_rev,  P2017_rev,  P2018_rev)

top_20_revenue<-sqldf('SELECT  infraction_code,  infraction_description ,SUM(revenue) as revenue FROM All_Year_rev GROUP BY infraction_code ORDER BY revenue DESC LIMIT 20 ')




#-----------------------------------------3.1.3-------------------------------------------------#

# Total revenue generated from all tickets

total_revenue<-sqldf('SELECT SUM(revenue) as total_revenue FROM All_Year_rev ')


#------------------------------------------3.1.4------------------------------------------------#

#the top 20 infraction locations


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

#the top 20 infraction locations by frequency

top_20_frequency_loc<-sqldf('SELECT * FROM All_Year_frq_loc GROUP BY location2 ORDER BY frequency DESC LIMIT 20')
top_20_frequency_loc$address <- paste(top_20_frequency_loc$location2, "Toronto,ON")


#finding the lat and lon of the top 20 infraction locations by frequency
top_20_frequency_log_lat <- geocode(top_20_frequency_loc$address)
top_20_frequency_log_lat<-cbind(top_20_frequency_log_lat, top_20_frequency_loc)



#the top 20 infraction locations by revenue

top_20_fines<-sqldf('SELECT * FROM All_Year_frq_loc GROUP BY location2 ORDER BY revenue DESC LIMIT 20')
top_20_fines$address <- paste(top_20_fines$location2, "Toronto,ON")

#find the lat and lon of the top 20 infraction locations by revenue


top_20_fine_log_lat <- geocode(top_20_fines$address)
top_20_fines_log_lat <-cbind(top_20_fine_log_lat, top_20_fines)

#------------------------------------------3.1.4a------------------------------------------------#
# loading  JSON file of Green parking into in R
data <- fromJSON("https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/b66466c3-69c8-4825-9c8b-04b270069193/resource/059cde7d-21bc-4f24-a533-6c2c3fc33ef1/download/green-p-parking-2019.json")

# grab the data from JSON file lon lat for each Park
data1<-data[["carparks"]]
k<-sapply(data1, function(x) x[[5]])
k1<-sapply(data1, function(x) x[[4]])
k2<-sapply(data1, function(x) x[[3]])
lon<-as.numeric(k)
lat<-as.numeric(k1)
addres<-as.character(k2)
# create Data Frame for  lon lat for each Park
green_P<-cbind.data.frame(lon,lat, addres)

# calculate geospatial distance between two points (lat,long) 
y<-c()
wy<-c()
i=0
j=0
for (i in  1:nrow(top_20_frequency_log_lat)){
  for (j in 1:nrow(green_P)){ 
    
    y <- c(y, distm (c(top_20_frequency_log_lat$lon[i], top_20_frequency_log_lat$lat[i]), c(green_P$lon[j], green_P$lat[j]), fun = distHaversine))
    wy <- c(wy,as.character(green_P$addres[j] ))
    }     
  ss<-cbind.data.frame (y, wy)}



#finding the closest parking lot (Green P) to each of the top 20 infraction locations  
green_parking_distance<-rollapply(y, 252, function(x) c(closest_parking_distance_Metre= min(x),  Parking_id=which.min(x),
                                Parking_address= as.character( ss$wy[which.min(x)] )  ))[seq(from = 1, to = length(y), by = 252),]

closest_parking_to_infraction_locations<- cbind.data.frame(address=top_20_frequency_log_lat$address, 
                                                            frequency= top_20_frequency_log_lat$frequency,green_parking_distance)


closest_parking_to_infraction_locations$closest_parking_distance_Metre  <-
  format(round(as.numeric( as.character(closest_parking_to_infraction_locations$closest_parking_distance_Metre )), 2))





#------------------------------------------3.1.4b------------------------------------------------#
# loading  file of TTc into  R

stop_TTC<-(read.csv("stops.txt",  stringsAsFactors = FALSE, quote = ""))



# calculate geospatial distance between two points (lat,long) 
z<-c()
wz<-c()
wz1<-c()
i=0
j=0
for (i in  1:nrow(top_20_frequency_log_lat)){
  for (j in 1:nrow(stop_TTC)){ 
    
    z <- c(z, distm (c(top_20_frequency_log_lat$lon[i], top_20_frequency_log_lat$lat[i]), 
                     c(stop_TTC$stop_lon[j], stop_TTC$stop_lat[j]), fun = distHaversine) )
    
    wz <- c(wz, stop_TTC$stop_id[j] )
    wz1 <- c(wz1,  stop_TTC$stop_name[j] )
  }     
  ff<-cbind.data.frame (z,wz,wz1)}

#finding the closest parking lot (Green P) to each of the top 20 infraction locations  


TTC_distance<-rollapply(ff$z, 9707, function(x) c(closest_TTC_distance_Metre = min(x),  stop_ID = ff$wz[which.min(x)],
                        stop_name = as.character( ff$wz1[which.min(x)] ) ))[seq(from = 1, to = length(ff$z), by = 9707),]

closest_TTC_stop_to_infraction_locations<- cbind.data.frame(address=top_20_frequency_log_lat$address, 
                                                            frequency= top_20_frequency_log_lat$frequency,TTC_distance)

closest_TTC_stop_to_infraction_locations$closest_TTC_distance_Metre <-
format(round(as.numeric( as.character(closest_TTC_stop_to_infraction_locations$closest_TTC_distance_Metre)), 2))
#------------------------------------------3.1.5a------------------------------------------------#

# the impact of the following on all infractions: Day of week 


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


infractions_day_of_week<-subset(infractions_day_of_week, !is.na(day_of_week))

#------------------------------------------3.1.5b------------------------------------------------#

# the impact of the following on all infractions: Month 

All_Year_frq_day$month_of_year<-month.abb[month(as.Date(All_Year_frq_day$date_of_infraction,'%Y%m%d'))]


infractions_month<-sqldf('SELECT month_of_year, sum(frequency) as frequency  FROM All_Year_frq_day GROUP BY month_of_year ORDER BY frequency DESC ')

infractions_month<-subset(infractions_month, !is.na(month_of_year))

#------------------------------------------3.1.5c------------------------------------------------#

# the impact of the following on all infractions: Season
# get the day and the month from date ofinfraction

m<-month(as.Date(All_Year_frq_day$date_of_infraction,'%Y%m%d'))
d<-day(as.Date(All_Year_frq_day$date_of_infraction,'%Y%m%d'))

All_Year_frq_day$Season <- 
  ifelse(    (m == 3 & d >= 21 ) | (m == 4) | (m == 5)  | (m == 6 &  d< 21),"spring" , 
         
  ifelse(   (m == 6 & d >= 21 ) | (m ==  7) | (m == 8)  | (m == 9 &  d < 21),"summer",
  
  ifelse(   (m == 9 & d >= 21 ) | (m == 10) | (m == 11) | (m == 12 &  d < 21),"fall","winter") ))
         


infractions_Season<-sqldf('SELECT Season, sum(frequency) as frequency  FROM All_Year_frq_day GROUP BY Season ORDER BY frequency DESC ')

infractions_Season<-subset(infractions_Season, !is.na(Season))
#------------------------------------------3.3.1ai------------------------------------------------#

#Visualizations  the Distribution of infractions by Year 


All_Year_frq_day$year<-year(as.Date(All_Year_frq_day$date_of_infraction,'%Y%m%d'))

infractions_year<-sqldf('SELECT year, sum(frequency) as frequency  FROM All_Year_frq_day GROUP BY year ORDER BY frequency DESC ')
infractions_per_year<-subset(infractions_year, !is.na(year))

infractions_by_year<-ggplot(infractions_per_year, aes(y=frequency,x =year))+
  geom_bar(stat = "identity", position = position_dodge(),fill="green")+
  geom_text(aes(label=frequency), vjust=2, size = 3.2,position = position_dodge(0.9))+
  labs(title =  "Distribution of infractions by year")



#------------------------------------------3.3.1aii------------------------------------------------#


#Visualizations  the Distribution of infractions by  Month


infractions_by_month<-ggplot(infractions_month, aes(y=frequency,x =reorder(month_of_year,-frequency )))+
  geom_bar(stat = "identity", position = position_dodge(),fill="red")+
  geom_text(aes(label=frequency), vjust=2, size = 3.2,  position = position_dodge(0.9))+
  labs(title =  "Distribution of infractions by month")





#------------------------------------------3.3.1b---------------------------------------------------------------#

# Distribution of top 20 infractions by total ticket fines

infractions_by_fines<-ggplot(top_20_revenue, aes(y=revenue,x = reorder(infraction_code, -revenue)))+  
  geom_bar(stat = "identity", position = position_dodge() ,fill="green")+ 
  geom_text(aes(label=revenue), vjust=0,hjust=.3, size = 2.5, angle= 0, check_overlap = TRUE, position = position_dodge(0.9))+xlab("infraction_code")+
  labs(title =  "Distribution of infractions by total ticket fines")


#------------------------------------------3.3.2---------------------------------------------------------------#


# First read in the .shp file, using the path 
Toronto_ward <- readOGR("citygcs.ward_2018_wgs84.shp")

# the file  converted to a dataframe for use in ggplot2
Toronto_ward_df <- fortify(Toronto_ward)


#------------------------------------------3.3.2a---------------------------------------------------------------#

# You need the aesthetics long, lat, and group to Visualize the City Of Toronto
map <- ggplot() +
  geom_path(data = Toronto_ward_df, aes(x = long, y = lat, group = group),
            color = 'black',  size = .5, )+labs(title =  "City Of Toronto")

#Distribution of top 20 infractions Location
Location <- map +geom_point(data = top_20_frequency_log_lat,
                                 aes(lon   , lat,   ), colour = "blue", size = 3.5)+  
                          labs(title =  "Distribution of top 20 infractions Location")+theme_classic()
#------------------------------------------3.3.2b---------------------------------------------------------------#

#Distribution of top 20 infractions Count by ward

map_projected <- map +geom_point(data = top_20_frequency_log_lat,
                                 aes(lon   , lat,  colour = factor(frequency), size = as.numeric(frequency) ))

Count_by_ward<-map_projected+ geom_label_repel(data = top_20_frequency_log_lat, aes(lon   , lat,label=frequency),
                   box.padding   = 0.35, 
                   point.padding = 0.5,
                   segment.color = 'grey50') +theme_classic()+labs(title =  "Distribution of top 20 infractions Count by ward")

#------------------------------------------3.3.2c---------------------------------------------------------------#


#Distribution of top 20 infractions Sum fines by ward
map_projected2 <- map +geom_point(data = top_20_fines_log_lat,
                                 aes(lon   , lat,  colour = factor(revenue), size = as.numeric(revenue)))
  
Fines_by_ward<-map_projected2+ geom_label_repel(data = top_20_fines_log_lat, aes(lon   , lat,label=revenue),
                   box.padding   = 0.35, 
                   point.padding = 0.9,
                   segment.color = 'grey50') +theme_classic()+labs(title =  "Distribution of top 20 infractions Sum fines by ward")

  


#--------------------------------------------------------------------------------------------------------------------------

