# The purpose of this project is to demonstrate your ability to collect, 
# work with, and clean a data set. The goal is to prepare tidy data that 
# can be used for later analysis. You will be graded by your peers on a 
# series of yes/no questions related to the project. You will be required 
# to submit: 1) a tidy data set as described below, 2) a link to a Github 
# repository with your script for performing the analysis, and 3) a code 
# book that describes the variables, the data, and any transformations or 
# work that you performed to clean up the data called CodeBook.md. You 
# should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.  
# 
# One of the most exciting areas in all of data science right now is 
# wearable computing - see for example this article . Companies like Fitbit, 
# Nike, and Jawbone Up are racing to develop the most advanced algorithms to 
# attract new users. The data linked to from the course website represent data 
# collected from the accelerometers from the Samsung Galaxy S smartphone. A full 
# description is available at the site where the data was obtained: 
#   
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# 
# Here are the data for the project: 
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
require(data.table)
## Stage 1
# read features
features <- read.table("./data/features.txt")
names(features) <- c("num", "name")
# read features
activity <- read.table("./data/activity_labels.txt")
names(activity) <- c("code", "name")
# read test data
test.x <- read.table("./data/test/X_test.txt")
names(test.x) <- features$name
test.y <- read.table("./data/test/y_test.txt")
names(test.y) <- "activity"
test.st <- read.table("./data/test/subject_test.txt")
names(test.st) <- "subjectId"

#merge test data
test.m <- cbind(test.x, test.y, test.st)

# read train data
train.x <- read.table("./data/train/X_train.txt")
names(train.x) <- features$name
train.y <- read.table("./data/train/y_train.txt")
names(train.y) <- "activity"
train.st <- read.table("./data/train/subject_train.txt")
names(train.st) <- "subjectId"

#merge train data
train.m <- cbind(train.x, train.y, train.st)
#merge train and test data
dataSet <- rbind(train.m, test.m)

## Stage 2
# select features containing "mean" and "std"
featuresSubSet <- c(grep("mean[(]|std[(]", features[,2]), ncol(dataSet)-1, ncol(dataSet))

# select data for selected features + subject + activity
dataSet <- dataSet[, featuresSubSet]

## Stage 3
# descriptive activity names to name the activities
dataSet$activity <- as.character(factor(dataSet$activity, labels=activity$name))

## Stage 4
#raname columns
colNames <- names(dataSet)
colNames <-gsub("Acc", " Accelerometer", colNames)
colNames <-gsub("Gyro", " Gyroscope", colNames)
colNames <-gsub("Mag", " Magnitude", colNames)
colNames <-gsub("Jerk", " Jerk", colNames)
colNames <-gsub("^t", "Time", colNames)
colNames <-gsub("^f", "Frequency", colNames)
colNames <-gsub("mean[(][)]", "Mean", colNames)
colNames <-gsub("std[(][)]", "StandardDeviation", colNames)
colNames <-gsub("activity", "Activity", colNames)
colNames <-gsub("subjectId", "Subject.Id", colNames)
names(dataSet) <- make.names(colNames)
#write data
write.table(dataSet, "./data/clean_data.txt")

## Stage 5
# select data withoud activity and subject
NewTidyData <- dataSet[,-c(ncol(dataSet)-1, ncol(dataSet))]

# calculated aggregated statistics
NewTidyData <- aggregate(NewTidyData, by = list(dataSet$Activity, dataSet$Subject.Id), mean)

# write data
write.table(NewTidyData, "./data/tidy_data.txt")


