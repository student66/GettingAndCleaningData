#
# run_analysis.R
#
#
# The goal is to prepare tidy data that can be used for later analysis. 
# You will be graded by your peers on a series of yes/no questions related to the project. 
# You will be required to submit: 
#   1) a tidy data set as described below, 
#   2) a link to a Github repository with your script for performing the analysis, and 
#   3) a code book that describes the variables, the data, and any transformations or work 
#      that you performed to clean up the data called CodeBook.md. 
#      
# You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.

# The data linked to from the course website represent data collected from the accelerometers 
# from the Samsung Galaxy S smartphone. A full description is available at the site where the 
# data was obtained: 
#   
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Data:
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# Ref:
#   http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/
#
# You should create one R script called run_analysis.R that does the following. 
#   o Merges the training and the test sets to create one data set.
#   o Extracts only the measurements on the mean and standard deviation for each measurement. 
#   o Uses descriptive activity names to name the activities in the data set
#   o Appropriately labels the data set with descriptive variable names. 
#   o From the data set in step 4, creates a second, independent tidy data set with the average 
#     of each variable for each activity and each subject.

# start clean
#
rm(list=ls())

# Download and unzip data
#
remote.zip.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
local.zip.file <- "./data/project_data_set.zip" # make sure the ./data dir exists
download.file(remote.zip.url, local.zip.file)
unzip(local.zip.file, exdir="./data")

# work file names
#
train.X.file <- "data/unzipped/train/X_train.txt"
test.X.file  <- "data/unzipped/test/X_test.txt"
train.y.file <- "data/unzipped/train/y_train.txt"
test.y.file  <- "data/unzipped/test/y_test.txt"
train.S.file <- "data/unzipped/train/subject_train.txt"
test.S.file  <- "data/unzipped/test/subject_test.txt"

# Read the data sets: X, y, Subject
#
train.df <- read.table(train.X.file, sep = "" , header = FALSE)
test.df  <- read.table(test.X.file,  sep = "" , header = FALSE)
train.y.df <- read.table(train.y.file, sep = "" , header = FALSE)
test.y.df  <- read.table(test.y.file,  sep = "" , header = FALSE)
train.s.df <- read.table(train.S.file, sep = "" , header = FALSE)
test.s.df  <- read.table(test.S.file,  sep = "" , header = FALSE)

# Merge the training and the test sets to create one data set
# NOTE: will add activity and subject later
#
combo.df <- rbind(train.df, test.df)

# Check out the dimensions
dim(train.df); dim(test.df); dim(combo.df)

# Extract only the measurements on the mean and standard deviation for each measurement

#
# First load the feature names in a separate data frame;
# To be used temporarily as a helper.
#
features.info.file <- "data/unzipped/features.txt"
features.info <- read.table(features.info.file, sep = "" , header = FALSE)
names(features.info) <- c("index", "name")
head(features.info)

##   index              name
## 1     1 tBodyAcc-mean()-X
## 2     2 tBodyAcc-mean()-Y
## ...

# Now using features.info to select the corresponding feature indexes: mean and std
#
sel.idx <- grep("(-mean\\(|-std\\()", features.info$name)

head(features.info[sel.idx,])

##     1 tBodyAcc-mean()-X
##     2 tBodyAcc-mean()-Y
##     3 tBodyAcc-mean()-Z
##     4  tBodyAcc-std()-X
##     5  tBodyAcc-std()-Y
##     6  tBodyAcc-std()-Z

# Subsetting based on the indexes for -mean and -std

combo.df.subset <- combo.df[,sel.idx]
dim(combo.df.subset)
ncol(combo.df.subset) == length(sel.idx) # should be TRUE

# Now combo.df.subset has only the selected 66 features, with names having -mean() or -std() 

# Appropriately labels the data set with descriptive variable names
# Using the helper dataset features.info to do this:
#
names(combo.df.subset) <- features.info$name[sel.idx]

# check out the result
names(combo.df.subset)
#
## [1] tBodyAcc-mean()-X           tBodyAcc-mean()-Y           tBodyAcc-mean()-Z          
## [4] tBodyAcc-std()-X            tBodyAcc-std()-Y            tBodyAcc-std()-Z           
## [7] tGravityAcc-mean()-X        tGravityAcc-mean()-Y        tGravityAcc-mean()-Z       
## ...



# Use descriptive activity names to name the activities in the data set

# Now first adding the "subject" and "activity" columns to the combined data frame

combo.s.df <- rbind(train.s.df, test.s.df)
names(combo.s.df) <- "Subject"
combo.y.df <- rbind(train.y.df, test.y.df)
names(combo.y.df) <- "Activity"
combo.df.set <- cbind(combo.df.subset, combo.s.df, combo.y.df)

# Then getting the descriptions from the labels txt file to use them

activity.labels.file <- "data/unzipped/activity_labels.txt"
activity.labels <- read.table(activity.labels.file, sep = "" , header = FALSE)
names(activity.labels) <- c("index", "name")
activity.labels

str(combo.df.set$Activity)
combo.df.set$Activity <- factor(combo.df.set$Activity, levels=activity.labels$index, labels=activity.labels$name)

# Now the activity variable in combo.df.set is a factor with appropriate levels and labels (names):
str(combo.df.set$Activity)

## Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 5 5 5 5 5 5 5 5 5 5 ...

table(combo.df.set$Activity)
## WALKING   WALKING_UPSTAIRS WALKING_DOWNSTAIRS            SITTING           STANDING 
## 1722               1544               1406               1777               1906 
## LAYING 
## 1944 


#   o From the data set in step 4, creates a second, independent tidy data set with the average 
#     of each variable for each activity and each subject.
#

library(dplyr)

result <- combo.df.set %>% 
  group_by(Subject, Activity) %>% 
  summarise_each(funs(mean))

write.table(result, file="proj_result.txt", row.name=FALSE)

names(result)

