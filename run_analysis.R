# Getting and Cleaning Data Project
# 
# C. Wilson <wilsonchr@gmail.com>
#
# This script produces the results required for the Getting and Cleaning Data 
# project.  The requirements for the project were as follows:
#   1. Merge the training and test sets to create one data set
#   2. Extract the measurements on the mean and standard deviation
#   3. Use descriptive activity names to name the activities
#   4. Appropriately label the data set with descriptive variable names
#   5. Create a second independent data set with the average of each variable
#      for each activity and each subject
#
# Inputs:
#
# Produces:
#

library(plyr)

# Get the feature labels and fix them up to be nicer later on
feature_labels <- read.table("./UCI HAR Dataset/features.txt", col.names = c("id","name"))
feature_labels$name <- gsub("\\()", "", as.vector(feature_labels$name))
feature_labels$name <- gsub("-", "_", as.vector(feature_labels$name))
feature_labels$name <- gsub("angle\\(", "angle_", as.vector(feature_labels$name))
feature_labels$name <- gsub(",", "_", as.vector(feature_labels$name))
feature_labels$name <- gsub(")", "", as.vector(feature_labels$name))

#Get the activity names
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names=c("id","name"))

## TRAINING DATA ##
# Get's the volunteer ID
volunteer_id_train <- read.table(file="./UCI HAR Dataset/train/subject_train.txt", col.names = c("volunteer_id"))
# Create a column that designates that this set of data is from the "test" set
#test_col <- rep("test", length(volunteer_id_test$volunteer_id))
# Read the activity performed
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("activity"))
# Map the activity name to the activity id
activity_train$activity <- mapvalues(activity_train$activity, activity_names$id, as.vector(activity_names$name))
# Read the feature data
feature_data_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = feature_labels$name)
feature_data_train_subset <- feature_data_train[,grep(".*mean.*|.*std.*", names(feature_data_train), value = TRUE)]
train_data <- cbind(volunteer_id_train, activity_train, feature_data_train_subset)

## TEST DATA ##
# Get's the volunteer ID
volunteer_id_test <- read.table(file="./UCI HAR Dataset/test/subject_test.txt", col.names = c("volunteer_id"))
# Create a column that designates that this set of data is from the "test" set
#test_col <- rep("test", length(volunteer_id_test$volunteer_id))
# Read the activity performed
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("activity"))
# Map the activity name to the activity id
activity_test$activity <- mapvalues(activity_test$activity, activity_names$id, as.vector(activity_names$name))
# Read the feature data
feature_data_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = feature_labels$name)
feature_data_test_subset <- feature_data_test[,grep(".*mean.*|.*std.*", names(feature_data_test), value = TRUE)]
test_data <- cbind(volunteer_id_test, activity_test, feature_data_test_subset)

# Combine the TEST and TRAIN data into a single data set
tidy_data <- rbind(train_data, test_data)

# Create the second tidy data set by grouping by each participant, then activity and then take the mean
