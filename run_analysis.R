# You need to have the data in the current working directory, under 'UCI HAR Dataset', in the same format as initialy
# (just unzip the zip in the working directory)

# Getting informations
activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activity.id", 
                                                                            "activity"))

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("col", 
                                                                     "name"))
features$name <- gsub("-", ".", features$name)
features$name <- gsub("\\(\\)", "", features$name)

# Reading training set

train.data <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$name)
train.activity <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = ("activity.id"))
train.subject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = ("subject"))
train.data <- train.data[, grepl("(mean|std)", names(train.data))]

train <- cbind(train.activity, train.subject, set = "train", train.data)
train <- merge(activity, train)[-1]

# Reading test data

test.data <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$name)
test.activity <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = ("activity.id"))
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = ("subject"))
test.data <- test.data[, grepl("(mean|std)", names(test.data))]

test <- cbind(test.activity, test.subject, set = "test", test.data)
test <- merge(activity, test)[-1]

# Merging test and training

data <- rbind(train, test)

# Average by activity and subject

library(plyr)
data.mean <- ddply(data, .(activity, subject), numcolwise(mean))
write.csv(data.mean, "tidy_data.csv")

# display part of the table, for illustration purpose
data.mean[1:5, 1:5]
