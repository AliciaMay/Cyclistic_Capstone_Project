## Load packages
library(tidyverse)
library(lubridate)
library(ggplot2)

## Set working directory
setwd("C:/Users/mayal/OneDrive/Desktop/Original Bike Ride Spreadsheets")

## Upload Divvy datasets (.csv files)
df4<-read.csv("202104-divvy-tripdata.csv")
df5<-read.csv("202105-divvy-tripdata.csv")
df6<-read.csv("202106-divvy-tripdata.csv")
df7<-read.csv("202107-divvy-tripdata.csv")
df8<-read.csv("202108-divvy-tripdata.csv")
df9<-read.csv("202109-divvy-tripdata.csv")
df10<-read.csv("202110-divvy-tripdata.csv")
df11<-read.csv("202111-divvy-tripdata.csv")
df12<-read.csv("202112-divvy-tripdata.csv")
df1<-read.csv("202201-divvy-tripdata.csv")
df2<-read.csv("202202-divvy-tripdata.csv")
df3<-read.csv("202203-divvy-tripdata.csv")

## Compare column names in each of the files
colnames(df1)
colnames(df2)
colnames(df3)
colnames(df4)
colnames(df5)
colnames(df6)
colnames(df7)
colnames(df8)
colnames(df9)
colnames(df10)
colnames(df11)
colnames(df12)

## Inspect the data frames and look for incongruencies
str(df1)
str(df2)
str(df3)
str(df4)
str(df5)
str(df6)
str(df7)
str(df8)
str(df9)
str(df10)
str(df11)
str(df12)

## Stack all data frames into one big data frame
all_trips<-bind_rows(df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12)

## Inspect the new table that has been created
View(all_trips)

colnames(all_trips)
nrow(all_trips)
summary(all_trips)

## Add columns that list the date, month, day, and year of each ride
## This allows us to aggregate ride data for each month, day, or year
all_trips$date<-as.Date(all_trips$started_at)
all_trips$month<-format(as.Date(all_trips$date),"%m")
all_trips$day<-format(as.Date(all_trips$date),"%d")
all_trips$year<-format(as.Date(all_trips$date),"%Y")
all_trips$day_of_week<-format(as.Date(all_trips$date),"%A")

## Add a "ride_length_ calculation to all_trips (in seconds)
all_trips$ride_length<-difftime(all_trips$ended_at,all_trips$started_at)

## Convert "ride_length" from Factor to numeric so we can run calculation on the data
all_trips_V2$ride_length<-as.numeric(as.character(all_trips_V2$ride_length))
is.numeric(all_trips_V2$ride_length)

## Remove all negative "ride_length" calculations
all_trips_V2<-all_trips[!(all_trips$ride_length<0),]

## Descriptive analysis on "ride_length" (all figures in seconds)
mean(all_trips_V2$ride_length)
median(all_trips_V2$ride_length)
max(all_trips_V2$ride_length)
min(all_trips_V2$ride_length)

summary(all_trips_V2$ride_length)

## Compare members and casual riders
aggregate(all_trips_V2$ride_length~all_trips_V2$member_casual,FUN = mean)
aggregate(all_trips_V2$ride_length~all_trips_V2$member_casual,FUN = median)
aggregate(all_trips_V2$ride_length~all_trips_V2$member_casual,FUN = max)
aggregate(all_trips_V2$ride_length~all_trips_V2$member_casual,FUN = min)

## See the average ride time by each day for members vs casual riders
aggregate(all_trips_V2$ride_length~all_trips_V2$member_casual+all_trips_V2$day_of_week,FUN = mean)

## Noticed the days of the week are out of order and fix
all_trips_V2$day_of_week<-ordered(all_trips_V2$day_of_week,levels=c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"))

## Average ride time by each day for members vs casual riders
aggregate(all_trips_V2$ride_length~all_trips_V2$member_casual+all_trips_V2$day_of_week,FUN = mean)

## Analyze ridership data by type and weekday
all_trips_V2 %>% 
  mutate(weekday=wday(started_at,label = TRUE)) %>% 
  group_by(member_casual,weekday) %>% 
  summarise(number_of_rides=n()
            ,average_duration=mean(ride_length)) %>% 
  arrange(member_casual,weekday)

## Visualize the number of rides by rider type
all_trips_V2 %>% 
  mutate(weekday=wday(started_at,label = TRUE)) %>% 
  group_by(member_casual,weekday) %>% 
  summarise(number_of_rides=n()
            ,average_duration=mean(ride_length)) %>% 
  arrange(member_casual,weekday) %>% 
  ggplot(aes(x=weekday,y=number_of_rides,fill=member_casual))+
  geom_col(position = "dodge")

## Create a visualization for average duration by weekday
all_trips_V2 %>% 
  mutate(weekday=wday(started_at,label = TRUE)) %>% 
  group_by(member_casual,weekday) %>% 
  summarise(number_of_rides=n()
            ,average_duration=mean(ride_length)) %>% 
  arrange(member_casual,weekday) %>% 
  ggplot(aes(x=weekday,y=average_duration,fill=member_casual))+
  geom_col(position = "dodge")

## Create a visualization for average duration by month
all_trips_V2 %>% 
  mutate(month=month(started_at,label = TRUE)) %>% 
  group_by(member_casual,month) %>% 
  summarise(number_of_rides=n()
            ,average_duration=mean(ride_length)) %>% 
  arrange(member_casual,month) %>% 
  ggplot(aes(x=month,y=number_of_rides,fill=member_casual))+
  geom_col(position = "dodge")

## Create a visualization for total rides per month by member vs casual riders
## Add labels to visualization
all_trips_V2 %>% 
  mutate(month=month(started_at,label = TRUE)) %>% 
  group_by(member_casual,month) %>% 
  summarise(number_of_rides=n()) %>% 
  arrange(member_casual,month) %>% 
  ggplot(aes(x=month,y=number_of_rides,fill=member_casual))+
  geom_col(position = "dodge")+
  labs(title = "Total Rides by Month", x = "Month", y = "Number of Rides")+
  guides(fill=guide_legend(title=NULL))+
  scale_y_continuous(name = "Number of Rides", labels = scales::comma)
  
## Create data frame for member riders
dfmem <- all_trips_V2 %>% 
  filter(member_casual=="member")

## Name all missing cell values within start and end station columns "missing_data"
dfmem$start_station_name <- sub("^$", "missing_data", dfmem$start_station_name)
dfmem$end_station_name <- sub("^$", "missing_data", dfmem$end_station_name)

## Analyze top 10 most visited start and end stations
dfmem %>% 
  count(start_station_name,sort = TRUE) %>% 
  slice(1:10)
dfmem %>% 
  count(end_station_name,sort = TRUE) %>% 
  slice(1:10)

## Create data frame for casual riders
dfcas <- all_trips_V2 %>% 
  filter(member_casual=="casual")

## Name all missing cell values within start and end station columns "missing_data"
dfcas$start_station_name <- sub("^$", "missing_data", dfcas$start_station_name)
dfcas$end_station_name <- sub("^$", "missing_data", dfcas$end_station_name)

## Analyze top 10 most visited start and end stations
dfcas %>% 
  count(start_station_name,sort = TRUE) %>% 
  slice(1:10)
dfcas %>% 
  count(end_station_name,sort = TRUE) %>% 
  slice(1:10)

## Concatenate start and end station names to create a new column as "traveled_routes" by casual riders
dfcas$traveled_routes <- paste(dfcas$start_station_name, dfcas$end_station_name, sep = "--")

## Analyze top 10 most traveled routes for casual riders
dfcas %>% 
  count(traveled_routes,sort = TRUE) %>% 
  slice(1:10)

## Concatenate start and end station names to create a new column as "traveled_routes" by member riders
dfmem$traveled_routes <- paste(dfmem$start_station_name, dfmem$end_station_name, sep = "--")

## Analyze top 10 most traveled routes for member riders
dfmem %>% 
  count(traveled_routes,sort = TRUE) %>% 
  slice(1:10)
