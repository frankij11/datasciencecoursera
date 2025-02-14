# Getting and Cleaning Data Course project

This repo contains the R scripts to get and clean the UCI HAR Dataset. The [run_analysis.R](run_analysis.R) file contains the source code to complete all tasks. Running the file will:
1. download the dataset
2. clean the data
3. export data frames to csv

```R
source("run_analysis.R")
```

## Tasks

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Outputs

1. **[master_data.csv](master_data.csv)**: *This file contains the tidy data set after completing steps 1 - 4*

2. **[summary_data.csv](summary_data.csv)**: *This file contains the summary tidy data set after completing step 5*

3. **[features.csv](features.csv)**: This file contains a list of the variables
