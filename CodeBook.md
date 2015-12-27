The final result `proj_result.txt` is derived from the data downloaded from `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`.

The description of the original data set can be found at `http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones`.

 - The result includes the training and test datasets merged;
 - The result includes the activity labels and subjects added.

####Variables

 - `Subject` : the code of the subject from the original dataset.
 - `Activity` : the activity name as derived from the original data set.
 - `t*-mean()*` : Mean values and standard deviation for the corresponding original values in the time domain.
     - body acceleration
     - Gravity
     - Body acceleration jerk
     - Body giroscope 
     - Bodu giroscope jerk
 - `-mean()` in the variable name  indicates mean value, `-std()` indicates standard deviation.
 - The values are available separately for each axis X, Y and Z, and also as magnitude.
 - The calues in the time domain start with 't', while the values in the frequency domaiun start weith `f`.
 - In the end result the values are averaged grouped by subject and activity.