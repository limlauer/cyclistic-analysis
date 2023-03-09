# Cyclistic data analysis
_Luis Imlauer / March 8, 2023_

## Introduction
Cyclistic is a bike-share company _(based on Divvy data)_, this analysis was my capstone project for the __Google Data Analytics certificate__. All data cleaning and analyzing, as well as summaries were done in __R__. The visualizations were done in __Tableau__.

This repository includes:
* R code used with explanations
* Link to the Tableau dashboard
* Link to the final presentation

## Objective
The objective was to identify how _annual members_ and _casual riders_ use Cyclistic bikes differently to make __marketing decisions__.

## Data sources
I used Cyclistic's (Divvy) bike-share data from the last 12 months, it's located in: https://divvy-tripdata.s3.amazonaws.com/index.html
It's organized in 12 different CSV files, split by month.
_The database is pretty big (Almost 6M observations) so I'm using R; it came from a reliable source (Divvy), and doesn't contain any
personal information._
It includes information about each trip (or ride) made by the users, starting/ending stations, date and time, user type and bike type.

## Important links
### Analysis
* [Data cleaning and analysis](../master/cyclistic_analysis.R)
    > Done in R. Code based on Kevin Hartman's analysis (+info in R file). To replicate the analysis, download the files yourself (they're bigger than 25MB) and place them in the /data/ folder (there is one there as an example). Files can be found in the "Data source" link:
![image](https://user-images.githubusercontent.com/44590316/224054777-04905be0-a915-46e1-ace5-54c9d1761b67.png)
* [Data source](https://divvy-tripdata.s3.amazonaws.com/index.html "Divvy bike-share data")
    > Thanks to Divvy for the data!
    
### Results
* [Final presentation](https://docs.google.com/presentation/d/1L28duDbP0ayWr3j5Hs_M1Y43GHCfoFArxZKVhNR2zjE/edit?usp=sharing "Google spreadsheets presentation")
    > Includes the 3 recommendations for the marketing team (see comments below the slides).
* [Tableau Dashboard](https://public.tableau.com/app/profile/luis2877/viz/Cyclisticmembertypeanalysis/Cyclisticdashboard?publish=yes "Dashboard made from the bike-share data")
    > All visualizations were made in Tableau.
    
### Social media
* [My LinkedIn](https://www.linkedin.com/in/luis-imlauer/ "LinkedIn - Luis Imlauer")
* [My Portfolio](https://limlauer.github.io/ "Luis Imlauer portfolio")
