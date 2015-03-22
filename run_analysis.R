## Getting and Cleaning Data
## Course Project
## Create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library("dplyr")

## Step 1

## Features
featuresTest <- read.table("test/X_test.txt")
featuresTrain <- read.table("train/X_train.txt")
featuresData <- rbind(featuresTest,featuresTrain)
featuresNames <- read.table("features.txt")
names(featuresData) <- featuresNames$V2

## Activity
activityTest <- read.table("test/Y_test.txt")
activityTrain <- read.table("train/Y_train.txt")
activityData <- rbind(activityTest,activityTrain)
names(activityData) <- c("Activity")

## Subject
subjectTest <- read.table("test/subject_test.txt")
subjectTrain <- read.table("train/subject_train.txt")
subjectData <- rbind(subjectTest,subjectTrain)
names(subjectData) <- c("Subject")

temp <- cbind(subjectData, activityData)
data <- cbind(temp,featuresData)

## Step 2

selectFeaturesNames <- featuresNames$V2[grep("mean\\(\\)|std\\(\\)",featuresNames$V2)]
selectNames <- c("Subject","Activity",as.character(selectFeaturesNames))
data <- subset(data,select=selectNames)

## Step 3

activityNames <- read.table("activity_labels.txt")
data[,2] <- activityNames[data[,2],2]

## Step 4

## Relabel with more descriptive names
names(data) <-gsub("^t", "time", names(data))
names(data) <-gsub("^f", "frequency", names(data))
## Clean up variables with 'BodyBody' in name
names(data) <-gsub("BodyBody", "Body", names(data))

## Step 5

data2 <- aggregate(. ~Subject + Activity, data, mean)
data2 <- data2[order(data2$Subject,data2$Activity),]

write.table(data2, file="tidydata.txt",row.name=FALSE)
