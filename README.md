<div align="center">
  <img src="https://user-images.githubusercontent.com/105527562/168933795-591ead1f-d774-4b4a-a75d-1ce1b6342992.png" width="250"/>
</div>

# Cyclistic Capstone Project

As the Google Data Analyst course comes to an end, I am assigned a capstone project to enhance my Excel, SQL, Tableau, and R skills. These are the tools I will be using throughout the project to become more proficient for a future in Data Analytics. 
Cyclistic, a Chicago based bike-share company would like to increase their profitability by converting casual riders into annual members. As a junior data analyst, I have been assigned the task of determining how casual riders and annual members use Cyclistic bikes differently. 
Through the completion of the Google Data Analytics program, I used the data analysis process of **Ask, Prepare, Process, Analyze, Share,** and **Act**. These are the steps that I used in order to complete my task.

## ASK

Lily Moreno, the director of marketing, has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members.
These three given questions guided my analysis process:
1.	How do annual members and casual riders use Cyclistic bikes differently?
2.	Why would casual riders buy Cyclistic annual memberships?
3.	How can Cyclistic use digital media to influence casual riders to become members?

## PREPARE
I downloaded and extracted the ZIP files of the previous 12 months of Cyclistic trip data and saved them to my computer as .csv files. At the same time, I created a subfolder to save original copies of the data.


<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	   <img src="https://user-images.githubusercontent.com/105527562/168912528-6e5acc5c-8883-4778-b95f-36b9bda197a8.png" width="600"/>
        </td>
      </tr>
   </table>
</div>

The data layout within each file contained 13 columns labeled as follows:
*	ride_id
*	rideable_type
*	started_at
*	ended_at
*	start_station_name
*	start_station_id
*	end_station_name
*	end_station_id
*	start_lat
*	start_lng
*	end_lat
*	end_lng
*	member_casual

## PROCESS
### Initial Data Verification in Excel

The .csv files were saved as individual excel sheets so that I could do some initial cleaning and become familiar with the data and its organization. 
*	Checked for duplicates, spell check, formatting, and outliers.
*	Created a column named ???day_of_week??? to identify the day of the week of each ride.
*	Created a column named ???ride_length??? which calculated the length of each ride. After checking the filter, there were negative numbers that were found and showed a data entry error. A total of 143 rows were found to have this error and were removed from the total data.

<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	   <img src="https://user-images.githubusercontent.com/105527562/168912240-66b80df0-685a-40ea-ae47-23cedd1d001c.png" width="600"/>
        </td>
      </tr>
   </table>
</div>

Let???s look at some insightful data comparing casual riders vs members by creating Pivot Tables and using the Pivot Wizard to combine the data needed. As we see in the charts below, Cyclistic has access to a large group of casual riders that can be targeted during promotional events in order to increase their profits. Classic and electric bikes were the most used by both casual riders and members. 

<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	   <img src="https://user-images.githubusercontent.com/105527562/169669383-61a3b75e-1d06-4118-b664-94382472d29c.png" width="400"/>
      	   </td>
            <td style="padding:10px">
            	<img src="https://user-images.githubusercontent.com/105527562/169669396-e3281a6b-d811-42b4-ba7d-191c880a0971.png" width="420"/>
           </td>
       </tr>
   </table>
</div>

  
## ANALYZE
### Data Analyzation Using BigQuery and SQL

All 12 .csv files were uploaded into BigQuery then I used the SELECT, FROM, UNION DISTINCT statement to create one large table appending all the data and then labeled it all_trips. Let???s take a peek at the results.

```
SELECT  *
FROM `cyclistic-347119.Trips.table_202104`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202105`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202106`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202107`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202108`
UNION DISTINCT
SELECT *
FROM `cyclistic-347119.Trips.table_202109`
UNION DISTINCT
```
<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168913992-8ae425d0-51e7-4844-acc4-2aee36de1769.png" width="800"/>
        </td>
      </tr>
   </table>
</div>  

By analyzing the average ride trip of casual riders vs members, we can see that casual riders are more likely to take longer rides than annual members. This leads to the conclusion that casual riders use bikes primarily for leisure whilst members use bikes as a method of transportation.
  
```
SELECT  
  member_casual,
  ROUND(AVG(DATE_DIFF(ended_at, started_at, MINUTE))) AS total_min
FROM `cyclistic-347119.Trips.all_trips`
GROUP BY member_casual
```
  
<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168914456-3af917a9-175f-4041-b62a-9164e0bb08f5.png" width="600"/>
        </td>
      </tr>
   </table>
</div>

Let???s continue our journey and compare the number of trips per day by casual vs member riders. 
We can assume from the data that casual riders bike more on weekends. On the other hand, members bike more on weekdays.

```
SELECT  
  member_casual,
  COUNT(EXTRACT(DAYOFWEEK FROM started_at)) AS num_of_days,
  FORMAT_DATE('%A', started_at) AS day_of_week         
FROM `cyclistic-347119.Trips.all_trips`
GROUP BY day_of_week, member_casual
ORDER BY member_casual
```

<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168914877-6d205e88-87d4-4bb9-9ae8-54af5bda999e.png" width="700"/>
        </td>
      </tr>
   </table>
</div>

I also wanted to investigate the length of rides taken by members and casual riders. The data was aggregated and a chart was created to display the results. 
Casual riders use the bikes for about 30 minutes, whereas members utilize them for 15 minutes or less, according to the graph.

```
SELECT  
  member_casual,
  ROUND(AVG(DATE_DIFF(ended_at, started_at, MINUTE))) AS avg_total_min,
  FORMAT_DATE('%A', started_at) AS day_of_week,         
FROM `cyclistic-347119.Trips.all_trips`
GROUP BY day_of_week, member_casual
ORDER BY member_casual
```
  
<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168915312-55624fd5-6572-47ee-9b5e-0aec90e6b7a9.png" width="700"/>
        </td>
      </tr>
   </table>
</div>

The chart clearly shows casual riders use the bikes for approximately 30 minutes and members use them for 15 minutes or less. 
  
## Data Analyzation Using R

The initial step is to load the packages that will be used to analyze and visualize the data, followed by uploading all the files.
  
```
library(tidyverse)
library(lubridate)
library(geodist)
library(ggplot2)

df4 <- read.csv("202104-divvy-tripdata.csv")
df5 <- read.csv("202105-divvy-tripdata.csv")
df6 <- read.csv("202106-divvy-tripdata.csv")
df7 <- read.csv("202107-divvy-tripdata.csv")
df8 <- read.csv("202108-divvy-tripdata.csv")
df9 <- read.csv("202109-divvy-tripdata.csv")
df10 <- read.csv("202110-divvy-tripdata.csv")
df11 <- read.csv("202111-divvy-tripdata.csv")
df12 <- read.csv("202112-divvy-tripdata.csv")
df1 <- read.csv("202201-divvy-tripdata.csv")
df2 <- read.csv("202202-divvy-tripdata.csv")
df3 <- read.csv("202203-divvy-tripdata.csv")
```
  
The bind_rows function was used to make one large single data frame to analyze. Then inspection of the results was performed by checking the columns, rows, and a summary of the data.
  
```
all_trips <- bind_rows(df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12)
View(all_trips)
colnames(all_trips)
nrow(all_trips)
summary(all_trips)
```
	     
The columns for date, month, day, year, day_of_week, and a column for the calculation of ride_length were then added to the data frame. When the findings were examined, it was discovered that some values resulted in negative time duration. This would have an impact on any calculations and hence were eliminated.
	     
```
all_trips$date <- as.Date(all_trips$started_at)
all_trips$month <- format(as.Date(all_trips$date),"%m")
all_trips$day <- format(as.Date(all_trips$date),"%d")
all_trips$year <- format(as.Date(all_trips$date),"%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date),"%A")

all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)

all_trips_V2 <- all_trips[!(all_trips$ride_length<0),]

all_trips_V2$ride_length <- as.numeric(as.character(all_trips_V2$ride_length))
is.numeric(all_trips_V2$ride_length)
```

Let???s preview what that section of the data frame looks like now.
 
<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168916548-4760425a-2170-48f1-a86e-9e405c0a31e5.png" width="600"/>
        </td>
      </tr>
   </table>
</div>

To gain some preliminary insights, the data was aggregated to compare the ride length of member to casual riders.
  
```
summary(all_trips_V2$ride_length)
aggregate(all_trips_V2$ride_length~all_trips_V2$member_casual,FUN = mean)
aggregate(all_trips_V2$ride_length~all_trips_V2$member_casual,FUN = median)
aggregate(all_trips_V2$ride_length~all_trips_V2$member_casual,FUN = max)
aggregate(all_trips_V2$ride_length~all_trips_V2$member_casual,FUN = min)
```

<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168916782-e7a5eb75-85bd-4eb1-acc8-5c4d945e559f.png" width="600"/>
        </td>
      </tr>
   </table>
</div>

After conducting a few other aggregations, I moved on to visually analyzing and comparing total rides by month.
  
```
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
```
  
<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168917269-2beee646-41dc-4363-b6dd-a75e2ae45032.png" width="500"/>
        </td>
      </tr>
   </table>
</div>

The visualization shows casual riders prefer to ride during the spring and summer months, with the most rides occurring in the month of July. Member riders also increased their rides in the summer months but tend to continue to ride throughout the year more often than casual riders.

Now we can look at the most frequently used start and end stations by casual and member riders. I began by creating a data frame to represent the data for member (dfmem) and casual (dfcas) riders separately. 

```
dfmem <- all_trips_V2 %>% 
  filter(member_casual=="member")
dfcas <- all_trips_V2 %>% 
  filter(member_casual=="casual")
```
  
There were several cell values missing data, accounting for 7% of the total data, but instead of deleting the data, I named the cells ???missing data???. It is critical to identify the source of the missing data and that it should be investigated further.
  
```
dfmem$start_station_name <- sub("^$", "missing_data", dfmem$start_station_name)
dfmem$end_station_name <- sub("^$", "missing_data", dfmem$end_station_name)
dfcas$start_station_name <- sub("^$", "missing_data", dfcas$start_station_name)
dfcas$end_station_name <- sub("^$", "missing_data", dfcas$end_station_name)
```

Analyzing the results, we can see member and casual riders do not share common frequently used starting or ending stations. There is no discernible difference in how members use stations. Casual riders, on the other hand, use Streeter Dr & Grand Ave station twice as frequently as any other.   

<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168917810-9a476ecd-0d77-4ab9-8508-dd5a49579e72.png" width="700"/>
        </td>
      </tr>
   </table>
</div>

<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168918235-efa63adb-ae35-41fd-8ee3-3f0cab3dfc36.png" width="710"/>
        </td>
      </tr>
   </table>
</div>
  
A new column called ???traveled_routes??? was created by using the paste function to concatenate the start and end station names also separating them by using "--". This was done in order to determine which route was the most popular among the riders.
  
```
dfmem$traveled_routes <- paste(dfmem$start_station_name, dfmem$end_station_name, sep = "--")
```

When compared to member riders who start and end at different stations, casual riders tend to start and end at the same stations. We can also see that some of the member routes are used in reverse of each other. This could imply that member riders are traveling from one station to another and then returning. 
                         
<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	   <img src="https://user-images.githubusercontent.com/105527562/168920017-6e2188d1-286d-4e3a-9b41-b43640689db2.png" width="400"/>
      	   </td>
            <td style="padding:10px">
            	<img src="https://user-images.githubusercontent.com/105527562/168920131-7f47d750-cd3c-4f3a-a07a-8d5c0608ef05.png" width="560"/>
           </td>
       </tr>
   </table>
</div>

# SHARE
## Data Visualization using Tableau

A new data source was created by uploading an excel workbook containing all the monthly table sheets. All the tables were appended together using the join feature. The following sheets were designed in Tableau, and key insights are noted.    

<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168921963-fcfc02cf-4a59-4bd4-8f90-273ff32d669d.png" width="800"/>
        </td>
      </tr>
   </table>
</div>

* Casual riders make up 44% of the number of rides recorded which provides an opportunity to convert casual riders to members.
* Casual riders ride duration average is twice that of members.
* Both casual and member riders prefer classic bike types. There were no member riders who chose to ride a docked bike.

<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168922484-92f59fd8-d866-4c60-be9d-ca62811fd0df.png" width="800"/>
        </td>
      </tr>
   </table>
</div>
  
*	Casual and member ridership begins to increase during the month of February.
*	Both casual and member riders tend to ride more during the summer months with July being the busiest for casual riders while August and September are equally the busiest time for member riders.
*	Casual riders tend to ride more on the weekends compared to member riders who ride more during the weekday.

<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168923274-13853a31-9ace-4709-a539-0e42e401fcfd.png" width="800"/>
        </td>
      </tr>
   </table>
</div>
  
<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168923341-29abeb65-7498-4b27-b81b-634eaf743750.png" width="800"/>
        </td>
      </tr>
   </table>
</div>
  
* Both casual and member riders enjoy riding during the afternoon into the evening. Most rides for both occur during the hours of 4pm to 6pm.
* When compared to casual riders, there is a considerable increase between the hours of 7am and 8am for members.
  
<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168923434-628b208b-d74d-4028-b8e6-93e9c71c80e6.png" width="800"/>
        </td>
      </tr>
   </table>
</div>
  
<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/168923500-1d1aaaa8-cf0e-4e51-a44b-f904a5758662.png" width="800"/>
        </td>
      </tr>
   </table>
</div>
  
* Casual and member riders tend to ride more during the summer and fall months.
* During the winter, member riders ride more than casual riders.

Here is an overview of the dashboard as a whole:

<div id="image-table">
  <div align="center">
    <table>
	    <tr>
    	   <td style="padding:10px">
        	 <img src="https://user-images.githubusercontent.com/105527562/169669860-b3a5c275-a2ca-4346-8a82-9c724fc5bfdc.png" width="800"/>
        </td>
      </tr>
   </table>
</div>
  
# ACT

After analyzing I have reached the following conclusion:
  
**Casual riders**
* Ride for an average duration of 30 minutes.
* Prefer classic bikes
* Begin to increase their ridership in February and peak in July
* Ride more on the weekends than weekdays
* Enjoy riding in the afternoon into the evening
* Enjoy the riding in the summer and fall and ride least in the winter
* Most visited start and end station is Streeter Dr & Grand Ave

  
Here are my top 3 recommendations based on the above key findings:
  
1.	Promotions should begin in February when the uptick in casual riders begins and target classic bikes.
2.	New membership promotions should include discounts on weekends or evenings. A discounted seasonal membership should also be promoted.
3.	New membership promotional advertisements should be placed at Streeter Dr & Grand Ave or even a weekend drive to register new annual members should be held at the location.

