library(dplyr)
library(janitor)
original_wd = getwd()
proj_dir = getwd() #file.path("3_Getting_Cleaning_Data", "project")
data_dir = file.path(proj_dir, "data")

#Task 0.1: Download data
if(!file.exists(proj_dir)){
  dir.create(proj_dir, recursive=TRUE)
}

#download and unzip data if it does not exist
if(!file.exists(data_dir)){
  dir.create(data_dir)
}


fileName = file.path(data_dir, "project_data.zip")
if(!file.exists(fileName)){
  fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,fileName )
  unzip(fileName, exdir = data_dir)
}


#Task 0.2: Load downloaded data into data frames 

#load names and labels for data
X_names = read.table(file.path(data_dir, "UCI HAR Dataset/features.txt"))
X_names =list(X_names$V2)
X_names = X_names[[1]]
activity_labels =  read.table(file.path(data_dir, "UCI HAR Dataset/activity_labels.txt"), col.names = c("activity_id","activity_label") )


#load Train data
y_train = read.table(file.path(data_dir, "UCI HAR Dataset/train/y_train.txt"), col.names = "Y")
X_train = read.table(file.path(data_dir, "UCI HAR Dataset/train/X_train.txt"), col.names = X_names)

subject_train = read.table(file.path(data_dir, "UCI HAR Dataset/train/subject_train.txt"), col.names = "subject")

#load Test data
y_test = read.table(file.path(data_dir, "UCI HAR Dataset/test/y_test.txt"), col.names = "Y")
X_test = read.table(file.path(data_dir, "UCI HAR Dataset/test/X_test.txt"), col.names = X_names)
subject_test = read.table(file.path(data_dir, "UCI HAR Dataset/test/subject_test.txt"), col.names = "subject")


#Task 1: Merge training and test sets to create one master data set
master_train = cbind(merge(y_train, activity_labels, by.x="Y", by.y="activity_id"), subject_train , X_train)
master_train$test_train = "TRAIN"


master_test = cbind(merge(y_test, activity_labels, by.x="Y", by.y="activity_id"), subject_test,  X_test)
master_test$test_train = "TEST"


master_data = rbind(master_test, master_train)


#Task 2: Remove measurements that do not have mean or std in their names
X_names = as.character(names(X_train))
X_names_keep = grep("([Mm][Ee][Aa][Nn]|[Ss][Tt][Dd])", X_names)
X_names_drop = as.character(X_names[-X_names_keep])

master_data = select(master_data, -one_of(X_names_drop))



#Task 3: Use Descriptive Activity names
#done in initial load

#Task 4: Use Descriptive Variable names
#clean names
master_data = janitor::clean_names(master_data)
names(master_data) = gsub("acc", "acceleration", names(master_data))
names(master_data) = gsub("mag", "magnitude", names(master_data))
names(master_data) = gsub("^t", "time", names(master_data))
names(master_data) = gsub("^f", "frequency", names(master_data))

#master_data = cbind(master_data$test_train, master_data[,2:count(names(master_data))])
#Task 5: Create a secon, indpendent tidy data set with avg variable for each activity and each subject
summary_data = master_data %>%
  group_by(activity_label, subject) %>%
  summarise_all(mean)

#Task 6: Export data to csv
write.table(names(master_data), "features.csv", row.names = FALSE , col.names=FALSE)
write.csv(master_data, "master_data.csv")
write.csv(summary_data,  "summary_data.csv")

setwd(original_wd)

