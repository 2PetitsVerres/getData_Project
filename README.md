Getting and Cleaning Data: course project
=========================================

You need to have the data in the current working directory, under 'UCI HAR Dataset', in the same format as initialy
(just unzip the zip in the working directory)

## Getting informations

I first start to read the activity label and the features names. I also format the features names to another naming convention (which does not match exactly the one proposed in week 4 of the lecture, but I prefer this format)

Name of the features will be:

- (t|f)Feature.mean.X
- (t|f)Feature.std.X

where t or f indicate if the measurement is in time or frequency domain, X is the axis direction of the measurment, std or mean are self explanatory.


```r
activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activity.id", 
    "activity"))

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("col", 
    "name"))
features$name <- gsub("-", ".", features$name)
features$name <- gsub("\\(\\)", "", features$name)
```


## Reading training set
I will now read and format the training set. For this I need to merge data from different files:

- the actual measurement, from the X_train.txt file. The column name correspond to the features names from the previous section
- the activity, from the y_train.txt file.
- the test subject, from the subject_train.txt file

Once I have all these informations, I combine them using cbind. I add an information about the fact that they are comming from the training set, to have this knowledge once I will merge test and training data set in a later section (even if this is not need for this project, it's probably a good idea to keep the tracability)
Activity is also replaced by labels.


```r
train.data <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$name)
train.activity <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = ("activity.id"))
train.subject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = ("subject"))
train.data <- train.data[, grepl("(mean|std)", names(train.data))]

train <- cbind(train.activity, train.subject, set = "train", train.data)
train <- merge(activity, train)[-1]
```


## Reading test data
Exactly the same as previous section, with the test data. (I should have done a function)


```r
test.data <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$name)
test.activity <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = ("activity.id"))
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = ("subject"))
test.data <- test.data[, grepl("(mean|std)", names(test.data))]

test <- cbind(test.activity, test.subject, set = "test", test.data)
test <- merge(activity, test)[-1]
```


## Merging
Create dataset containing both test and training data. Straightforward.


```r
data <- rbind(train, test)
```


## Average by activity and subject

Creation of the tidy data set containing the average for each variable, by subject and activity. Saving it to a csv file for upload.


```r
library(plyr)
data.mean <- ddply(data, .(activity, subject), numcolwise(mean))
write.csv(data.mean, "tidy_data.csv")

# display part of the table, for illustration purpose
data.mean[1:5, 1:5]
```

```
##   activity subject tBodyAcc.mean.X tBodyAcc.mean.Y tBodyAcc.mean.Z
## 1   LAYING       1          0.2216        -0.04051         -0.1132
## 2   LAYING       2          0.2814        -0.01816         -0.1072
## 3   LAYING       3          0.2755        -0.01896         -0.1013
## 4   LAYING       4          0.2636        -0.01500         -0.1107
## 5   LAYING       5          0.2783        -0.01830         -0.1079
```

