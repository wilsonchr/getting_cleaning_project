# Getting and Cleaning Data Project

For this project the following requirements existed:

1. Merge the training and test sets to create one data set
2. Extract the measurements on the mean and standard deviation
3. Use descriptive activity names to name the activities
4. Appropriately label the data set with descriptive variable names
5. Create a second independent data set with the average of each variable for each activity and each subject

The script run_analysis.R accomplishes these tasks by performing the following:
1. Reads in features.txt to get the feature names
2. Reads in activity_labels.txt to get the activity names
3. Reads the train data
  1. Reads the subject_train.txt file to get the volunteers part of the training set
  2. Reads y_train.txt to get the activities performed
  3. Translates the activity ids to names
  4. Reads X_train.txt to get feature data and applies names to the columns
  5. Selects only the mean and std columns
4. Reads the test data
  1. Reads the subject_text.txt file to get the voluneers part of the test set
  2. Reads the y_test.txt to get the activities performed
  3. Translates the activity ids to names
  4. Reads X_test.txt to get the feature data and applies names to the columns
  5. Selects only the mean and std columns
5. Combines the two data sets and writes it to combined_dataset.txt
6. Groups and aggregates data based on the volunteer and activity, producing a table of means of all the features for each group
7. Writes out the new dataset to tidy_dataset.txt

A codebook is available as tidy_dataset_info.md

## Running run_analysis.R

### Requirements

- The working directory should contain the R script as well as the original dataset as unzipped.  
- The script requires the libraries the following libraries: reshape, reshape2 and plyr

### Running

source("run_analysis.R")

