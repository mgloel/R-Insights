setwd("/Users/matthiasgloel/RWorkShop/")

schedule <- read.csv("active_spots_2017.csv", sep=";")

# add columns 
schedule$cost_per_contact <- schedule$netMedia/schedule$grossReach 
schedule$cost_category <- ifelse(schedule$netMedia > 10000, 'expensive',
                                 ifelse(schedule$netMedia > 5000, 'medium', 'low'))


# select, filter, arrange, mutate
library(dplyr)
names(schedule)

# Recode values in column
schedule$clusterId <- recode(schedule$clusterId, '1'='Performance','2'='Volume', '3'='Awareness')

small_table <- select(schedule, id, programName, name)
performance_spots <- filter(schedule, clusterId == 'Performance')
awareness_spots <- filter(schedule, clusterId == 'Awareness')

performance_spots <- arrange(performance_spots, netMedia)

# groupby - summarise
spots_grouped <- group_by(schedule, name) %>%
                    summarise(avg_netMedia = mean(netMedia),
                              median_uplift = median(grossReach),
                              no_spots = n())


# handle datetimes strptime(a$time, "%Y-%m-%d %H:%M:%S")
schedule$time <- strptime(schedule$time,"%Y-%m-%d %H:%M:%S" )
schedule$day <- as.character(as.Date(schedule$time))
schedule$monthname <- months.POSIXt(schedule$time)

# merge, rbind cbind 
merged_frames <- merge(schedule, small_table, by.x='id', by.y='id')


spots_per_cluster<- table(schedule$clusterId)
barplot(spots_per_cluster)

# Exercise
# Caluclate mean of net media
# net cost per channel

schedule$upliftVisits <- as.numeric(as.character(schedule$upliftVisits))
# Scatter Plot
schedule$clusterId <- as.factor(schedule$clusterId)
# A cloud 
plot(schedule$upliftVisits ~ schedule$grossReach) 


abline(lm(schedule$upliftVisits ~ schedule$grossReach))
# Still a cloud
plot(schedule$upliftVisits ~ schedule$grossReach, col=as.factor(schedule$clusterId))
legend("topright", legend=levels(as.factor(schedule$clusterId)), pch=16, col=unique(as.factor(schedule$clusterId)))

cor.test(schedule$upliftVisits, schedule$grossReach)

#library("png")
#pp <- readPNG("inster_statistical_study.png")
# plot(pp)

#library(imager)
#im<-load.image("inster_statistical_study.png")
#plot(im)
