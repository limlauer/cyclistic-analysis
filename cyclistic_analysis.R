### Divvy_Exercise_Full_Year_Analysis ###

# This analysis is based on the Divvy case study "'Sophisticated, Clear, and Polished’: Divvy and Data Visualization" written by Kevin Hartman (found here: https://artscience.blog/home/divvy-dataviz-case-study). The purpose of this script is to consolidate downloaded Divvy data into a single dataframe and then conduct simple analysis to help answer the key question: “In what ways do members and casual riders use Divvy bikes differently?”

# # # # # # # # # # # # # # # # # # # # # # # 
# Install required packages
# tidyverse for data import and wrangling
# lubridate for date functions
# ggplot for visualization
# # # # # # # # # # # # # # # # # # # # # # #  

library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data
library(moments) #for skewness
options(scipen = 999)

getwd() #displays your working directory
setwd("YOURFOLDERPATH/data") #sets your working directory to simplify calls to data ... make sure to use your OWN username instead of mine ;)

# Function to get the mode
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

#=====================
# STEP 1: COLLECT DATA
#=====================
# Upload datasets (csv files) here
M1_2023 <- read_csv("202301-divvy-tripdata.csv")
M2_2022 <- read_csv("202202-divvy-tripdata.csv")
M3_2022 <- read_csv("202203-divvy-tripdata.csv")
M4_2022 <- read_csv("202204-divvy-tripdata.csv")
M5_2022 <- read_csv("202205-divvy-tripdata.csv")
M6_2022 <- read_csv("202206-divvy-tripdata.csv")
M7_2022 <- read_csv("202207-divvy-tripdata.csv")
M8_2022 <- read_csv("202208-divvy-tripdata.csv")
M9_2022 <- read_csv("202209-divvy-tripdata.csv")
M10_2022 <- read_csv("202210-divvy-tripdata.csv")
M11_2022 <- read_csv("202211-divvy-tripdata.csv")
M12_2022 <- read_csv("202212-divvy-tripdata.csv")

#====================================================
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#====================================================
# Compare column names each of the files
# While the names don't have to be in the same order, they DO need to match perfectly before we can use a command to join them into one file
colnames(M1_2023);colnames(M2_2022)
colnames(M3_2022);colnames(M4_2022)
colnames(M5_2022);colnames(M6_2022)
colnames(M7_2022);colnames(M8_2022)
colnames(M9_2022);colnames(M10_2022)
colnames(M11_2022);colnames(M12_2022)

# Inspect the dataframes and look for incongruencies
str(M1_2023);str(M2_2022)
str(M3_2022);str(M4_2022)
str(M5_2022);str(M6_2022)
str(M7_2022);str(M8_2022)
str(M9_2022);str(M10_2022)
str(M11_2022);str(M12_2022)

# Stack individual data frames into one big data frame
all_trips <- bind_rows(M2_2022,M3_2022,M4_2022,M5_2022,M6_2022,M7_2022,M8_2022,M9_2022,M10_2022,M11_2022,M12_2022,M1_2023)
colnames(all_trips)
str(all_trips)

#======================================================
# STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================
# Inspect the new table that has been created
colnames(all_trips)  #List of column names
nrow(all_trips)  #How many rows are in data frame?
dim(all_trips)  #Dimensions of the data frame?
head(all_trips)  #See the first 6 rows of data frame. Also tail(all_trips)
str(all_trips)  #See list of columns and data types (numeric, character, etc)
summary(all_trips)  #Statistical summary of data. Mainly for numerics

# Problems to fix:
# 1 - ride_length column for travel time in seconds

# Check if there are any errors in the usertype
sum(is.na(all_trips$member_casual)) # Any NAs?
table(all_trips$member_casual) # Table showing distribution of usertype
table(all_trips$day_of_week)   # and day of week

# We now need to change the date to an unambigous datetime type
# Backup data just in case something goes wrong and start the process
all_trips2 <- all_trips
all_trips2 <-  mutate(all_trips2, started_at = as.POSIXct(all_trips2$started_at,
                                                          format = "%m/%d/%Y %H:%M"))
all_trips2 <-  mutate(all_trips2, ended_at = as.POSIXct(all_trips2$ended_at,
                                                          format = "%m/%d/%Y %H:%M"))

# Let's examine the dataframe again to see if it worked correctly
glimpse(all_trips2)
head(all_trips2)
str(all_trips2)

# Add columns that list the date, month, day, and year of each ride
# This will allow us to aggregate ride data for each month, day, or year
# https://www.statmethods.net/input/dates.html more on date formats in R found at that link
all_trips2$date <- as.Date(all_trips2$started_at) #The default format is yyyy-mm-dd
all_trips2$month <- format(as.Date(all_trips2$date), "%m")
all_trips2$day <- format(as.Date(all_trips2$date), "%d")
all_trips2$year <- format(as.Date(all_trips2$date), "%Y")
all_trips2$day_of_week <- format(as.Date(all_trips2$date), "%A")

# Add a "ride_length" calculation to all_trips (in seconds)
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/difftime.html
all_trips2$ride_length <- difftime(all_trips2$ended_at,all_trips2$started_at)

# Inspect the structure of the columns
glimpse(all_trips2)
str(all_trips)

# ride_length is in secs format
# Convert "ride_length" from Factor to numeric so we can run calculations on the data
is.factor(all_trips2$ride_length)
all_trips2$ride_length <- as.numeric(as.character(all_trips2$ride_length))
is.numeric(all_trips2$ride_length)

# Remove observations where the ride_length is negative, 0 or the bikes were taken out of docks and checked for quality by "Cyclistic"
# Backup the data again and drop those rows - https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-conditions-2/
all_trips3 <- all_trips2[!(all_trips2$start_station_name == "HQ QR" | all_trips2$ride_length<0),]

# Drop rows where "member_casual" is NA, as this is the main focus of our business task.
all_trips3 <- filter(all_trips3, !is.na(member_casual))

# Quick check
dim(all_trips)  #Dimensions of the data frame
dim(all_trips2)  #Dimensions of the data frame
dim(all_trips3)  #Dimensions of the data frame

#=====================================
# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS
#=====================================
# Descriptive analysis on ride_length (all figures in seconds)
# Min, Q1, Median, Mean, Q3, Max
summary(all_trips3$ride_length)
# Mode

tripsTitles = c("Mean","Median","Mode","StDev","SD%","Min","Max","N","U. Bound","L. Bound","Outliers count","Outliers %","Skewness","Skewness Pearson")

# Check for outliers and make a good summary
upperbound <- unname(quantile(all_trips3$ride_length,na.rm = T,probs = c(0.75)) + IQR(all_trips3$ride_length)*1.5)
lowerbound <- unname(quantile(all_trips3$ride_length,na.rm = T,probs = c(0.25)) - IQR(all_trips3$ride_length)*1.5)
outliers_count <- as.numeric(count(filter(all_trips3, all_trips3$ride_length > upperbound))[[1,1]])
skewness_trips <- skewness(all_trips3$ride_length, na.rm =T)
skewness_pearson <- (3 * (mean(all_trips3$ride_length) - median(all_trips3$ride_length))/sd(all_trips3$ride_length))

# Manual table creation with important info (mostly for practice)
tripsValues = c(mean(all_trips3$ride_length),
                median(all_trips3$ride_length),
                getmode(all_trips3$day_of_week),
                sd(all_trips3$ride_length),
                (sd(all_trips3$ride_length)/mean(all_trips3$ride_length)),
                min(all_trips3$ride_length),
                max(all_trips3$ride_length),
                nrow(all_trips3),
                upperbound,
                lowerbound,
                outliers_count,
                (outliers_count / nrow(all_trips3)) * 100,
                skewness_trips,
                skewness_pearson)
trips_desc = data.frame(tripsTitles, tripsValues); print(trips_desc)

# Compare members and casual users
aggregate(all_trips3$ride_length ~ all_trips3$member_casual, FUN = mean)
aggregate(all_trips3$ride_length ~ all_trips3$member_casual, FUN = median)
aggregate(all_trips3$ride_length ~ all_trips3$member_casual, FUN = max)
aggregate(all_trips3$ride_length ~ all_trips3$member_casual, FUN = min)

# See the average ride time by each day for members vs casual users
aggregate(all_trips3$ride_length ~ all_trips3$member_casual + all_trips3$day_of_week, FUN = mean)

# Notice that the days of the week are out of order. Let's fix that.
all_trips3$day_of_week <- ordered(all_trips3$day_of_week, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# Now, let's run the average ride time by each day for members vs casual users
aggregate(all_trips3$ride_length ~ all_trips3$member_casual + all_trips3$day_of_week, FUN = mean)

#=====================================
# VISUALIZATIONS
#=====================================
# Interesting idea to get more into common routes
#colnames(all_trips3)
#all_trips_geo <- select(all_trips3, member_casual, day_of_week, start_lat, start_lng)
#all_trips_geo <- filter(all_trips_geo, member_casual == "casual")

# analyze ridership data by type and weekday
all_trips3 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(member_casual, weekday)								# sorts

# Let's visualize the number of rides by rider type
all_trips3 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Number of rides by rider type",
       x = "Day of the week",
       y = "Number of rides")

# Let's create a visualization for average duration
all_trips3 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")+
  labs(title = "Average trip duration",
       x = "Day of the week",
       y = "Average duration")

#=================================================
# STEP 5: EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
#=================================================
# Create a csv file that we will visualize in Excel, Tableau, or my presentation software
counts <- aggregate(all_trips3$ride_length ~ all_trips3$member_casual + all_trips3$day_of_week, FUN = mean)

trips_summary <- trips_desc

# Separate by months
counts2 <- aggregate(all_trips3$ride_length ~ all_trips3$member_casual + all_trips3$day_of_week, FUN = length)

# Separate by months
counts3 <- aggregate(all_trips3$ride_length ~ all_trips3$member_casual + all_trips3$month, FUN = length)

# Average ride length
write.csv(counts, file = 'YOURFOLDERPATH/avg_ride_length.csv')
# Average ride count
write.csv(counts2, file = 'YOURFOLDERPATH/avg_ride_count.csv')
# Rides by month
write.csv(counts3, file = 'YOURFOLDERPATH/rides_by_month.csv')
# Trips summary
write.csv(trips_summary, file = 'YOURFOLDERPATH/trips_summary.csv')