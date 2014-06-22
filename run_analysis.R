
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


