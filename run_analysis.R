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
# Expects:
#   This script should be run within the same directory as the dataset.
#
# Produces:
#   Two dataset files:
#     1. The merged dataset of train and test sets (combined_dataset.txt)
#     2. The aggregated test set of the mean of each variable for each activity
#        and each test subject.
#

library(plyr)
library(reshape)
library(reshape2)

# Get the feature labels and fix them up to be nicer later on (requirement 4)
feature_labels <- read.table("./UCI HAR Dataset/features.txt", 
                             col.names = c("id","name"))
feature_labels$name <- gsub("\\()", "", as.vector(feature_labels$name))
feature_labels$name <- gsub("-", "_", as.vector(feature_labels$name))
feature_labels$name <- gsub("angle\\(", "angle_", as.vector(feature_labels$name))
feature_labels$name <- gsub(",", "_", as.vector(feature_labels$name))
feature_labels$name <- gsub(")", "", as.vector(feature_labels$name))

#Get the activity names
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                             col.names=c("id","name"))

## TRAINING DATA ###############################################################
# Get's the volunteer ID
volunteer_id_train <- read.table(file="./UCI HAR Dataset/train/subject_train.txt",
                                 col.names = c("volunteer_id"))
# Read the activity performed
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                             col.names = c("activity"))
# Map the activity name to the activity id (requirement 3)
activity_train$activity <- mapvalues(activity_train$activity, activity_names$id, 
                                     as.vector(activity_names$name))
# Read the feature data
feature_data_train <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                                 col.names = feature_labels$name)
# Extract the mean and std data only (requirement 2)
feature_data_train_subset <- feature_data_train[,grep(".*mean.*|.*std.*", 
                                                      names(feature_data_train), 
                                                      value = TRUE)]
train_data <- cbind(volunteer_id_train, activity_train, feature_data_train_subset)

## TEST DATA ###################################################################
# Get's the volunteer ID
volunteer_id_test <- read.table(file="./UCI HAR Dataset/test/subject_test.txt", 
                                col.names = c("volunteer_id"))
# Read the activity performed
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                            col.names = c("activity"))
# Map the activity name to the activity id (requirement 3)
activity_test$activity <- mapvalues(activity_test$activity, activity_names$id, 
                                    as.vector(activity_names$name))
# Read the feature data
feature_data_test <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                                col.names = feature_labels$name)
# Extract the mean and std data only (requirement 2)
feature_data_test_subset <- feature_data_test[,grep(".*mean.*|.*std.*",
                                                    names(feature_data_test), 
                                                    value = TRUE)]
test_data <- cbind(volunteer_id_test, activity_test, feature_data_test_subset)

## COMBINE #####################################################################
# Combine the TEST and TRAIN data into a single data set (requirement 1)
tidy_data <- rbind(train_data, test_data)
write.table(tidy_data, file="combined_dataset.txt", row.name=FALSE)

# Create the second tidy data set by grouping by each participant, then activity
# and then take the mean
melted <- melt(tidy_data, id.vars=c("volunteer_id","activity"))
tidy_data2 <- dcast(melted,volunteer_id + activity ~ variable, mean)
tidy_data2 <- sort_df(tidy_data2, c("volunteer_id", "activity"))

# Adjust the column names so that they better represent what's going on
tidy_data_names <- names(tidy_data2)
new_tidy_data_names <- c(tidy_data_names[1:2], 
                         paste("average",
                               tidy_data_names[3:length(tidy_data_names)],
                               sep="_"
                               )
                         )
names(tidy_data2) <- new_tidy_data_names
# Write out the new tidy dataset (requirement 5)
write.table(tidy_data2, file="tidy_dataset.txt", row.name=FALSE)
