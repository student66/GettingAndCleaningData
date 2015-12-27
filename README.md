This repo includes the work foe the Getting and Cleaning Data assignment.

`run_analysis.R`

This script downloads the original dataset ZIP, unzips it, and performs the required transformations.

The end result is saved as `proj_result.txt'


The following transformations are performed on the original data set - this is based on the requirement for the project:

 - Merged the training and the test sets to create one data set.
 - Extracted only the measurements on the mean and standard deviation for each measurement. 
 - Used descriptive activity names to name the activities in the data set.
 - Labeled the data set with descriptive variable names - consistent with the original data set. 
 - Created a second data set with the average of each variable for each activity and each subject.